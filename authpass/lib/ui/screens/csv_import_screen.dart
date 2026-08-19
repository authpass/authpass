import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/l10n-generated/app_localizations.dart';
import 'package:authpass/utils/csv_importer.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('csv_import');

// Localised display names live here rather than in csv_importer.dart because
// AppLocalizations is a UI dependency and the importer utility is pure logic.
extension _CsvFieldLabel on CsvFieldType {
  String displayName(AppLocalizations loc) {
    switch (this) {
      case CsvFieldType.title:
        return loc.fieldTitle;
      case CsvFieldType.username:
        return loc.fieldUserName;
      case CsvFieldType.password:
        return loc.fieldPassword;
      case CsvFieldType.url:
        return loc.fieldWebsite;
      case CsvFieldType.notes:
        return loc.fieldNotes;
    }
  }
}

/// Three-step screen that guides the user through importing passwords from a
/// CSV file into the currently open kdbx database.
///
/// Step 1 – [_SelectFileStep]:  pick a .csv file via the system file picker.
/// Step 2 – [_MapColumnsStep]:  assign each CSV column to an AuthPass field
///           (or skip it). Headers are auto-detected where possible.
/// Step 3 – [_PreviewStep]:    review the first few rows, then confirm import.
class CsvImportScreen extends StatefulWidget {
  const CsvImportScreen({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
        builder: (_) => const CsvImportScreen(),
        settings: const RouteSettings(name: '/csv-import'),
      );

  @override
  State<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends State<CsvImportScreen> {
  /// All rows from the CSV, index 0 being the header row.
  List<List<String>> _rows = [];

  /// One entry per CSV column — which AuthPass field it maps to, or null to skip.
  List<CsvFieldType?> _mappings = [];

  _Step _step = _Step.selectFile;
  bool _importing = false;

  List<String> get _headers => _rows.isEmpty ? [] : _rows.first;
  List<List<String>> get _dataRows =>
      _rows.length > 1 ? _rows.sublist(1) : [];

  // ─── Step 1: pick a file ────────────────────────────────────────────────

  Future<void> _pickFile() async {
    const XTypeGroup csvType = XTypeGroup(
      label: 'CSV',
      extensions: <String>['csv'],
      mimeTypes: <String>['text/csv', 'text/plain'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [csvType]);
    if (file == null) {
      return;
    }

    try {
      final content = await file.readAsString();
      final rows = parseCsvContent(content);

      if (rows.isEmpty || (rows.length == 1 && rows.first.isEmpty)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).csvImportErrorNoData),
            ),
          );
        }
        return;
      }

      setState(() {
        _rows = rows;
        // Auto-detect mappings from header names; the user can adjust on step 2.
        _mappings = rows.first.map(guessCsvField).toList();
        _step = _Step.mapColumns;
      });
    } catch (e, s) {
      _logger.severe(nonNls('Failed to read or parse CSV file'), e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  // ─── Step 3: create entries and save ────────────────────────────────────

  Future<void> _import() async {
    final loc = AppLocalizations.of(context);

    if (!_mappings.any((m) => m != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.csvImportErrorNoMappedFields)),
      );
      return;
    }

    setState(() {
      _importing = true;
    });
    try {
      final kdbxBloc = context.read<KdbxBloc>();
      if (kdbxBloc.openedFilesKdbx.isEmpty) {
        _logger.warning(nonNls('No opened database file found.'));
        return;
      }
      final file = kdbxBloc.openedFilesKdbx.first;
      var imported = 0;
      var skipped = 0;

      // Build lookup sets once so duplicate checks are O(1) per row.
      final detector = DuplicateDetector(file);
      for (final row in _dataRows) {
        // Skip rows that already exist in the database (title + username match).
        if (detector.isDuplicate(row, _mappings)) {
          skipped++;
          continue;
        }

        final entry = kdbxBloc.createEntry(file: file);
        for (var col = 0; col < _mappings.length && col < row.length; col++) {
          final field = _mappings[col];
          if (field == null) {
            continue;
          }
          final value = row[col].trim();
          if (value.isEmpty) {
            continue;
          }
          // Password fields are stored as ProtectedValue so they are
          // encrypted in memory, matching how AuthPass treats manually
          // entered passwords.
          entry.setString(
            field.kdbxKey,
            field.isProtected
                ? ProtectedValue.fromString(value)
                : PlainValue(value),
          );
        }
        imported++;
      }

      await kdbxBloc.saveFile(file);

      if (mounted) {
        final message = skipped > 0
            ? loc.csvImportSuccessWithSkipped(imported, skipped)
            : loc.csvImportSuccessMessage(imported);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.of(context).pop();
      }
    } catch (e, s) {
      _logger.warning('CSV import failed', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _importing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.csvImportScreenTitle)),
      body: _importing
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(loc),
    );
  }

  Widget _buildBody(AppLocalizations loc) {
    switch (_step) {
      case _Step.selectFile:
        return _SelectFileStep(onPickFile: _pickFile);
      case _Step.mapColumns:
        return _MapColumnsStep(
          headers: _headers,
          mappings: _mappings,
          dataRows: _dataRows,
          onMappingChanged: (col, field) {
            setState(() {
              _mappings[col] = field;
            });
          },
          onNext: () {
            setState(() {
              _step = _Step.preview;
            });
          },
        );
      case _Step.preview:
        return _PreviewStep(
          headers: _headers,
          mappings: _mappings,
          dataRows: _dataRows,
          onBack: () {
            setState(() {
              _step = _Step.mapColumns;
            });
          },
          onImport: _import,
        );
    }
  }
}

enum _Step { selectFile, mapColumns, preview }

// ─── Step 1: Select file ────────────────────────────────────────────────────

class _SelectFileStep extends StatelessWidget {
  const _SelectFileStep({required this.onPickFile});

  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.upload_file, size: 64),
            const SizedBox(height: 16),
            Text(
              loc.csvImportSelectFileHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onPickFile,
              icon: const Icon(Icons.folder_open),
              label: Text(loc.csvImportSelectFileButton),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Map columns ────────────────────────────────────────────────────

class _MapColumnsStep extends StatelessWidget {
  const _MapColumnsStep({
    required this.headers,
    required this.mappings,
    required this.dataRows,
    required this.onMappingChanged,
    required this.onNext,
  });

  final List<String> headers;
  final List<CsvFieldType?> mappings;
  final List<List<String>> dataRows;
  final void Function(int col, CsvFieldType? field) onMappingChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Show up to 2 real data rows as a sample beneath each column header.
    final preview = dataRows.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            loc.csvImportMappingTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            loc.csvImportMappingSubtitle,
            style: theme.textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: headers.length,
            itemBuilder: (context, col) {
              final header = headers[col];
              final sampleValues = preview
                  .where((row) => col < row.length)
                  .map((row) => row[col])
                  .where((v) => v.isNotEmpty)
                  .take(2)
                  .join(nonNls(', '));
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              header,
                              style: theme.textTheme.labelLarge,
                            ),
                            if (sampleValues.isNotEmpty)
                              Text(
                                sampleValues,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<CsvFieldType?>(
                        value: mappings[col],
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(loc.csvImportFieldSkip),
                          ),
                          ...CsvFieldType.values.map(
                            (f) => DropdownMenuItem(
                              value: f,
                              child: Text(f.displayName(loc)),
                            ),
                          ),
                        ],
                        onChanged: (val) => onMappingChanged(col, val),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: onNext,
            child: Text(loc.csvImportPreviewTitle),
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: Preview & confirm ──────────────────────────────────────────────

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.headers,
    required this.mappings,
    required this.dataRows,
    required this.onBack,
    required this.onImport,
  });

  final List<String> headers;
  final List<CsvFieldType?> mappings;
  final List<List<String>> dataRows;
  final VoidCallback onBack;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Only show columns the user actually mapped — skipped columns are hidden.
    final mappedCols = <int>[
      for (var i = 0; i < mappings.length; i++)
        if (mappings[i] != null) i,
    ];
    // Show up to 5 rows so the table stays compact on small screens.
    final preview = dataRows.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            loc.csvImportPreviewTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            loc.csvImportPreviewSubtitle(dataRows.length),
            style: theme.textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 48,
                columns: [
                  for (final col in mappedCols)
                    DataColumn(
                      label: Text(
                        mappings[col]!.displayName(loc),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
                rows: [
                  for (final row in preview)
                    DataRow(
                      cells: [
                        for (final col in mappedCols)
                          DataCell(
                            Text(
                              // Never show actual password values in the
                              // preview — show a placeholder instead.
                              mappings[col] == CsvFieldType.password
                                  ? nonNls('••••••••')
                                  : (col < row.length ? row[col] : ''),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: ElevatedButton(
            onPressed: onImport,
            child: Text(loc.csvImportConfirmButton(dataRows.length)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextButton(
            onPressed: onBack,
            child: Text(MaterialLocalizations.of(context).backButtonTooltip),
          ),
        ),
      ],
    );
  }
}

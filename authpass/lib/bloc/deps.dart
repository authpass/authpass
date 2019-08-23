import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:meta/meta.dart';

/// Global resources available throughout the app (using [Provider])
class Deps {
  factory Deps({@required Env env}) {
    final appDataBloc = AppDataBloc();
    return Deps._(
      env: env,
      appDataBloc: appDataBloc,
      kdbxBloc: KdbxBloc(appDataBloc: appDataBloc),
    );
  }

  Deps._({@required this.appDataBloc, @required this.kdbxBloc, @required this.env});

  final Env env;
  final AppDataBloc appDataBloc;
  final KdbxBloc kdbxBloc;
}

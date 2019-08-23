import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:meta/meta.dart';

/// Global resources available throughout the app (using [Provider])
class Deps {
  factory Deps() {
    final appDataBloc = AppDataBloc();
    return Deps._(appDataBloc: appDataBloc, kdbxBloc: KdbxBloc(appDataBloc: appDataBloc));
  }

  Deps._({@required this.appDataBloc, @required this.kdbxBloc});

  final AppDataBloc appDataBloc;
  final KdbxBloc kdbxBloc;
}

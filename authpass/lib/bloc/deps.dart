import 'package:authpass/bloc/analytics.dart';
import 'package:authpass/bloc/app_data.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:meta/meta.dart';

/// Global resources available throughout the app (using [Provider])
class Deps {
  factory Deps({@required Env env}) {
    final appDataBloc = AppDataBloc();
    final analytics = Analytics(env: env);
    return Deps._(
      env: env,
      appDataBloc: appDataBloc,
      analytics: analytics,
      kdbxBloc: KdbxBloc(appDataBloc: appDataBloc, analytics: analytics),
    );
  }

  Deps._({
    @required this.appDataBloc,
    @required this.kdbxBloc,
    @required this.env,
    @required this.analytics,
  });

  final Env env;
  final AppDataBloc appDataBloc;
  final KdbxBloc kdbxBloc;
  final Analytics analytics;
}

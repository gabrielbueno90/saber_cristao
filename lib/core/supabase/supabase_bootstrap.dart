import 'package:saber_cristao/core/app_config.dart';
import 'package:saber_cristao/core/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrapSupabase() async {
  AppConfig.validateRuntimeConfiguration();

  if (SupabaseConfig.url.isEmpty || SupabaseConfig.anonKey.isEmpty) {
    return;
  }

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (error) {
    throw StateError(
      'Falha ao inicializar o Supabase neste build: $error',
    );
  }
}

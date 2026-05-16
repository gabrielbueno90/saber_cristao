import 'package:saber_cristao/core/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrapSupabase() async {
  if (SupabaseConfig.url.isEmpty || SupabaseConfig.anonKey.isEmpty) {
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
}

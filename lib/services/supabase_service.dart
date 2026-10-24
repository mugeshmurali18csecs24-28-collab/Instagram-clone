import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://hbgggxjyzvrovunusjau.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_5uDmNRLbaZ6Y_q_r9eJzxw_e0NHrwpz';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

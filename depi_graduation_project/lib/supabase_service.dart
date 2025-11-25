import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://uztrxupjubheaxxagzyd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6dHJ4dXBqdWJoZWF4eGFnenlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMTc0NjksImV4cCI6MjA3ODc5MzQ2OX0.GDcTRLVFM_i0m9LMDhAR3z97JzM4bZj0FQdKpfiuZTQ',
    );
  }

  static String? get userId => client.auth.currentUser?.id;
}
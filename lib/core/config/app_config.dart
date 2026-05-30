/// Supabase and app configuration via `--dart-define`.
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://kmceonhtubcrrzfpoxra.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttY2Vvbmh0dWJjcnJ6ZnBveHJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxNDg2NzgsImV4cCI6MjA4OTcyNDY3OH0.PJFCnebtx0Z3lbnRClfTkDHyAYnLl5rpphqfHo_z6Vk',
  );
}

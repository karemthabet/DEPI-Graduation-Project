// lib/features/login/data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? name; // name can be null if not set
  final bool? emailVerified;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.emailVerified,
  });

  // Factory constructor to create UserModel from Supabase User object
  factory UserModel.fromSupabaseUser(Map<String, dynamic> user) {
    return UserModel(
      id: user['id'] as String,
      email: user['email'] as String,
      name: user['user_metadata']?['name'] as String?,
      emailVerified: user['email_confirmed_at'] != null,
    );
  }

  // Convert UserModel to Map (optional, useful for saving to local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'emailVerified': emailVerified,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, emailVerified: $emailVerified)';
  }
}

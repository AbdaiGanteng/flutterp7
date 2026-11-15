class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;
  final String? nim; 
  final String? kelas; 

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    this.nim, 
    this.kelas, 
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['nama'] ?? json['name'] ?? '',
      username: json['nim'] ?? json['username'] ?? '',
      email: json['email'] ?? (json['nim'] != null ? '${json['nim']}@students.amikom.ac.id' : ''),
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      companyName: json['kelas'] ?? json['company']?['name'] ?? '',
      nim: json['nim'],
      kelas: json['kelas'],
    );
  }

  String get initial {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }
}
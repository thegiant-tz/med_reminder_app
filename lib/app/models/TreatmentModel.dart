// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// class Treatment {
//   final int id;
//   final String medName;
//   final String unit;
//   final String often;
//   final DateTime time;
//   final String created_at;
//   final String updated_at;
//   Treatment({
//     required this.id,
//     required this.medName,
//     required this.unit,
//     required this.often,
//     required this.time,
//     required this.created_at,
//     required this.updated_at,
//   });

//   Treatment copyWith({
//     int? id,
//     String? name,
//     String? phone,
//     String? email,
//     Map<String, dynamic>? role,
//     String? created_at,
//     String? updated_at,
//   }) {
//     return Treatment(
//       id: id ?? this.id,
//       created_at: created_at ?? this.created_at,
//       updated_at: updated_at ?? this.updated_at, medName: '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'phone': phone,
//       'email': email,
//       'role': role,
//       'created_at': created_at,
//       'updated_at': updated_at,
//     };
//   }

//   factory Treatment.fromMap(Map<String, dynamic> map) {
//     return Treatment(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       phone: map['phone'] as String,
//       email: map['email'] as String,
//       role: map['role'],
//       created_at: map['created_at'] as String,
//       updated_at: map['updated_at'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Treatment.fromJson(String source) => Treatment.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'User(id: $id, name: $name, phone: $phone, email: $email, role: $role, created_at: $created_at, updated_at: $updated_at)';
//   }

//   @override
//   bool operator ==(covariant User other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.name == name &&
//       other.phone == phone &&
//       other.email == email &&
//       other.role == role &&
//       other.created_at == created_at &&
//       other.updated_at == updated_at;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//       name.hashCode ^
//       phone.hashCode ^
//       email.hashCode ^
//       role.hashCode ^
//       created_at.hashCode ^
//       updated_at.hashCode;
//   }
// }

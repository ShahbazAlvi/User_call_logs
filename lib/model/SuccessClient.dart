// class SuccessClientModel {
//   final bool success;
//   final List<Data> data;
//
//   SuccessClientModel({
//     required this.success,
//     required this.data,
//   });
//
//   factory SuccessClientModel.fromJson(Map<String, dynamic> json) {
//     return SuccessClientModel(
//       success: json['success'] ?? false,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => Data.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Data {
//   final String id;
//   final String companyName;
//   final String? person;
//   final String designation;
//   final Product? product;
//   final String status;
//   final List<String> followDates;
//   final List<String> followTimes;
//   final List<String> details;
//   final String action;
//   final String reference;
//   final String? referToStaff;
//   final String contactMethod;
//   final String timeline;
//   final String createdAt;
//   final String updatedAt;
//   final int v;
//
//   Data({
//     required this.id,
//     required this.companyName,
//     this.person,
//     required this.designation,
//     this.product,
//     required this.status,
//     required this.followDates,
//     required this.followTimes,
//     required this.details,
//     required this.action,
//     required this.reference,
//     this.referToStaff,
//     required this.contactMethod,
//     required this.timeline,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['_id'] ?? '',
//       companyName: json['companyName'] ?? '',
//       person: json['person'],
//       designation: json['designation'] ?? '',
//       product: json['product'] != null
//           ? Product.fromJson(json['product'])
//           : null,
//       status: json['status'] ?? '',
//       followDates: List<String>.from(json['followDates'] ?? []),
//       followTimes: List<String>.from(json['followTimes'] ?? []),
//       details: List<String>.from(json['details'] ?? []),
//       action: json['action'] ?? '',
//       reference: json['reference'] ?? '',
//       referToStaff: json['referToStaff'],
//       contactMethod: json['contactMethod'] ?? '',
//       timeline: json['Timeline'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       v: json['__v'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'companyName': companyName,
//       'person': person,
//       'designation': designation,
//       'product': product?.toJson(),
//       'status': status,
//       'followDates': followDates,
//       'followTimes': followTimes,
//       'details': details,
//       'action': action,
//       'reference': reference,
//       'referToStaff': referToStaff,
//       'contactMethod': contactMethod,
//       'Timeline': timeline,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       '__v': v,
//     };
//   }
// }
//
// class Product {
//   final String id;
//   final String name;
//   final int price;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       price: json['price'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'price': price,
//     };
//   }
// }


class SuccessClientModel {
  final bool success;
  final List<Data> data;

  SuccessClientModel({
    required this.success,
    required this.data,
  });

  factory SuccessClientModel.fromJson(Map<String, dynamic> json) {
    return SuccessClientModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

/* ------------------------- DATA MODEL ------------------------- */

class Data {
  final String id;
  final String companyName;
  final Person? person;
  final String designation;
  final Product? product;
  final String status;
  final List<String> followDates;
  final List<String> followTimes;
  final List<String> details;
  final String action;
  final String reference;
  final ReferToStaff? referToStaff;
  final String contactMethod;
  final String timeline;
  final String createdAt;
  final String updatedAt;
  final int v;

  Data({
    required this.id,
    required this.companyName,
    this.person,
    required this.designation,
    this.product,
    required this.status,
    required this.followDates,
    required this.followTimes,
    required this.details,
    required this.action,
    required this.reference,
    this.referToStaff,
    required this.contactMethod,
    required this.timeline,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      person:
      json['person'] != null ? Person.fromJson(json['person']) : null,
      designation: json['designation'] ?? '',
      product:
      json['product'] != null ? Product.fromJson(json['product']) : null,
      status: json['status'] ?? '',
      followDates: List<String>.from(json['followDates'] ?? []),
      followTimes: List<String>.from(json['followTimes'] ?? []),
      details: List<String>.from(json['details'] ?? []),
      action: json['action'] ?? '',
      reference: json['reference'] ?? '',
      referToStaff: json['referToStaff'] != null
          ? ReferToStaff.fromJson(json['referToStaff'])
          : null,
      contactMethod: json['contactMethod'] ?? '',
      timeline: json['Timeline'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyName': companyName,
      'person': person?.toJson(),
      'designation': designation,
      'product': product?.toJson(),
      'status': status,
      'followDates': followDates,
      'followTimes': followTimes,
      'details': details,
      'action': action,
      'reference': reference,
      'referToStaff': referToStaff?.toJson(),
      'contactMethod': contactMethod,
      'Timeline': timeline,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

/* ------------------------- PERSON ------------------------- */

class Person {
  final String id;
  final List<PersonDetail> persons;

  Person({
    required this.id,
    required this.persons,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'] ?? '',
      persons: (json['persons'] as List<dynamic>?)
          ?.map((e) => PersonDetail.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'persons': persons.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonDetail {
  final String fullName;
  final String phoneNumber;

  PersonDetail({
    required this.fullName,
    required this.phoneNumber,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

/* ------------------------- PRODUCT ------------------------- */

class Product {
  final String id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
    };
  }
}

/* ------------------------- REFER TO STAFF ------------------------- */

class ReferToStaff {
  final String id;
  final String username;
  final String email;

  ReferToStaff({
    required this.id,
    required this.username,
    required this.email,
  });

  factory ReferToStaff.fromJson(Map<String, dynamic> json) {
    return ReferToStaff(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
    };
  }
}

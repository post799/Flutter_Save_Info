class Person {
  int id;
  String name;
  String phone;
  Person(this.id, this.name, this.phone);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
    };
    return map;
  }

  Person.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
  }
}

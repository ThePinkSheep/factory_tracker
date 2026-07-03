class Employee {
    final String id;
    final String name;
    final String company;

    Employee({required this.id, required this.name, required this.company});

    factory Employee.fromJson(Map<String, dynamic> json) {
        return Employee(
            id: json['id'] as String,
            name: json['name'] as String,
            company: json['company'] ?? '',
        );
    }
}
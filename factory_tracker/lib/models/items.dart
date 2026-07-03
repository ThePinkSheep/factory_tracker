class Item {
    final String id;
    final String name;
    final double rate;
    final double averagePerDay;

    Item({
        required this.id,
        required this.name,
        required this.rate,
        required this.averagePerDay
    });

    factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
            id: json['id'] as String,
            name: json['name'] as String,
            rate: (json['rate'] as num).toDouble(),
            averagePerDay: (json['average_per_day'] as num).toDouble(),
        );
    }

}
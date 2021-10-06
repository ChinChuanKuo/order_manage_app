class StoreJson {
  String store;
  String category;

  StoreJson({
    required this.store,
    required this.category,
  });

  factory StoreJson.fromJson(Map<String, dynamic> json) {
    return StoreJson(
      store: json["store"] as String,
      category: json["category"] as String,
    );
  }
}

class ItemsModel {
  final String? name;
  final String? image;
  final String? value;
  bool accepting;

  ItemsModel({
    this.name,
    this.image,
    this.value,
    this.accepting = false,
  });
}

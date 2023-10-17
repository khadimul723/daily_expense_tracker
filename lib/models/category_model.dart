const String tblCategory = 'tbl_category';
const String tblCategoryColId = 'id';
const String tblCategoryColName = 'name';

class CategoryModel {
  int? id;
  String name;

  CategoryModel(this.name, {this.id});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblCategoryColName: name,
    };
    if (id != null) {
      map[tblCategoryColId] = id;
    }
    return map;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        map[tblCategoryColName],
        id: map[tblCategoryColId],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

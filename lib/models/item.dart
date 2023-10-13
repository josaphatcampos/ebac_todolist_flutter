
class Item{
 final int id;
 final String title;
 final String description;
 final bool isDone;

 Item({required this.id, required this.title, required this.description, required this.isDone});


 @override
  String toString() {
    return 'Item{id: $id, title: $title, description: $description, isDone: $isDone}';
 }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: map['isDone'] as bool,
    );
  }
}
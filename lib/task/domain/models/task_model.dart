class Task{
  final String id;
  final String title;
  final String description;
  final String date;
  String status;
  final String image;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.image,
  });
}

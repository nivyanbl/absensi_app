class Attachment {
  final String? id;
  final String? taskEntryId;
  final String label;
  final String url;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attachment({
    this.id,
    this.taskEntryId,
    required this.label,
    required this.url,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      taskEntryId: json['taskEntryId'],
      label: json['label'],
      url: json['url'],
      description: json['description'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'label': label,
      'url': url,
    };
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
    }
    return map;
  }
}

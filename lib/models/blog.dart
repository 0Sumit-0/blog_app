
class Blog {
  final String id;
  final String image;
  final String title;
  String? description;
  bool isFavourite=false;
  String? author;
  int? voter;

  Blog({
    required this.id,
    required this.image,
    required this.title,
    this.description,
    this.isFavourite=false,
    this.author,
    this.voter,}
      );

  Blog.copy({required this.id, required Blog source})
      : title = source.title,
        image = source.image,
        isFavourite=source.isFavourite;


  factory Blog.fromJson(Map<String, dynamic> blogdata) {

    // print(data[0]['id']);
    return Blog(
      id: blogdata['id'] ?? '',
      image: blogdata['image_url'] ?? '',
      title: blogdata['title'] ?? '',
    );
  }

  static List<Blog> fromJsonList(Map<String, dynamic> json) {
    final data=json['blogs'];
    List<Blog> blogs = [];

    for (var blogData in data) {
      blogs.add(Blog.fromJson(blogData));
    }

    return blogs;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'isFavourite':isFavourite
    };
  }
}
/// Represents a featured portfolio project.
class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String imagePath; // TODO: replace placeholder with real screenshot
  final String? githubUrl;
  final String? liveDemoUrl;

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imagePath,
    this.githubUrl,
    this.liveDemoUrl,
  });
}

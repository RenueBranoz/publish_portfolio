/// Represents a testimonial / recommendation card.
class Testimonial {
  final String name;
  final String designation;
  final String feedback;
  final String imagePath; // TODO: replace with real profile photo

  const Testimonial({
    required this.name,
    required this.designation,
    required this.feedback,
    required this.imagePath,
  });
}

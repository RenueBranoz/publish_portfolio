/// Represents a certification or training credential.
class Certification {
  final String title;
  final String issuer;
  final String date; // e.g. "2024"
  final String imagePath; // TODO: replace with real certificate scan/photo
  final String? credentialUrl;

  const Certification({
    required this.title,
    required this.issuer,
    required this.date,
    required this.imagePath,
    this.credentialUrl,
  });
}

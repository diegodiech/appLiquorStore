/// Devuelve las iniciales de un nombre completo (una letra por palabra,
/// hasta 3), usadas en el avatar del menú lateral. Ej: "Ana Rodríguez" -> "AR".
String initialsOf(String fullName) {
  final words = fullName.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  final letters = words.take(3).map((w) => w[0].toUpperCase());
  return letters.join();
}

abstract class SingleViewRepository {
  List<String> loadImagePaths(String foldrPath);
  Future<void> saveImage(String path);
  Future<void> shareImage(String path);
}

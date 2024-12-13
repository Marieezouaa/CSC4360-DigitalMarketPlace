class ImagesList {
  const  ImagesList(this.productName, this.images);

  final String productName;
  final List<String> images;

  String getImagePath() {
    return images[0]; 
  }

  List<String> getSteps() {
    final imagePath = List.of(images);
    imagePath .removeAt(0); 
    return imagePath;
  }
}

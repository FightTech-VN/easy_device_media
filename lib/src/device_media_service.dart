abstract class DeviceMediaService {
  Future<String?> openPickImage(
    DeviceMediaSource source, {
    bool needCrop = false,
    CropType cropType = CropType.circle,
    bool isCameraFront = false,
    bool needCompress = false,
    int? maxWidth,
    int? maxHeight,
  });

  Future<String?> openPickVideo();
}

enum DeviceMediaSource {
  gallery,
  camera,
}

enum CropType {
  circle,
  rectangle,
}

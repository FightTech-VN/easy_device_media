import 'dart:developer';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../device_media_service.dart';

class DeviceMediaServiceImpl extends DeviceMediaService {
  @override
  Future<String?> openPickImage(
    DeviceMediaSource source, {
    bool needCrop = false,
    CropType? cropType = CropType.circle,
    double? ratioX,
    double? ratioY,
    bool isCameraFront = false,
    bool needCompress = false,
    int? maxWidth = 1000,
    int? maxHeight = 1200,
  }) async {
    // Pick an image
    final imgPath = await ImagePicker().pickImage(
      source: source.toImageSource(),
      preferredCameraDevice:
          isCameraFront ? CameraDevice.front : CameraDevice.rear,
    );

    if (imgPath == null) {
      return null;
    }

    final pathCompress =
        needCompress == false ? imgPath.path : await _compress(imgPath);

    if (pathCompress == null) {
      throw Exception('Cannot compress file');
    }

    final pathCrop = needCrop == false
        ? pathCompress
        : await _crop(
            pathCompress,
            cropType,
            maxWidth,
            maxHeight,
            ratioX,
            ratioY,
          );

    return pathCrop;
  }

  Future<String?> _crop(String path, CropType? type, int? maxW, int? maxH,
      double? ratioX, double? ratioY) async {
    CropAspectRatio aspectRatio = type == CropType.circle
        ? CropAspectRatio(ratioX: 1, ratioY: 1)
        : CropAspectRatio(ratioX: 16, ratioY: 9);

    final image = await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: maxW,
      maxHeight: maxH,
      aspectRatio: type == null
          ? CropAspectRatio(ratioX: ratioX!, ratioY: ratioY!)
          : aspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          // toolbarColor: AppColors.primaryColor,
          // toolbarWidgetColor: Colors.white,
          hideBottomControls: type != CropType.circle,
          initAspectRatio: type == CropType.circle
              ? CropAspectRatioPreset.original
              : CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
          showCropGrid: false,
          // activeControlsWidgetColor: AppColors.primaryColor,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPreset.ratio16x9,
          //   CropAspectRatioPreset.ratio4x3,
          // ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    return image?.path;
  }

  Future<String?> _compress(
    XFile file, {
    double maxSizeInMb = 2.0,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final fileType =
        file.name.substring(file.name.length - 4, file.name.length);
    final newName =
        '${file.name.substring(0, file.name.length - 4)}_compress$fileType';
    final newFilePath = '${tempDir.path}/$newName';
    final int originSize = await file.length();
    final quality = (maxSizeInMb * 1024 * 1024 / originSize * 100).round() - 1;

    //file already < 2MB
    if (quality > 100) {
      log(file.length().toString());
      return file.path;
    }

    //file too big
    if (quality < 5) {
      return null;
    }

    final image = await FlutterImageCompress.compressAndGetFile(
      file.path,
      newFilePath,
      quality: quality,
    );
    if (image != null) {
      log(image.length().toString());
    }

    return image?.path;
  }

  @override
  Future<String?> openPickVideo() async {
    // Pick an image
    final imgPath = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (imgPath == null) {
      return null;
    }
    return imgPath.path;
  }
}

extension DeviceMediaExt on DeviceMediaSource {
  ImageSource toImageSource() {
    switch (this) {
      case DeviceMediaSource.gallery:
        return ImageSource.gallery;
      case DeviceMediaSource.camera:
        return ImageSource.camera;
    }
  }
}

class DeviceMediaData {}

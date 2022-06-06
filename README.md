# Features

 - [x] Pick image from gallery, camera.
 - [x] Support compress image.
 - [x] Support crop image circle, rectangle.


## Example

```dart
  DeviceMediaServiceImpl()
      .openPickImage(DeviceMediaSource.gallery,
          needCompress: true, needCrop: _useCrop)
      .then((value) {
    setState(() {
      image = value;
    });
  });
```



# Native setup

## Android

`android:requestLegacyExternalStorage="true"`

```
  <activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

## iOS
```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Allow $(APP_NAME) access to your photo library to upload your profile picture?</string>
<key>NSCameraUsageDescription</key>
<string>Allow $(APP_NAME) to take photo for sharing</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow $(APP_NAME) access to your photo library to upload your profile picture?</string>
```

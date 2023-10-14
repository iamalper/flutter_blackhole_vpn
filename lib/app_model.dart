import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class App {
  ///[name] is the app name that shown to user like `Youtube`
  final String? name;

  ///Unique [packageName], example `com.google.youtube`
  final String packageName;

  ///Raw image data for app.
  ///
  ///Use [image] to draw icon for UI.
  final Uint8List imageBytes;
  const App(this.name, this.packageName, this.imageBytes);

  ///App's [image] that shown in launcher.
  ///
  ///May be empty image.
  ///
  ///Use [imageBytes] to get raw image bytes.
  Image get image => Image.memory(imageBytes);

  ///Hashcode for [App]
  ///
  ///Depends on [packageName]
  @override
  int get hashCode => packageName.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is App) {
      return hashCode == other.hashCode;
    } else {
      return false;
    }
  }

  ///String represetion for logging.
  ///
  ///Includes [packageName] and [name]
  @override
  String toString() => "Package Name: $packageName, Name: $name";
}

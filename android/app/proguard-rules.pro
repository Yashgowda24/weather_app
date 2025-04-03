# Keep Geolocator & Permission Handler classes
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# Prevent Proguard from stripping JSON parsing
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
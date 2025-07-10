# Google Maps API Setup Guide

## 1. Enable Google Maps API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Directions API
   - Geocoding API

## 2. Create API Key

1. Go to "Credentials" in the Google Cloud Console
2. Click "Create Credentials" > "API Key"
3. Copy the generated API key

## 3. Add API Key to Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="project_dristhi"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">

    <!-- Add this meta-data tag -->
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_GOOGLE_MAPS_API_KEY"/>

    <activity
        android:name=".MainActivity"
        ...
```

## 4. Add API Key to iOS

Edit `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Add this line with your API key
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 5. Security Best Practices

1. **Restrict API Key**: In Google Cloud Console, restrict your API key by:

   - Application restrictions (Android/iOS package name)
   - API restrictions (only enable needed APIs)

2. **Environment Variables**: For development, consider using environment variables:

   ```bash
   export GOOGLE_MAPS_API_KEY="your_api_key_here"
   ```

3. **Different Keys**: Use different API keys for development and production

## 6. Test Integration

After setup, test the maps functionality:

1. Run the app: `flutter run`
2. Navigate to "Safety Map" from the dashboard
3. Verify that the map loads correctly
4. Check that location permissions are requested
5. Test zone overlays and markers

## Troubleshooting

- **Map not loading**: Check if API key is correct and APIs are enabled
- **Location not working**: Ensure location permissions are granted
- **Markers not showing**: Verify API key restrictions don't block the requests
- **iOS build issues**: Make sure GoogleMaps is properly imported in AppDelegate.swift

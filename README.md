# react-native-armfit-sdk

connect and retrieve data from BLE devices

## Android Dependencies

Need to add the following permissions to AndroidManifest.xml file
```xml
 <uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" android:maxSdkVersion="28"/>
    <uses-permission-sdk-23 android:name="android.permission.ACCESS_FINE_LOCATION" tools:targetApi="Q"/>
    <!-- Only when targeting Android 12 or higher -->
    <!-- Please make sure you read the following documentation to have a
         better understanging of the new permissions.
         https://developer.android.com/guide/topics/connectivity/bluetooth/permissions#assert-never-for-location
         -->
    <!-- If your app doesn't use Bluetooth scan results to derive physical location information,
         you can strongly assert that your app
         doesn't derive physical location. -->
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" android:usesPermissionFlags="neverForLocation" tools:targetApi="s" />
    <!-- Needed only if your app looks for Bluetooth devices. -->
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <!-- Needed only if your app makes the device discoverable to Bluetooth devices. -->
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
```
If you need communication while the app is not in the foreground you need the "ACCESS_BACKGROUND_LOCATION" permission.

##### iOS - Update Info.plist
In iOS >= 13 you need to add the `NSBluetoothAlwaysUsageDescription` string key.
## Installation

```sh
npm install react-native-armfit-sdk
```

## Usage

```js
import { multiply } from 'react-native-armfit-sdk';

// ...

const result = await multiply(3, 7);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

# react-native-armfit-sdk

Connect and retrieve data from BLE devices
(Currently support only Android)
## Android Dependencies

Need to add the following permissions to AndroidManifest.xml file
```xml
      <uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
      <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
      <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" android:maxSdkVersion="28"/>
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
      <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
      <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
```
If you need communication while the app is not in the foreground you need the "ACCESS_BACKGROUND_LOCATION" permission.

##### iOS - Update Info.plist
<!-- In iOS >= 13 you need to add the `NSBluetoothAlwaysUsageDescription` string key.  -->
## Installation

```sh
npm install react-native-armfit-sdk
```

## Usage

```js
import ArmfitSdkManager from 'react-native-armfit-sdk';
var sdkManager = NativeModules.ArmfitSdk;
const sdkManagerEmitter = new NativeEventEmitter(sdkManager);
// ...

//Call this this durign the app init to invoke the sdk
ArmfitSdkManager.startSdk()

//To start the scan for 5 seconds
ArmfitSdkManager.scan({})

//To get info about the device
ArmfitSdkManager.getInfo()

//To connect to the identified device
ArmfitSdkManager.connect(id)
// where id -> Periperal id

//To retrieve the services offered by the periperal device
ArmfitSdkManager.retrieveServices(id)
// where id -> Periperal id

//To get on time data from the connected BLE Device
ArmfitSdkManager.getData()

//To get real time data feed from the devive connected
ArmfitSdkManager.getRealTimeData()

//To get the file count and file data results stored in the connected device
ArmfitSdkManager.getFiles()



// Callback handlers for various events
sdkManagerEmitter.addListener('ArmfitSdkModuleDiscoverPeripheral',handleDiscoverPeripheral);
sdkManagerEmitter.addListener('ArmfitSdkModuleDeviceState',handleDevicestate);
sdkManagerEmitter.addListener('ArmfitSdkModuleStopScan', handleStopScan);
sdkManagerEmitter.addListener('ArmfitSdkModuleResult', notifyServices);
sdkManagerEmitter.addListener('ArmfitSdkModuleFileCountResult',fileListServices);
sdkManagerEmitter.addListener('ArmfitSdkModuleFile', fileReadService);
```

## Supported Device
![alt text](https://static.wixstatic.com/media/34caa4_bcab5acf4b0247dea8b3528a2da65d62~mv2.jpg/v1/crop/x_0,y_2,w_530,h_337/fill/w_422,h_268,al_c,q_90/BP2.webp)
## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

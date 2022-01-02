import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  NativeModules,
  NativeEventEmitter,
  Button,
} from 'react-native';
import ArmfitSdkManager from 'react-native-armfit-sdk';

var sdkManager = NativeModules.ArmfitSdk;
const sdkManagerEmitter = new NativeEventEmitter(sdkManager);

export default function App() {
  const [result, setResult] = React.useState<any | undefined>([]);
  const [initialised, setInitialsed] = React.useState<boolean>(false);
  const [connected, setConnected] = React.useState<boolean>(false);
  const [scanning, setScanning] = React.useState<boolean>(false);

  React.useEffect(() => {
    ArmfitSdkManager.startSdk().then(() => {
      console.log('ArmFit Sdk initialised');
      setInitialsed(true);
      doScan();
    });
    sdkManagerEmitter.addListener(
      'ArmfitSdkModuleDiscoverPeripheral',
      handleDiscoverPeripheral
    );
    sdkManagerEmitter.addListener(
      'ArmfitSdkModuleDisconnectPeripheral',
      handleDisconnectedPeripheral
    );
    sdkManagerEmitter.removeListener('ArmfitSdkModuleStopScan', handleStopScan);
    sdkManagerEmitter.addListener(
      'ArmfitSdkModuleDidUpdateValueForCharacteristic',
      notifyServices
    );

    return () => {
      sdkManagerEmitter.removeListener(
        'ArmfitSdkModuleDiscoverPeripheral',
        handleDiscoverPeripheral
      );
      sdkManagerEmitter.removeListener(
        'ArmfitSdkModuleStopScan',
        handleStopScan
      );
      sdkManagerEmitter.removeListener(
        'ArmfitSdkModuleDisconnectPeripheral',
        handleDisconnectedPeripheral
      );
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  React.useEffect(() => {
    // doScan();
  }, [initialised]);

  const doScan = () => {
    setScanning(true);
    ArmfitSdkManager.scan({})
      .then((results) => {
        console.log(results);
      })
      .catch((err) => {
        console.error(err);
      });
  };

  const handleDiscoverPeripheral = (peripheral: any) => {
    setScanning(false);
    if (!peripheral.name) {
      peripheral.name = 'NO NAME';
    } else if (peripheral.name === 'BP2 1415') {
      console.log('Got ArmFit', peripheral);
      setResult(peripheral);
      ArmfitSdkManager.stopScan();
    }
  };

  const handleDisconnectedPeripheral = () => {
    console.log('Device Disconnected');
    setConnected(false);
    setResult([]);
  };

  const handleStopScan = () => {
    console.log('Scan is stopped');
    setScanning(false);
  };

  const notifyServices = ({
    value,
    peripheral,
    characteristic,
    service,
  }: any) => {
    // Convert bytes array to string
    // const data = bytesToString(value);
    console.log(peripheral + ' ' + service);
    console.log(`Recieved ${value} for characteristic ${characteristic}`);
  };

  return (
    <View style={styles.container}>
      {/* <Text>Result: {JSON.stringify(result)}</Text> */}
      <Text>{scanning ? 'Scanning' : result.id ? 'Device Found' : ''}</Text>
      {!scanning && result.id && (
        <Button onPress={() => doScan()} title="Scan Again" color="#811584" />
      )}
      <Text>ID: {JSON.stringify(result.id)}</Text>
      <Text>RSSI: {JSON.stringify(result.rssi)}</Text>
      <Text>Result: {JSON.stringify(result.name)}</Text>
      {connected && (
        <Button
          onPress={() =>
            ArmfitSdkManager.getInfo()
              .then((peripheralData) => {
                console.log('start' + JSON.stringify(peripheralData));
              })
              .catch((error) => {
                // Failure code
                console.log(error);
              })
          }
          title="Get Info "
          color="#811584"
        />
      )}
      <Text>Actions</Text>
      {!connected ? (
        <Button
          onPress={() =>
            ArmfitSdkManager.connect(result.id)
              .then(() => {
                // Success code
                setConnected(true);
                console.log('Connected');
              })
              .catch((error) => {
                // Failure code
                console.log(error);
              })
          }
          title="Connect"
          color="#841584"
        />
      ) : (
        <>
          <Text>Connected with ArmFit</Text>
          <Button
            onPress={() =>
              ArmfitSdkManager.retrieveServices(result.id)
                .then((peripheralData) => {
                  // Success code
                  console.log(JSON.stringify(peripheralData));
                })
                .catch((error) => {
                  // Failure code
                  console.log(error);
                })
            }
            title="Retrieve "
            color="#811584"
          />
        </>
      )}
      <Text>Services</Text>
      <Button
        onPress={() =>
          ArmfitSdkManager.read(result.id, '1800', '2a04')
            .then((peripheralData) => {
              // Success code
              console.log(JSON.stringify(peripheralData));
            })
            .catch((error) => {
              // Failure code
              console.log(error);
            })
        }
        title="Service Read "
        color="#811584"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

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
      'ArmfitSdkModuleDeviceState',
      handleDevicestate
    );
    sdkManagerEmitter.removeListener('ArmfitSdkModuleStopScan', handleStopScan);
    sdkManagerEmitter.addListener('ArmfitSdkModuleResult', notifyServices);
    sdkManagerEmitter.addListener(
      'ArmfitSdkModuleFileCountResult',
      fileListServices
    );
    sdkManager.addListener('ArmfitSdkModuleFile', fileReadService);

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
        'ArmfitSdkModuleDeviceState',
        handleDevicestate
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

  const handleDevicestate = (value: any) => {
    console.log(JSON.stringify(value));
    if (value.status === 'disconnected') {
      setConnected(false);
    } else if (value.status === 'connected') {
      setConnected(true);
    }
  };

  const handleStopScan = () => {
    console.log('Scan is stopped');
    setScanning(false);
  };

  const notifyServices = (result: any) => {
    // Convert bytes array to string
    // const data = bytesToString(value);
    console.log('results:' + result);
  };

  const fileListServices = (result: any) => {
    console.log('FileCount:' + JSON.stringify(result));
  };

  const fileReadService = (result: any) => {
    console.log('FileReading:' + JSON.stringify(result));
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
              .then(() => {
                console.log('started to listen');
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
      <Text>Data Fetch</Text>
      <Button
        onPress={() =>
          ArmfitSdkManager.getData()
            .then(() => {
              // Success code
              console.log('RT started');
            })
            .catch((error) => {
              // Failure code
              console.log(error);
            })
        }
        title="Fetch Data"
        color="#811584"
      />
      <Text>Realtime Data Fetch</Text>
      <Button
        onPress={() =>
          ArmfitSdkManager.getRealTimeData()
            .then(() => {
              // Success code
              console.log('RT started');
            })
            .catch((error) => {
              // Failure code
              console.log(error);
            })
        }
        title="Start Stream"
        color="#811584"
      />
      <Text>Get Files</Text>
      <Button
        onPress={() =>
          ArmfitSdkManager.getFiles()
            .then(() => {
              // Success code
              console.log('RT started');
            })
            .catch((error) => {
              // Failure code
              console.log(error);
            })
        }
        title="Start File Service"
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

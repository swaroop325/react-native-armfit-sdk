import { NativeModules } from 'react-native';
import type { ScanningOptions } from './types';

class ArmfitSdkManager {
  private readonly sdkManager = NativeModules.ArmfitSdk;

  constructor() {
    // this.isPeripheralConnected = this.isPeripheralConnected.bind(this);
  }

  startSdk(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.start((error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }

  stopScan(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.stopScan((error: Error | null) => {
        if (error != null) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }

  // Scanning code to connect to BLE
  scan(scanningOptions: ScanningOptions): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.scan(
        [],
        5,
        true,
        scanningOptions,
        (error: Error | null) => {
          if (error) {
            reject(error);
          } else {
            fulfill();
          }
        }
      );
    });
  }

  connect(peripheralId: any): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.connect(peripheralId, (error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }

  retrieveServices(peripheralId: any, services?: any): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.retrieveServices(
        peripheralId,
        services,
        (
          error: Error | null,
          peripheral: any | void | PromiseLike<string | void>
        ) => {
          if (error) {
            reject(error);
          } else {
            fulfill(peripheral);
          }
        }
      );
    });
  }

  getInfo(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.getInfo((error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }

  getData(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.getData((error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }

  getRealTimeData(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.getRealTimeData((error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }
  getFiles(): Promise<void | string> {
    return new Promise((fulfill, reject) => {
      this.sdkManager.getFiles((error: Error | null) => {
        if (error) {
          reject(error);
        } else {
          fulfill();
        }
      });
    });
  }
}

export default new ArmfitSdkManager();

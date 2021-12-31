package com.reactnativearmfitsdk;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.os.Build;
import android.os.ParcelUuid;
import androidx.annotation.RequiresApi;
import android.util.Log;
import com.facebook.react.bridge.*;

import java.util.ArrayList;
import java.util.List;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
public class LollipopScanManager extends ScanManager {

	public LollipopScanManager(ReactApplicationContext reactContext, ArmfitSdkModule armfitSdkModule) {
		super(reactContext, armfitSdkModule);
	}

	@Override
	public void stopScan(Callback callback) {
		// update scanSessionId to prevent stopping next scan by running timeout thread
		scanSessionId.incrementAndGet();

		getBluetoothAdapter().getBluetoothLeScanner().stopScan(mScanCallback);
		callback.invoke();
	}

    @Override
    public void scan(ReadableArray serviceUUIDs, final int scanSeconds, ReadableMap options,  Callback callback) {
        ScanSettings.Builder scanSettingsBuilder = new ScanSettings.Builder();
        List<ScanFilter> filters = new ArrayList<>();

        if (options.hasKey("scanMode")) {
            scanSettingsBuilder.setScanMode(options.getInt("scanMode"));
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (options.hasKey("numberOfMatches")) {
                scanSettingsBuilder.setNumOfMatches(options.getInt("numberOfMatches"));
            }
            if (options.hasKey("matchMode")) {
                scanSettingsBuilder.setMatchMode(options.getInt("matchMode"));
            }
        }

        if (options.hasKey("reportDelay")) {
            scanSettingsBuilder.setReportDelay(options.getInt("reportDelay"));
        }

        if (serviceUUIDs.size() > 0) {
            for(int i = 0; i < serviceUUIDs.size(); i++){
				ScanFilter filter = new ScanFilter.Builder().setServiceUuid(new ParcelUuid(UUIDHelper.uuidFromString(serviceUUIDs.getString(i)))).build();
                filters.add(filter);
                Log.d(armfitSdkModule.LOG_TAG, "Filter service: " + serviceUUIDs.getString(i));
            }
        }

        getBluetoothAdapter().getBluetoothLeScanner().startScan(filters, scanSettingsBuilder.build(), mScanCallback);
        if (scanSeconds > 0) {
            Thread thread = new Thread() {
                private int currentScanSession = scanSessionId.incrementAndGet();

                @Override
                public void run() {

                    try {
                        Thread.sleep(scanSeconds * 1000);
                    } catch (InterruptedException ignored) {
                    }

                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            BluetoothAdapter btAdapter = getBluetoothAdapter();
                            // check current scan session was not stopped
                            if (scanSessionId.intValue() == currentScanSession) {
                                if(btAdapter.getState() == BluetoothAdapter.STATE_ON) {
                                    btAdapter.getBluetoothLeScanner().stopScan(mScanCallback);
                                }
                                WritableMap map = Arguments.createMap();
                              armfitSdkModule.sendEvent("ArmfitSdkModuleStopScan", map);
                            }
                        }
                    });

                }

            };
            thread.start();
        }
        callback.invoke();
    }

	private ScanCallback mScanCallback = new ScanCallback() {
		@Override
		public void onScanResult(final int callbackType, final ScanResult result) {

			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Log.i(armfitSdkModule.LOG_TAG, "DiscoverPeripheral: " + result.getDevice().getName());

                    LollipopPeripheral peripheral = (LollipopPeripheral) armfitSdkModule.getPeripheral(result.getDevice());
                    if (peripheral == null) {
                        peripheral = new LollipopPeripheral(armfitSdkModule.getReactContext(), result);
                    } else {
                        peripheral.updateData(result.getScanRecord());
                        peripheral.updateRssi(result.getRssi());
                    }
          armfitSdkModule.savePeripheral(peripheral);

					WritableMap map = peripheral.asWritableMap();
          armfitSdkModule.sendEvent("ArmfitSdkModuleDiscoverPeripheral", map);
				}
			});
		}

		@Override
		public void onBatchScanResults(final List<ScanResult> results) {
		}

		@Override
		public void onScanFailed(final int errorCode) {
            WritableMap map = Arguments.createMap();
      armfitSdkModule.sendEvent("ArmfitSdkModuleStopScan", map);
		}
	};
}

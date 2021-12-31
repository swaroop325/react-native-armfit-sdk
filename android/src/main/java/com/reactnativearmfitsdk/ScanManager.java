package com.reactnativearmfitsdk;


import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import java.util.concurrent.atomic.AtomicInteger;

public abstract class ScanManager {

	protected BluetoothAdapter bluetoothAdapter;
	protected Context context;
	protected ReactContext reactContext;
	protected ArmfitSdkModule armfitSdkModule;
	protected AtomicInteger scanSessionId = new AtomicInteger();

	public ScanManager(ReactApplicationContext reactContext, ArmfitSdkModule armfitSdkModule) {
		context = reactContext;
		this.reactContext = reactContext;
		this.armfitSdkModule = armfitSdkModule;
	}

	@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
  protected BluetoothAdapter getBluetoothAdapter() {
		if (bluetoothAdapter == null) {
			android.bluetooth.BluetoothManager manager = (android.bluetooth.BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
			bluetoothAdapter = manager.getAdapter();
		}
		return bluetoothAdapter;
	}

	public abstract void stopScan(Callback callback);

	public abstract void scan(ReadableArray serviceUUIDs, final int scanSeconds, ReadableMap options, Callback callback);
}

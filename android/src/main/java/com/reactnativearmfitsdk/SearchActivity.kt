package com.reactnativearmfitsdk

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.TextUtils
import android.widget.AdapterView
import androidx.annotation.RequiresApi
import java.util.*
import kotlin.collections.ArrayList
import kotlin.concurrent.schedule
class SearchActivity : AppCompatActivity() {

  private lateinit var adapter: BleAdapter
  private lateinit var list : ArrayList<Bluetooth>
  @Bluetooth.MODEL var curModel = Bluetooth.MODEL_ER1

  var support2MPhy: Boolean = false
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    initBle()
//    initUI()
  }


  private fun initUI() {
    BluetoothController.clear()
    setAdapter()
  }

  private fun setAdapter() {
    list = BluetoothController.getDevices(curModel)
    adapter = BleAdapter(this, list)
//    ble_list.adapter = adapter
//    ble_list.onItemClickListener =
//      AdapterView.OnItemClickListener { parent, view, position, id ->
////                connect(BluetoothController.getDevices()[position])
//        val b = adapter.deviceList[position]
//        this.finish()
//      }

  }

  override fun onBackPressed() {
    super.onBackPressed()
    this.finish()
  }

  override fun onDestroy() {
    super.onDestroy()
    stopDiscover()
  }

  private fun initBle() {
    val bluetoothManager =
      getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    bluetoothAdapter = bluetoothManager.adapter

    checkPhy()

    leScanner = bluetoothAdapter.bluetoothLeScanner

    scanDevice(true)
  }

  // @RequiresApi(Build.VERSION_CODES.O)
  private fun checkPhy() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//      support2MPhy = bluetoothAdapter.isLe2MPhySupported
    }
  }

  /**
   * search
   */
  public fun startDiscover() {
    initBle();
    initUI();
    BluetoothController.clear()
//    LogUtils.d("start discover")
    isDiscovery = true


    Timer().schedule(20000) {
      stopDiscover()
    }
  }

  public fun stopDiscover() {
//    LogUtils.d("stop discover")
    isDiscovery = false
    scanDevice(false)
  }

  private var isDiscovery : Boolean = false
  private lateinit var bluetoothAdapter : BluetoothAdapter
  private lateinit var leScanner : BluetoothLeScanner

  private fun scanDevice(enable: Boolean) {
//    GlobalScope.launch {
      if (enable) {
        if (bluetoothAdapter.isEnabled) {
          val settings: ScanSettings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
            .build()
          //                    List<ScanFilter> filters = new ArrayList<ScanFilter>();
          //                    filters.add(new ScanFilter.Builder().build());
          leScanner.startScan(null, settings, leScanCallback)
        }
      } else {
        if (bluetoothAdapter.isEnabled) {
          leScanner.stopScan(leScanCallback)
        }
      }
//    }

  }
  /**
   * lescan callback
   */
  private val leScanCallback: ScanCallback = object : ScanCallback() {
    override fun onScanResult(
      callbackType: Int,
      result: ScanResult
    ) {
      super.onScanResult(callbackType, result)
      val device = result.device
      var deviceName = result.device.name
      val deviceAddress = result.device.address
      if (TextUtils.isEmpty(deviceName)) {
        deviceName = BluetoothController.getDeviceName(deviceAddress)
      }
      @Bluetooth.MODEL val model: Int = Bluetooth.getDeviceModel(deviceName)
      if (model == Bluetooth.MODEL_UNRECOGNIZED) {
        return
      }
      val b = Bluetooth(
        model,  /*ecgResult.getScanRecord().getDeviceName()*/
        deviceName,
        device,
        result.rssi
      )
      if (BluetoothController.addDevice(b)) { // notify
//                LogUtils.d(b.name)
        if (b.model == curModel) {
          adapter.deviceList = BluetoothController.getDevices(curModel)
          adapter.notifyDataSetChanged()

//                    ble_list.invalidate()
        }

      }

    }

    override fun onBatchScanResults(results: List<ScanResult>) { //
    }

    override fun onScanFailed(errorCode: Int) {
//      LogUtils.d("scan error: $errorCode")
      if (errorCode == SCAN_FAILED_ALREADY_STARTED) {
//        LogUtils.d("already start")
      }
      if (errorCode == SCAN_FAILED_FEATURE_UNSUPPORTED) {
//        LogUtils.d("scan settings not supported")
      }
      if (errorCode == 6) {
//        LogUtils.d("too frequently")
      }
    }
  }
}

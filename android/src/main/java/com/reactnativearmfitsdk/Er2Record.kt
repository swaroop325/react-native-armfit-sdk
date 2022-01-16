package com.lepu.lepuble.file

import com.reactnativearmfitsdk.DataConvert
import com.reactnativearmfitsdk.utils.toUInt
import java.util.*

class Er2Record {

  private var data: ByteArray? = null
  private var fileVersion: String? = null
  private var recordingTime = 0
  private var waveData: ByteArray? = null
  private var waveFloats = mutableListOf<Float>()
  private var waveInts= mutableListOf<Int>()
  private var dataCrc = 0
  private var magic = 0
  private var startTime: Long = 0

  constructor(bytes: ByteArray) {
    val len = bytes.size
    if (len < 30) {
      return
    }

    this.data = bytes

    recordingTime = toUInt(bytes.copyOfRange(len-20, len-16))
    if(recordingTime  > 0 && recordingTime < 7548){
      val convert = DataConvert()
      waveData = bytes.copyOfRange(10, recordingTime*125+10)
      for (i in waveData!!.indices) {
        val tmp = convert.unCompressAlgECG(waveData!![i])
        tmp.toInt().apply {
          if (this == -32768)
            return
          waveFloats.add((this * (1.0035 * 1800) / (4096 * 178.74)).toFloat())
          waveInts.add(this)
        }
      }
    }
    fileVersion = "V${bytes[0]}"
  }

  override fun toString(): String {
    return """
            fileVersion: $fileVersion
            duration: $recordingTime
            len: ${waveData?.size}
            data: $waveInts
        """.trimIndent()
  }

  public fun toAIFile(version: Int = 2) : String {
    var file = ""
    if (version == 2) {
      file += "F-0-01,"
    }
    file += "125,II,405.35,"
    for (i in waveInts) {
      file += "$i,"
    }
    file = file.substring(0, file.length-1)
    return file
  }
}

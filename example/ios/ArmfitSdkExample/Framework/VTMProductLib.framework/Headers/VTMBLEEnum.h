#ifndef VTMBLEEnum_h
#define VTMBLEEnum_h

typedef enum : u_char {
    VTMBLEHeaderDefault = 0xA5,
} VTMBLEHeader;

typedef enum : u_char {
    VTMBLEPkgTypeRequest = 0x00,
    VTMBLEPkgTypeNormal = 0x01,
    VTMBLEPkgTypeNotFound = 0xE0,
    VTMBLEPkgTypeOpenFailed = 0xE1,
    VTMBLEPkgTypeReadFailed = 0xE2,
    VTMBLEPkgTypeWriteFailed = 0xE3,
    VTMBLEPkgTypeReadFileListFailed = 0xF1,
    VTMBLEPkgTypeDeviceOccupied = 0xFB,
    VTMBLEPkgTypeFormatError = 0xFC,
    VTMBLEPkgTypeFormatUnsupport = 0xFD,
    VTMBLEPkgTypeCommonError = 0xFF,
    VTMBLEPkgTypeHeadError = 0xCC, 
    VTMBLEPkgTypeCRCError = 0xCD, 
} VTMBLEPkgType;

typedef enum : u_char {
    VTMBLECmdEcho = 0xE0, 
    VTMBLECmdGetDeviceInfo = 0xE1,
    VTMBLECmdReset = 0xE2,   
    VTMBLECmdRestore = 0xE3,  
    VTMBLECmdGetBattery = 0xE4,  
    VTMBLECmdUpdateFirmware = 0xE5, 
    VTMBLECmdUpdateFirmwareData = 0xE6, 
    VTMBLECmdUpdateFirmwareEnd = 0xE7, 
    VTMBLECmdUpdateLangua = 0xE8, 
    VTMBLECmdUpdateLanguaData = 0xF8, 
    VTMBLECmdUpdateLanguaEnd = 0xE9,
    VTMBLECmdRestoreInfo = 0xEA, 
    VTMBLECmdEncrypt = 0xEB, 
    VTMBLECmdSyncTime = 0xEC, 
    VTMBLECmdGetDeviceTemp = 0xED, 
    VTMBLECmdProductReset = 0xEE, 
    VTMBLECmdGetFileList = 0xF1,  
    VTMBLECmdStartRead = 0xF2,  
    VTMBLECmdReadFile = 0xF3, 
    VTMBLECmdEndRead = 0xF4, 
    VTMBLECmdStartWrite = 0xF5,  
    VTMBLECmdWriteData = 0xF6,
    VTMBLECmdEndWrite = 0xF7,
    VTMBLECmdDeleteFile = 0xF8,
    VTMBLECmdGetUserList = 0xF9,
    VTMBLECmdEnterDFU = 0xFA,
} VTMBLECmd;

typedef enum : u_char {
    VTMECGCmdGetConfig = 0x00,
    VTMECGCmdGetRealWave = 0x01, 
    VTMECGCmdGetRunStatus = 0x02, 
    VTMECGCmdGetRealData = 0x03, 
    VTMECGCmdSetConfig = 0x04, 
} VTMECGCmd;

typedef enum : u_char {
    VTMBPCmdGetConfig = 0x00,
    VTMBPCmdCalibrateZero = 0x01,
    VTMBPCmdCalibrateSlope = 0x02,
    VTMBPCmdGetRealPressure = 0x05,
    VTMBPCmdGetRealStatus = 0x06,
    VTMBPCmdGetRealWave = 0x07,
    VTMBPCmdGetRealData = 0x08,
    VTMBPCmdSwiRunStatus = 0x09,
    VTMBPCmdStartMeasure = 0x0A,
    VTMBPCmdSetConfig = 0x0B,
} VTMBPCmd;

typedef enum : u_char {
    VTMSCALECmdGetConfig = 0x00,
    VTMSCALECmdGetRealWave = 0x01,
    VTMSCALECmdGetRunParams = 0x02,
    VTMSCALECmdGetRealData = 0x03,
} VTMSCALECmd;

typedef enum : NSUInteger {
    VTMDeviceTypeUnknown,
    VTMDeviceTypeECG,  
    VTMDeviceTypeBP,  
    VTMDeviceTypeScale, 
} VTMDeviceType;


#endif 

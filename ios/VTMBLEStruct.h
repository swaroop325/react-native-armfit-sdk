#ifndef VTMBLEStruct_h
#define VTMBLEStruct_h

#include <CoreGraphics/CGBase.h>

#pragma pack(1)
struct
VTMStartFirmwareUpdate {
    u_char device_type;
    u_char fw_version[3];
};
typedef struct CG_BOXABLE VTMStartFirmwareUpdate VTMStartFirmwareUpdate;

struct
VTMFirmwareUpdate {
    unsigned addr_offset;
    u_char *fw_data;
};
typedef struct CG_BOXABLE VTMFirmwareUpdate VTMFirmwareUpdate;

struct
VTMStartLanguageUpdate {
    u_char device_type;
    u_char lang_version;
    u_int  size;
};
typedef struct CG_BOXABLE VTMStartLanguageUpdate VTMStartLanguageUpdate;

struct
VTMLanguageUpdate {
    unsigned addr_offset;
    u_char *lang_data;
};
typedef struct CG_BOXABLE VTMLanguageUpdate VTMLanguageUpdate;

struct
VTMSN {
    u_char len;
    u_char serial_num[18];
};
typedef struct CG_BOXABLE VTMSN VTMSN;

struct
VTMConfig {
    u_char burn_flag;
    u_char hw_version;
    u_char branch_code[8];
    VTMSN sn;
};
typedef struct CG_BOXABLE VTMConfig VTMConfig;

struct
VTMDeviceTime {
    u_short year;
    u_char month;
    u_char day;
    u_char hour;
    u_char minute;
    u_char second;
};
typedef struct CG_BOXABLE VTMDeviceTime VTMDeviceTime;

struct
VTMOpenFile {
    u_char file_name[16];
    u_int file_offset;
};
typedef struct CG_BOXABLE VTMOpenFile VTMOpenFile;

struct
VTMReadFile {
    unsigned addr_offset;
};
typedef struct CG_BOXABLE VTMReadFile VTMReadFile;

struct
VTMDeviceInfo {
    u_char hw_version;
    u_int  fw_version;
    u_int  bl_version;
    u_char branch_code[8];
    u_char reserved0[3];
    u_short device_type;
    u_short protocol_version;
    u_char cur_time[7];
    u_short protocol_data_max_len;
    u_char reserved1[4];
    VTMSN sn;
    u_char reserved2[1];
};
typedef struct CG_BOXABLE VTMDeviceInfo VTMDeviceInfo;

struct
VTMBatteryInfo {
    u_char state;
    u_char percent;
    u_short voltage;
};
typedef struct CG_BOXABLE VTMBatteryInfo VTMBatteryInfo;

struct
VTMFileName {
    u_char str[16];
};
typedef struct CG_BOXABLE VTMFileName VTMFileName;

struct
VTMFileList {
    u_char file_num;
    VTMFileName fileName[255];
};
typedef struct CG_BOXABLE VTMFileList VTMFileList;

struct
VTMOpenFileReturn {
    u_int file_size;
};
typedef struct CG_BOXABLE VTMOpenFileReturn VTMOpenFileReturn;

struct
VTMFileData {
    u_char *file_data;
};
typedef struct CG_BOXABLE VTMFileData VTMFileData;

struct
VTMWriteFileReturn {
    u_char file_name[16];
    u_int file_offset;
    u_int file_size;
};
typedef struct CG_BOXABLE VTMWriteFileReturn VTMWriteFileReturn;

struct
VTMUserList {
    u_short user_num;
    u_char *user_ID[30];
};
typedef struct CG_BOXABLE VTMUserList VTMUserList;

struct
VTMTemperature {
    short temp;
};
typedef struct CG_BOXABLE VTMTemperature VTMTemperature;

#pragma mark --- ECG
struct
VTMRate {
    u_char rate;
};
typedef struct CG_BOXABLE VTMRate VTMRate;

struct
VTMFileHead {
    u_char file_version;
    u_char reserved[9];
};
typedef struct CG_BOXABLE VTMFileHead VTMFileHead;

struct
VTMRealTimeWF {
    u_short sampling_num;
    short wave_data[300];
};
typedef struct CG_BOXABLE VTMRealTimeWF VTMRealTimeWF;

struct
VTMRunParams {
    u_short hr;
    u_char sys_flag;
    u_char percent;
    u_int record_time;
    u_char run_status;
    u_char reserved[11];
};
typedef struct CG_BOXABLE VTMRunParams VTMRunParams;

struct
VTMFlagDetail {
    u_char rMark;
    u_char signalWeak;
    u_char signalPoor;
    u_char batteryStatus;
};
typedef struct CG_BOXABLE VTMFlagDetail VTMFlagDetail;

struct
VTMRunStatus {
    u_char curStatus;
    u_char preStatus;
};
typedef struct CG_BOXABLE VTMRunStatus VTMRunStatus;


struct
VTMRealTimeData {
    VTMRunParams run_para;
    VTMRealTimeWF waveform;
};
typedef struct CG_BOXABLE VTMRealTimeData VTMRealTimeData;

struct
VTMECGTotalResult {
    u_char file_version;
    u_char reserved0[9];
    u_int recording_time;
    u_char reserved1[66];
};
typedef struct CG_BOXABLE VTMECGTotalResult VTMECGTotalResult;

struct
VTMECGResult {
    u_int  result;
    u_short hr;
    u_short qrs;
    u_short pvcs;
    u_short qtc;
    u_char reserved[20];
};
typedef struct CG_BOXABLE VTMECGResult VTMECGResult;

#pragma mark ------ ER1/VBeat
struct
VTMER1Config {
    u_char vibeSw;
    u_char hrTarget1;
    u_char hrTarget2;
};
typedef struct CG_BOXABLE VTMER1Config VTMER1Config;

struct
VTMER1PointData {
    u_char hr;
    u_char motion;
    u_char vibration;
};
typedef struct CG_BOXABLE VTMER1PointData VTMER1PointData;

struct
VTMER1FileTail {
    u_int recoring_time;
    u_char reserved[12];
    u_int magic;
};
typedef struct CG_BOXABLE VTMER1FileTail VTMER1FileTail;

#pragma mark ------ ER2/DuoEK
struct
VTMER2Config {
    u_char ecgSwitch;
    u_char vector;
    u_char motion_count;
    u_short motion_windows;
};
typedef struct CG_BOXABLE VTMER2Config VTMER2Config;

struct
VTMER2FileTail {
    u_int recording_time;
    u_short data_crc;
    u_char reserved[10];
    u_int magic;
};
typedef struct CG_BOXABLE VTMER2FileTail VTMER2FileTail;

struct
VTMDuoEKFileAHead {
    u_char file_version;
    u_char reserved0[9];
    u_int recording_time;
    u_char reserved1[66];
};
typedef struct CG_BOXABLE VTMDuoEKFileAHead VTMDuoEKFileAHead;

struct
VTMDuoEKFileAResult {
    u_int  result;
    u_short hr;
    u_short qrs;
    u_short pvcs;
    u_short qtc;
    u_char reserved[20];
};
typedef struct CG_BOXABLE VTMDuoEKFileAResult VTMDuoEKFileAResult;

#pragma mark --- BP2/BP2A
struct
VTMBPECGResult {
    u_char file_version;
    u_char file_type;
    u_int measuring_timestamp;
    u_char reserved1[4];
    u_int recording_time;
    u_char reserved2[2];
    u_int result;
    u_short hr;
    u_short qrs;
    u_short pvcs;
    u_short qtc;
    u_char reserved3[20];
};
typedef struct CG_BOXABLE VTMBPECGResult VTMBPECGResult;

struct
VTMBPBPResult {
    u_char file_version;
    u_char file_type;
    u_int measuring_timestamp;
    u_char reserved1[4];
    u_char status_code;
    u_short systolic_pressure;
    u_short diastolic_pressure;
    u_short mean_pressure;
    u_char pulse_rate;
    u_char medical_result;
    u_char reserved2[19];
};
typedef struct CG_BOXABLE VTMBPBPResult VTMBPBPResult;

struct
VTMBPConfig {
    u_int prev_calib_zero;
    u_int last_calib_zero;
    u_int calib_slope;
    u_short slope_pressure;
    u_int calib_ticks;
    u_int sleep_ticks;
    u_short bp_test_target_pressure;
    u_char device_switch;
    u_char reserved[15];
};
typedef struct CG_BOXABLE VTMBPConfig VTMBPConfig;

struct
VTMCalibrateZero {
    u_int calib_zero;
};
typedef struct CG_BOXABLE VTMCalibrateZero VTMCalibrateZero;

struct
VTMCalibrateSlope {
    u_short calib_pressure;
};
typedef struct CG_BOXABLE VTMCalibrateSlope VTMCalibrateSlope;

struct
VTMCalibrateSlopeReturn {
    u_int calib_slope;
};
typedef struct CG_BOXABLE VTMCalibrateSlopeReturn VTMCalibrateSlopeReturn;

struct
VTMRealTimePressure {
    short pressure;
};
typedef struct CG_BOXABLE VTMRealTimePressure VTMRealTimePressure;

struct
VTMBPRunStatus {
    u_char status;
    VTMBatteryInfo battery;
    u_char reserved[4];
};
typedef struct CG_BOXABLE VTMBPRunStatus VTMBPRunStatus;

struct
VTMBPMeasuringData {
    u_char is_deflating;
    short pressure;
    u_char is_get_pulse;
    u_short pulse_rate;
    u_char is_deflating_2;
    u_char reverse[14];
};
typedef struct CG_BOXABLE VTMBPMeasuringData VTMBPMeasuringData;

struct
VTMBPEndMeasureData {
    u_char is_deflating;
    short pressure;
    u_short systolic_pressure;
    u_short diastolic_pressure;
    u_short mean_pressure;
    u_short pulse_rate;
    u_char state_code;
    u_char medical_result;
    u_char reverse[7];
};
typedef struct CG_BOXABLE VTMBPEndMeasureData VTMBPEndMeasureData;

struct
VTMECGMeasuringData {
    u_int duration;
    u_int special_status;
    u_short pulse_rate;
    u_char reverse[10];
};
typedef struct CG_BOXABLE VTMECGMeasuringData VTMECGMeasuringData;

struct
VTMECGEndMeasureData {
    u_int result;
    u_short hr;
    u_short qrs;
    u_short pvcs;
    u_short qtc;
    u_char reverse[8];
};
typedef struct CG_BOXABLE VTMECGEndMeasureData VTMECGEndMeasureData;

struct
VTMBPRealTimeWaveform {
    u_char type;
    u_char data[20];
    VTMRealTimeWF wav;
};
typedef struct CG_BOXABLE VTMBPRealTimeWaveform VTMBPRealTimeWaveform;

struct
VTMBPRealTimeData {
    VTMBPRunStatus run_status;
    VTMBPRealTimeWaveform rt_wav; 
};
typedef struct CG_BOXABLE VTMBPRealTimeData VTMBPRealTimeData;

#pragma mark --- Scale 1
struct
VTMScaleRunParams {
    u_char run_status;
    u_short hr;
    u_int record_time;
    u_char lead_status;
    u_char reserved[8];
};
typedef struct CG_BOXABLE VTMScaleRunParams VTMScaleRunParams;

struct
VTMScaleData {
    u_char subtype;
    u_char vendor;
    
    u_char measure_mark;
    u_char precision_uint;
    
    u_short weight;
    u_int resistance;
    u_char crc;
};
typedef struct CG_BOXABLE VTMScaleData VTMScaleData;

struct
VTMScaleRealData {
    VTMScaleRunParams run_para;
    VTMScaleData scale_data;
    VTMRealTimeWF waveform; 
};
typedef struct CG_BOXABLE VTMScaleRealData VTMScaleRealData;

struct
VTMScaleFileHead {
    u_char file_version;
    u_char file_type;
    u_char reserved[8];
};
typedef struct CG_BOXABLE VTMScaleFileHead VTMScaleFileHead;

struct
VTMScaleEcgResult {
    u_int recording_time;
    u_char reserved[2];
    u_int result;
    u_short hr;
    u_short qrs;
    u_short pvcs;
    u_short qtc;
    u_char reserved2[20];
};
typedef struct CG_BOXABLE VTMScaleEcgResult VTMScaleEcgResult;

struct
VTMScaleFileData {
    u_char record_valid;
    VTMScaleData scale_data;
    VTMScaleEcgResult ecg_result;
    short ecg_data[3750];
};
typedef struct CG_BOXABLE VTMScaleFileData VTMScaleFileData;

#pragma pack()


#endif

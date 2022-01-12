interface IScanningOptions {
  numberOfMatches: null | number;
  matchMode: null | number;
  scanMode: null | number;
  reportDelay: null | number;
}

export class ScanningOptions {
  public numberOfMatches: number;
  public matchMode: number;
  public scanMode: number;
  public reportDelay: number;

  constructor({
    numberOfMatches = 3,
    // (ANDROID) Defaults to MATCH_MODE_AGGRESSIVE
    matchMode = 1,
    // (ANDROID) Defaults to SCAN_MODE_LOW_POWER on android
    scanMode = 1,
    reportDelay = 0,
  }: IScanningOptions) {
    this.numberOfMatches = numberOfMatches!;
    this.matchMode = matchMode!;
    this.scanMode = scanMode!;
    this.reportDelay = reportDelay!;
  }
}

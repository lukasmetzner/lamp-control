class SettingsResult {
  final String _raspiIp;
  final int _port;

  SettingsResult(this._raspiIp, this._port);

  int get port => _port;

  String get raspiIp => _raspiIp;

}
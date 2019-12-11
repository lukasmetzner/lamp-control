class SettingsResult {
  final String _raspiIp;
  final String _port;

  SettingsResult(this._raspiIp, this._port);

  String get port => _port;

  String get raspiIp => _raspiIp;

}
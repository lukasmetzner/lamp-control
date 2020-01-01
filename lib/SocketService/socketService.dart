import 'dart:io';

class SocketService {
  String _ip;
  int _port;
  Socket _socket;

  //TODO: Make connection in seperate function
  //return connection Future so error handle can update gui
  //

  SocketService(String ip, int port) {
    this._ip = ip;
    this._port = port;

    Socket.connect(this._ip, this._port).then((Socket sock) {
      this._socket = sock;
      this._socket.write("ping");
    }).catchError((Object e) {
      print(e);
    });
  }

  void dataHandler(data) {
    return;
  }

  void errorHandler(error) {
    print(error);
  }

  void sendMessage(String message) {
    this._socket.write(message);
  }

  Socket getSocket() {
    return this._socket;
  }

  void doneHandler() {
    this._socket.destroy();
  }
}

import 'dart:io';

class SocketService {
  String _ip;
  int _port;
  Socket _socket;

  SocketService(String ip,int port){
    this._ip = ip;
    this._port = port;
    Socket.connect(this._ip, this._port)
    .then((Socket sock) {
      this._socket = sock;
      this._socket.write("ping\n");
      this._socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false
      );
    }).catchError((Object e) {
      print(e);
    });
  }

  void sendMessage(String message){
    this._socket.write(message);
  }

  void dataHandler(data){
    if(String.fromCharCodes(data).toLowerCase().contains("ping"))
      this._socket.write("pong");
  }

  Socket getSocket(){
    return this._socket;
  }

  void errorHandler(error) {
    print("Error Message:" + error.toString());
  }

  void doneHandler(){
    this._socket.destroy();
  }
}
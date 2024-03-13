// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  IO.Socket? init({String? url}) {
    try {
      _socket = IO.io(
          url ?? 'https://node-js-nw38.onrender.com',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      _socket.connect();
      return _socket;
    } catch (e) {
      return null;
    }
  }

  IO.Socket get socket => _socket;
}

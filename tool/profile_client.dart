// JSON-RPC client for the optional profile_launcher.dart entry point.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length < 2 ||
      !['start', 'stop', 'focus', 'settings', 'trace', 'timeline']
          .contains(args[1])) {
    stderr.writeln('Usage: dart tool/profile_client.dart <ws://VM-service/ws> '
        '<start|stop|focus|settings|trace|timeline> [key=value|timeline-file]');
    exitCode = 64;
    return;
  }
  final socket =
      await WebSocket.connect(args[0]).timeout(const Duration(seconds: 10));
  var id = 0;
  final pending = <String, Completer<dynamic>>{};
  final subscription = socket.listen((data) {
    final message = jsonDecode(data as String) as Map<String, dynamic>;
    final waiter = pending.remove(message['id']);
    if (waiter != null) {
      if (message.containsKey('error')) {
        waiter.completeError(message['error']);
      } else {
        waiter.complete(message['result']);
      }
    }
  });
  Future<dynamic> call(String method,
      [Map<String, dynamic> params = const {}]) {
    final key = '${++id}';
    final waiter = pending[key] = Completer<dynamic>();
    socket.add(jsonEncode(
        {'jsonrpc': '2.0', 'id': key, 'method': method, 'params': params}));
    return waiter.future.timeout(const Duration(seconds: 15));
  }

  try {
    final vm = await call('getVM');
    final isolate =
        (vm['isolates'] as List).firstWhere((i) => i['name'] == 'main');
    switch (args[1]) {
      case 'timeline':
        if (args.length != 3)
          throw ArgumentError('Provide a timeline output file');
        await File(args[2])
            .writeAsString(jsonEncode(await call('getVMTimeline')));
        print('Saved timeline');
      case 'trace':
        await call('setVMTimelineFlags', {
          'recordedStreams': ['Dart', 'GC', 'Embedder']
        });
        await call('clearVMTimeline');
        print('Timeline recording enabled');
      case 'focus':
      case 'settings':
        final parameters = <String, dynamic>{'isolateId': isolate['id']};
        for (final arg in args.skip(2)) {
          final split = arg.indexOf('=');
          if (split < 1) throw ArgumentError('Expected key=value: $arg');
          parameters[arg.substring(0, split)] = arg.substring(split + 1);
        }
        print(jsonEncode(await call('ext.ltv.${args[1]}', parameters)));
      default:
        print(jsonEncode(await call('ext.ltv.frames',
            {'isolateId': isolate['id'], 'action': args[1]})));
    }
  } finally {
    await subscription.cancel();
    await socket.close();
  }
}

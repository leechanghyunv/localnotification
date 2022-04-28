import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationTestState();
  }
}

class _NotificationTestState extends State<NotificationTest> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  void initState() {
    super.initState();
    var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSetting = IOSInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: androidSetting, iOS: iosSetting);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
  }

  Future _showNotificationAtTime() async {
    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );

    var iosPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.schedule(
      1,
      '지정 Notification',
      '지정 Notification 내용',
      DateTime.now().add(new Duration(seconds: 5)),
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  Future _showNotificationRepeat() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );

    var iosPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      '반복 Notification',
      '반복 Notification 내용',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );

    var iosPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '심플 Notification',
      '이것은 Flutter 노티피케이션!',
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noti 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('기본 Notification'),
              onPressed: _showNotificationWithSound,
            ),
            RaisedButton(
              child: Text('반복 Notification'),
              onPressed: _showNotificationRepeat,
            ),
            RaisedButton(
              child: Text('지정 Notification'),
              onPressed: _showNotificationAtTime,
            ),
            RaisedButton(
              child: Text('취소'),
              onPressed: () => _flutterLocalNotificationsPlugin.cancelAll(),
            ),
          ],
        ),
      ),
    );
  }

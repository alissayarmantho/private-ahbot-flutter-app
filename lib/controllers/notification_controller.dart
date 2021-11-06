import 'dart:async';

import 'package:botapp/services/api_constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:botapp/models/notification_message.dart';

class NotificationController extends GetxController {
  late IO.Socket socket; // will be initialized in onInit
  var messageList = List<NotificationMessage>.from([]).obs;
  var elderId = "".obs;
  var lastIndex = 0.obs;
  var isSendGoToCharger = false.obs;
  var isGoToChargerAck = false.obs;
  var isSendReceivingCall = false.obs;
  var isReceivingCallAck = false.obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    initSocket();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => action());
  }

  void setElderId({required String setElderId}) {
    elderId.value = setElderId;
  }

  Future<void> initSocket() async {
    print('Connecting to chat service');
    socket = IO.io(
        base_api,
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            .build());
    socket.onConnectError((data) => print('Error $data'));
    socket.onConnectTimeout((data) => print('Timeout: $data'));
    socket.onConnecting((data) => print('Connecting: $data'));
    socket.onConnect((_) {
      print('Connected to websocket');
    });
    socket.on('abc', (message) {
      print('Received: $message');
      List<String> parsedMessage = message.split(";");
      NotificationMessage newMessage = NotificationMessage(
        elderId: parsedMessage[0],
        eventType: parsedMessage[1],
        actionTrigger: parsedMessage[2],
        status: parsedMessage[3],
        sender: parsedMessage[4],
      );
      if (newMessage.elderId == elderId.value) {
        if (newMessage.status == 'ok' &&
            newMessage.sender == 'robot' &&
            newMessage.actionTrigger == 'completion' &&
            newMessage.eventType == 'goToCharger') {
          isGoToChargerAck.value = true;
          isSendGoToCharger.value = false;
        }

        if (newMessage.status == 'ok' &&
            newMessage.sender == 'robot' &&
            newMessage.actionTrigger == 'call' &&
            newMessage.eventType == 'goToElder') {
          isReceivingCallAck.value = true;
          isSendReceivingCall = false.obs;
        }
        messageList.add(newMessage);
      }
    });
  }

  void sendMessage(
      {required String elderId,
      required String eventType,
      required String actionTrigger,
      required String status,
      required String sender}) {
    var messagePost = '$elderId;$eventType;$actionTrigger;$status;$sender';
    print(messagePost);
    lastIndex.value += 1; // because I will send and receive my own request
    socket.emit('abc', messagePost);
  }

  void action() {
    if (messageList.length > 0) {
      int newLastIndexValue = messageList.length - 1;
      if (lastIndex.value != newLastIndexValue) {
        lastIndex.value = newLastIndexValue;
        NotificationMessage lastMessage = messageList[lastIndex.value];
        sendMessage(
          elderId: lastMessage.elderId,
          eventType: lastMessage.eventType,
          actionTrigger: lastMessage.actionTrigger,
          status: 'ok',
          sender: 'tablet',
        );
      }
    }
    if (isSendGoToCharger.value && !isGoToChargerAck.value) {
      goToCharger();
    }
    if (isSendReceivingCall.value && !isReceivingCallAck.value) {
      goToElder();
    }
  }

  // Called when the robot is idle
  void goToCharger() {
    print('Going to charger...');
    NotificationMessage newMessage = NotificationMessage(
        elderId: elderId.value,
        eventType: 'goToCharger',
        actionTrigger: 'completion',
        status: 'request',
        sender: 'tablet');
    sendMessage(
      elderId: newMessage.elderId,
      eventType: newMessage.eventType,
      actionTrigger: newMessage.actionTrigger,
      status: newMessage.status,
      sender: newMessage.sender,
    );
    isSendGoToCharger = true.obs;
    isGoToChargerAck = false.obs;
  }

  // Called when elder receive a call
  void goToElder() {
    print('Going to elder...');
    NotificationMessage newMessage = NotificationMessage(
        elderId: elderId.value,
        eventType: 'goToElder',
        actionTrigger: 'call',
        status: 'request',
        sender: 'tablet');
    sendMessage(
      elderId: newMessage.elderId,
      eventType: newMessage.eventType,
      actionTrigger: newMessage.actionTrigger,
      status: newMessage.status,
      sender: newMessage.sender,
    );
    isSendReceivingCall = true.obs;
    isReceivingCallAck = false.obs;
  }
}

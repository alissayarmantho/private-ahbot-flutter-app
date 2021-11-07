import 'dart:async';

import 'package:botapp/controllers/reminder_controller.dart';
import 'package:botapp/models/reminder.dart';
import 'package:botapp/screens/Reminder/reminder_screen.dart';
import 'package:botapp/screens/Reminder/robot_related_notification_screen.dart';
import 'package:botapp/services/api_constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:botapp/models/notification_message.dart';

// TODO: Find a better way to do this. This is kind of bad. Especially the
// parsing
class NotificationController extends GetxController {
  late IO.Socket socket; // will be initialized in onInit
  late Timer timer; // will be initialized in onInit
  var messageList = List<NotificationMessage>.from([]).obs;
  var elderId = "".obs; // this tablet will be bound to one elderId
  var lastIndex = 0.obs;
  var isSendGoToCharger = false.obs;
  var isGoToChargerAck = false.obs;
  var isSendReceivingCall = false.obs;
  var hasPutDown = false.obs;
  var isReceivingCallAck = false.obs;

  var currentNotificationBeingShown = "".obs;

  final ReminderController reminderController =
      Get.put<ReminderController>(ReminderController());

  @override
  void onInit() {
    super.onInit();
    initSocket();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => action());
  }

  void setElderId({required String newElderId}) {
    elderId.value = newElderId;
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
      NotificationMessage newMessage;
      if (parsedMessage.length == 5)
        newMessage = NotificationMessage(
          elderId: parsedMessage[0],
          eventType: parsedMessage[1],
          actionTrigger: parsedMessage[2],
          status: parsedMessage[3],
          sender: parsedMessage[4],
        );
      else
        newMessage = NotificationMessage(
          elderId: parsedMessage[0],
          eventType: parsedMessage[1],
          actionTrigger: parsedMessage[2],
          status: parsedMessage[3],
          sender: parsedMessage[4],
          notificationId: parsedMessage[5],
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

        if (newMessage.eventType == 'goToElder' &&
            newMessage.actionTrigger == 'reminder') {
          if (newMessage.sender == 'server' && newMessage.status == 'request') {
            currentNotificationBeingShown.value =
                newMessage.notificationId ?? "";
          }
        }

        if (newMessage.sender != 'robot' &&
            newMessage.actionTrigger != 'reminder' &&
            newMessage.eventType != 'goToElder') {
          messageList.add(newMessage);
        }
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
      // Theoretically if it hits this if statement, the message should be
      // either from the robot or server

      // I'm not entirely sure whether robot's reply to my goToCharger
      // and goToElder is in the messageList. If it is, this will be buggy
      if (lastIndex.value != newLastIndexValue) {
        lastIndex.value = newLastIndexValue;
        NotificationMessage lastMessage = messageList[lastIndex.value];
        switch (lastMessage.eventType) {
          case "info":
            {
              switch (lastMessage.actionTrigger) {
                case "lifted":
                  {
                    hasPutDown.value = false;
                    Get.to(() => RobotRelatedNotificationScreen(
                        text: "Oops, please put me down on the table!"));
                  }
                  break;
                case "putDown":
                  {
                    // Currently the done in the notification is not pegged
                    // to this reply
                    // TODO: Fix this
                    hasPutDown.value = true;
                  }
                  break;
              }
            }
            break;
          case "goToCharger":
            {
              Get.to(() => () => RobotRelatedNotificationScreen(
                  text: "Unreachable Charging Station!"));
            }
            break;
          case "goToElder":
            {
              if (lastMessage.notificationId != null) {
                reminderController.fetchReminder(
                    // At this point notificationId should not be null.. so it
                    // should not be ""
                    id: lastMessage.notificationId ?? "");
                if (!reminderController.isLoading.value) {
                  Reminder reminder = reminderController.activeReminder.value;
                  Get.to(() => ReminderScreen(
                      isCall: false,
                      isPrompt: false,
                      // Should probably truncate this
                      // TODO: truncate this
                      text: reminder.title,
                      reminderId: reminder.id));
                }
              }
            }
            break;
        }
        if (lastMessage.sender == 'server' || lastMessage.sender == 'robot')
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

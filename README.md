# Bluetooth-Demo
#### This is a demo to demonstrate how to get a heart rate from a Polar Monitor.

![Screenshot_1](ReadMe/screenshot_1.png)

## Technologies

Core Bluetooth https://developer.apple.com/documentation/corebluetooth

Delegation https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Delegation.html

NotificationCenter https://developer.apple.com/documentation/foundation/notificationcenter

Grand Central Dispatch https://developer.apple.com/documentation/DISPATCH

## HR Monitor Compatability

 This app has only been tested with the following Polar heart rate monitors: 

### **Polar H7**, **Polar H10**

![H10](ReadMe/image_2.png)

## Flow

1. The app will start on the "Searching" view. It'll stay there until a HR monitor is detected.

2. The user holds an HR monitor and waits perhaps 5 seconds at most for the iOS device to find the peripheral.

3. Once found, the navigation controller will push the "Monitor Found" view on to the stack. That view will persist until the "body location" data is received from the bluetooth monitor.

4. Once that data is received the navigation controller will push the "HeartRate" view on to the stack and the heart image will start pulsating with the users heartbeat.

5. The heartrate will be 000 bpm until the delegate starts receiving information (ususally 5-10 seconds).

## Removing bluetooth monitor

**This functionality is still being implemented. It is not working yet.**

The app is checking for a heartbeat continuously. If it stops detecting a heartrate for more than 10 seconds the navigation controller will pop both views and show the root view (Searching view). 


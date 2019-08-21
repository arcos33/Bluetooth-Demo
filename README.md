# Bluetooth-Demo
This is a demo to demonstrate how to get a heart rate from a Polar Monitor.
![Screenshot_1](ReadMe/screenshot_1.png)

## Technologies

Core Bluetooth

Delegation

NotificationCenter

Grand Central Dispatch https://developer.apple.com/documentation/DISPATCH

## Considerations

 This app has only been tested with the following Polar heart rate monitors: Polar H7, Polar H10

## Flow

The flow is the following:

While on the "Searching" view

User holds the HR monitor and waits perhaps 5 seconds at most for the iOS device to find the peripheral.

Once found the navigation controller will push the "Monitor Found" view on to the stack. After a second,

the navigation controller will push the "HeartRate" view which will show a beating heart. 

It will show 000 bpm until the delegate method is called.

## Removing bluetooth monitor

The app is checking for a heartbeat continuously. If it stops detecting a heartrate for more than 10 seconds the navigation controller will pop views to the root view (Searching view). 
package com.example.disaster_ready

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // Handle the received message
        println("Message received: ${remoteMessage.messageId}")
    }

    override fun onNewToken(token: String) {
        // Handle the new token
        println("New token: $token")
    }
}
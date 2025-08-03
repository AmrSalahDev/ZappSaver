package com.blackcode.zappsaver.services;

import android.app.Notification;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

public class MyNotificationListener extends NotificationListenerService {

    // Keeps track of last sender and message count
    private final Map<String, Integer> messageCountMap = new HashMap<>();

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        if (!"com.whatsapp".equals(sbn.getPackageName())) return;

        Notification notification = sbn.getNotification();
        if (notification == null || notification.extras == null) return;

        String title = notification.extras.getString("android.title");
        String text = notification.extras.getString("android.text");
        String conversationTitle = notification.extras.getString("android.conversationTitle");

        if (title == null || text == null) return;

        // More unique sender key (groupName:senderName or just senderName)
        String senderId = (conversationTitle != null ? conversationTitle + ":" : "") + title;

        // Safe count logic
        Integer prevCount = messageCountMap.get(senderId);
        int count = (prevCount == null) ? 1 : prevCount + 1;
        messageCountMap.put(senderId, count);

        Log.d("MyNotificationListener", "Sender: " + senderId + ", Message: " + text + ", Count: " + count);

        if (count >= 3) {
            Log.d("MyNotificationListener", senderId + " has sent multiple messages.");
            // TODO: trigger custom action (notification, log, broadcast, etc.)
        }
    }



    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {

    }
}

//
//  NotificationsList.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationsList {
    class var sharedInstance: NotificationsList {
        struct Static {
            static let instance: NotificationsList = NotificationsList()
        }
        return Static.instance
    }
    
    fileprivate let ITEMS_KEY = "NotificationsItems"
    
    func addItem(_ item: NotificationsItem){
        var NotiDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        NotiDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID]
        UserDefaults.standard.set(NotiDictionary, forKey: ITEMS_KEY)
        
        let notification = UILocalNotification()
        notification.alertBody = "ถึงเวลานัดหมายแล้ว:\(item.title)"
        notification.alertAction = "เปิด"
        notification.fireDate = item.deadline as Date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["title": item.title, "UUID": item.UUID]
        notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
}

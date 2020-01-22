//
//  Reminder.swift
//  abdullahAlarm
//
//  Created by abdullah  on 26/05/1441 AH.
//  Copyright © 1441 abdullah . All rights reserved.
//

import UIKit
import UserNotifications


class Reminder : NSObject , NSCoding {
    
    var notification : UILocalNotification
    var name : String
    var time : NSDate
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    init(name : String , time : NSDate , notification : UILocalNotification) {
        self.name = name
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    deinit {
        UIApplication.shared.cancelLocalNotification(self.notification)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name,forKey: PropertyKey.nameKey)
        coder.encode(time,forKey: PropertyKey.timeKey)
        coder.encode(notification,forKey: PropertyKey.notificationKey)

    }
    required convenience init (coder aDecoder : NSCoder) {
        let name = aDecoder.decodeObject(forKey:PropertyKey.nameKey) as! String
        let time = aDecoder.decodeObject(forKey:PropertyKey.timeKey) as! NSDate
        let notification = aDecoder.decodeObject(forKey:PropertyKey.notificationKey) as! UILocalNotification
        
        self.init(name : name , time : time , notification : notification)
        
        
    }
}

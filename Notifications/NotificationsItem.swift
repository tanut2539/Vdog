//
//  NotificationsItem.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import Foundation


struct NotificationsItem {
    var title: String
    var deadline: Date
    var UUID: String
    
    init(deadline: Date, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (Date().compare(self.deadline) == ComparisonResult.orderedDescending)
    }
    
}

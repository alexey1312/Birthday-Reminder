//
//  BirthdayBase.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit
import RealmSwift

class Birthday: Object {
    
    @objc dynamic var userFirstName: String? = ""
    @objc dynamic var userLastName: String? = ""
    @objc dynamic var userfullName: String?
    @objc dynamic var userBirthDate: Date?
    @objc dynamic var userImageData: Data?
    @objc dynamic var userBirthDateToString: String?
    @objc dynamic var userDateCreate = Date()
    @objc dynamic var userBirthdayId = UUID().uuidString
    
    convenience init (userFirstName: String?, userLastName: String?, userBirthDate: Date?, userImageData: Data?) {
        self.init()
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userBirthDate = userBirthDate
        self.userImageData = userImageData
        self.userfullName = (userFirstName ?? "") + (" ") + (userLastName ?? "")
        self.userBirthDateToString = userBirthDate?.description ?? ""
    }
}

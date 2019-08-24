//
//  BirthdayBase.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit

struct Birthday {
    
    var userFirstName: String? = ""
    var userLastName: String? = ""
    var userfullName: String?
    let userBirthdate: String?
    let userImageData: UIImage?
    let userDateCreate = Date()

    init (userFirstName: String?, userLastName: String?, userBirthdate: String?, userImageData: UIImage?) {
        
        self.userFirstName = userFirstName
        self.userLastName = userLastName
        self.userBirthdate = userBirthdate
        self.userImageData = userImageData
        self.userfullName = (userFirstName ?? "") + (" ") + (userLastName ?? "")
        }
    

}
//
//  StorageManager.swift
//  Birthday Reminder
//
//  Created by Admin on 25/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {

    static func saveObject(_ birthday: Birthday) {

        try! realm.write {
            realm.add(birthday)
        }
    }

    static func deleteObject(_ place: Birthday) {
        try! realm.write {
            realm.delete(place)
        }
    }
}

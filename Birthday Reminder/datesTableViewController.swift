//
//  TableTableViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import RealmSwift
import UIKit
 
class datesTableViewController: UITableViewController {
    
    private var usersBirthday: Results<Birthday>!

    override func viewDidLoad() {
        super.viewDidLoad()

        usersBirthday = realm.objects(Birthday.self)
        tableView.tableFooterView = UIView()//Где нет коннтента убирает разделителей полей
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersBirthday.isEmpty ? 0: usersBirthday.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        var userBirthday = Birthday()
        userBirthday = usersBirthday[indexPath.row]
        //Конвертация даты
        let userBirthdayDate = userBirthday.userBirthDate
        let dateForamaterDate = DateFormatter()
        let dateFormatreWeekDay = DateFormatter()
        
        dateForamaterDate.dateFormat = "yyyy-MM-dd"
        dateFormatreWeekDay.dateFormat = "EEEE"
               
        let dateValueDate = dateForamaterDate.string(from: userBirthdayDate!)
        let dateValueWeekDay = dateFormatreWeekDay.string(from: userBirthdayDate!)
        let capitalizedDate = dateValueDate.capitalized
        let capitalizedWeekday = dateValueWeekDay.capitalized
        let fullDate = "\(capitalizedWeekday) \(capitalizedDate)"
        
        cell.textLabel?.text = userBirthday.userfullName
        cell.detailTextLabel?.text = fullDate

        return cell
    }
 
       //MARK: Table view delegate
       
       //Добавление свайпа с права на лево для удаления ячеек
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let userBirthday = usersBirthday[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            
            StorageManager.deleteObject(userBirthday)
            tableView.deleteRows(at: [indexPath],
                                 with: .automatic)
        }
               
        let deleteAction = UISwipeActionsConfiguration.init(actions: [action])
        
        // Remove notification
        if let identifier = userBirthday.userFirstName {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        
        return deleteAction
       }
}

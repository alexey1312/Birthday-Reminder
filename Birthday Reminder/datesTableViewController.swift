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
    
    let items = try! Realm().objects(Birthday.self).sorted(by: ["userBirthDate", "userFirstName"])
    var section: [String] {
        return Set(items.value(forKeyPath: "userBirthDate") as! [String]).sorted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dateCell")
        
        usersBirthday = realm.objects(Birthday.self)
        tableView.tableFooterView = UIView()//Где нет коннтента убирает разделителей полей
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.usersBirthday.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = usersBirthday[section]
        let date = section.userBirthDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date ?? Date())
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersBirthday.count / usersBirthday.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        
        let headline = usersBirthday[indexPath.section]

        //Конвертация даты
        let userBirthdayDate = headline.userBirthDate
        let dateForamaterDate = DateFormatter()
        let dateFormatreWeekDay = DateFormatter()
        
        dateForamaterDate.dateFormat = "yyyy-MM-dd"
        dateFormatreWeekDay.dateFormat = "EEEE"
               
        let dateValueDate = dateForamaterDate.string(from: userBirthdayDate!)
        let dateValueWeekDay = dateFormatreWeekDay.string(from: userBirthdayDate!)
        let capitalizedDate = dateValueDate.capitalized
        let capitalizedWeekday = dateValueWeekDay.capitalized
        let fullDate = "\(capitalizedWeekday) \(capitalizedDate)"
        
        cell.textLabel?.text = headline.userfullName
        cell.detailTextLabel?.text = fullDate

        return cell
    }
}

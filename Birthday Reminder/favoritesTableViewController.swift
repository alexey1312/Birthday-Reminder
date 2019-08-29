//
//  favoritesTableViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 26/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import RealmSwift
import UIKit
import WebKit

class favoritesTableViewController: UITableViewController {
     
    var events: [[Birthday]] = []
    var eventsArray = Birthday()
    let sections = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]

    func sortEvents(items: [Birthday]) {
        
        var firstMount: Int!
        var tmpItems: [Birthday]!
        
        events = items.map { item in
        
            let month = NSCalendar.current.dateComponents([.month], from: item.userBirthDate ?? Date()).month
        
            if firstMount == nil || firstMount != month {
                firstMount = month
                tmpItems = [item]
            } else {
                tmpItems.append(item)
            }
            return tmpItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let eventsArrayMap = eventsArray.userBirthDate?.description {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            var items: [Birthday] = []
            
            for setEvent in eventsArrayMap {
                let item = Birthday()
                
                item.userBirthDate = formatter.date(from: setEvent.description)
                items.append(item)
            }
//            sortEvents(items)
            self.tableView.reloadData()
            }
        }



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        _ = events[section].first?.userBirthDate
        let month = Calendar.current.dateComponents([.month], from: eventsArray.userBirthDate ?? Date()).month
        return sections[month! - 1]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "readSale", for: indexPath)
        
        let eventList = events[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = eventList.userfullName
        
        return cell
    }

}



//
//  TableTableViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import RealmSwift
import UIKit


class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reverstSortingButton: UIBarButtonItem!
    
    
    var ascendingSorting = true
    var usersBirthday: Results<Birthday>!

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let userBirthday = usersBirthday[indexPath.row]
        

        //Конвертация даты
        let userBirthdayDate = usersBirthday[indexPath.row].userBirthDate
        let dateForamaterDate = DateFormatter()
        let dateFormatreWeekDay = DateFormatter()

        dateForamaterDate.dateFormat = "yyyy-MM-dd"
        dateFormatreWeekDay.dateFormat = "EEEE"
        
        let dateValueDate = dateForamaterDate.string(from: userBirthdayDate!)
        let dateValueWeekDay = dateFormatreWeekDay.string(from: userBirthdayDate!)
         
        let capitalizedDate = dateValueDate.capitalized
        let capitalizedWeekday = dateValueWeekDay.capitalized
        let fullDate = "\(capitalizedWeekday) \(capitalizedDate)"


        
        cell.labelName.text = userBirthday.userfullName
        cell.labelDate.text = fullDate
        
        cell.PhotoUserImage.image = UIImage(data: userBirthday.userImageData!)
        cell.PhotoUserImage.layer.cornerRadius = cell.frame.size.height / 3

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


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let birthday = usersBirthday[indexPath.row]
            let newBirthdayVC = segue.destination as! addBirthdayViewController
            newBirthdayVC.currentBirthday = birthday
        }
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newBirthdayVC = segue.source as? addBirthdayViewController else { return }
        
        newBirthdayVC.saveBirtghdayUser()
        tableView.reloadData()
    }
    
    //MARK: Sorting item
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
    }
    
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        if ascendingSorting {
            reverstSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverstSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            usersBirthday = usersBirthday.sorted(byKeyPath: "userFirstName", ascending: ascendingSorting)
        } else {
            usersBirthday = usersBirthday.sorted(byKeyPath: "userBirthDate", ascending: ascendingSorting)
        }
        
        //Обновить таблицу
        tableView.reloadData()
    }
    
    
    
    
}






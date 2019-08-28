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
    
    private var usersBirthday: Results<Birthday>!
    private var ascendingSorting = true
    
    //Search supporting
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtredUsersBirthday: Results<Birthday>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reverstSortingButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search first, last name and date"
        navigationItem.searchController = searchController
        definesPresentationContext = true //Опусить строку поиска при переходе на другой экран


        usersBirthday = realm.objects(Birthday.self)
        tableView.tableFooterView = UIView()//Где нет коннтента убирает разделителей полей

    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
                 return filtredUsersBirthday.count
             }
        
        return usersBirthday.isEmpty ? 0: usersBirthday.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
 
        var userBirthday = Birthday()
        
        if isFiltering {
            userBirthday = filtredUsersBirthday[indexPath.row]
        } else {
            userBirthday = usersBirthday[indexPath.row]
        }

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
            
            let birthday: Birthday
            
            if isFiltering{
                birthday = filtredUsersBirthday[indexPath.row]
            } else {
                birthday = usersBirthday[indexPath.row]
            }
            
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

//For Search
extension MainTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
    
        _ = filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String){
        
        filtredUsersBirthday = usersBirthday.filter("userFirstName CONTAINS[c] %@ OR userLastName CONTAINS[c]  %@ OR userBirthDateToString CONTAINS[c]  %@", searchText, searchText, searchText)
        
        tableView.reloadData()
        
    }
}

extension Date {
    static func dateFormatCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

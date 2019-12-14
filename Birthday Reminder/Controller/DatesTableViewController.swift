//
//  TableTableViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import RealmSwift
import UIKit

class DatesTableViewController: UITableViewController {

    let items = try! Realm().objects(Birthday.self).sorted(by: ["userFirstName"])
    var sectionNames: [String] {
        return Set(items.value(forKeyPath: "userFirstName") as! [String]).sorted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //No content - removes field separators
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.filter("userFirstName == %@", sectionNames[section]).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        cell.textLabel?.text = items.filter("userFirstName == %@",
                                            sectionNames[indexPath.section])[indexPath.row].userfullName
        return cell
    }
}

//
//  PresentationContentViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 05/09/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit

class PresentationContentViewController: UIViewController {

    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var presentText = ""
    var emoji = ""
    var currentPage = 0 // Номер текущей страницы
    var numberOfPages = 0 // Номер страницы
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentTextLabel.text = presentText
        emojiLabel.text = emoji
        //сначала присваивается коллличестов страниц
        pageControl.numberOfPages = numberOfPages
        //номер страницы
        pageControl.currentPage = currentPage

        // Do any additional setup after loading the view.
    }
}

//
//  ContentViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 07/09/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//
import UIKit

class ContentPageViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    var presenText = ""
    var emoji = ""
    var currentPage = 0 // Current Page Number
    var numberOfPages = 0 // Number of pages

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = presenText
        emojiLabel.text = emoji
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
}

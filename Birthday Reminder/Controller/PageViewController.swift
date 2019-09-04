//
//  PageViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 05/09/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let presentScreenContent = [
        "Первая страница презентации",
        "Вторая страница презентации",
        "Третья страница презентации",
        "Четвертая страница презентации",
    ]
    
    let emojiArray = ["🙏", "😎", "🤓", "👌"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showViewControllerAtIndex(_ index: Int) -> PresentationContentViewController? {
        
        guard index >= 0 else {return nil}
        guard index < 0 presentScreenContent.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(identifier: "PresentationContentViewController") as? PresentationContentViewController else { return nil }

    }
    
}

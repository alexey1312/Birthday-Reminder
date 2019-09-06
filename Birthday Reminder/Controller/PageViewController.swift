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
        ""
    ]
    
    let emojiArray = ["🙏", "😎", "🤓", "👌", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }
    
    func showViewControllerAtIndex(_ index: Int) -> PresentationContentViewController? {
        
        guard index >= 0 else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "presentationWasViewed")
            dismiss(animated: true, completion: nil) //метод закрывающий viewcontroller
            return nil }
         
        guard let contentViewController = storyboard?.instantiateViewController(identifier: "PresentationContentViewController") as? PresentationContentViewController else { return nil }
        
        contentViewController.presentText = presentScreenContent[index]
        contentViewController.emoji = emojiArray[index]
        contentViewController.currentPage = index
        contentViewController.numberOfPages = presentScreenContent.count
        
        return contentViewController
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! PresentationContentViewController).currentPage //экземпляр класса PresentationContentViewController
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        var pageNumber = (viewController as! PresentationContentViewController).currentPage //экземпляр класса PresentationContentViewController
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
  
}

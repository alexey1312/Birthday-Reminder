//
//  FirstViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit
import UserNotifications

class addBirthdayViewController: UITableViewController {
    
    var currentBirthday: Birthday?
    var imageIsChange = false
    
    @IBOutlet weak var datePickerLog: UIDatePicker!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userPhotoImage: UIImageView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var labelDateBirthday: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()//Где нет коннтента убирает разделителей полей
        saveButton.isEnabled = false
        //Скрываем кнопку Save если поле Имя пустое
        firstName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setupEditScreen()
    }
    

    @IBAction func editPhotoUser(_ sender: UIButton) {
            
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photoIcon")

        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
            
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
            
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
            
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
            
        present(actionSheet, animated: true)
    }
    
    //MARK: Actions
    @IBAction func datePicker(_ sender: UIDatePicker) {
        
        let dateForamaterDate = DateFormatter()
        let dateFormatreWeekDay = DateFormatter()

        dateForamaterDate.dateFormat = "yyyy-MM-dd"
        dateFormatreWeekDay.dateFormat = "EEEE"
      
        let dateValueDate = dateForamaterDate.string(from: sender.date)
        let dateValueWeekDay = dateFormatreWeekDay.string(from: sender.date)
       
        let capitalizedDate = dateValueDate.capitalized
        let capitalizedWeekday = dateValueWeekDay.capitalized
                
        labelDateBirthday.text = "\(capitalizedWeekday) \(capitalizedDate)"
    }


    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table view delegate
    //Скрываем клавиатуту везде
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    
    //MARK: Save metods
    
    func saveBirtghdayUser() {
        

        let image = imageIsChange ? userPhotoImage.image : #imageLiteral(resourceName: "shirt")
        //Конвертация image в тип Data
        
        let imageData = image?.pngData()
        
        let newBitrhdayUser = Birthday(userFirstName: firstName.text,
                                   userLastName: lastName.text,
                                   userBirthDate: datePickerLog.date,
                                   userImageData: imageData)
                //Add alarm to currentBirthday
        let message = "Сегодня \(newBitrhdayUser.userfullName ?? "") празднует день рождения!"
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default

        //Добавление тригера на 9 утра каждый год
        var dateComponents = Calendar.current.dateComponents([.month, .day],
                                                            from: newBitrhdayUser.userBirthDate!)
        dateComponents.hour = 17
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        if let identifier = newBitrhdayUser.userBirthdayId {
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
        
        //Добавление новых значений в базу или замена предыдущих
        if currentBirthday != nil {
            try! realm.write {
                currentBirthday?.userFirstName = newBitrhdayUser.userFirstName
                currentBirthday?.userLastName = newBitrhdayUser.userLastName
                currentBirthday?.userfullName = newBitrhdayUser.userfullName
                currentBirthday?.userBirthDate = newBitrhdayUser.userBirthDate
                currentBirthday?.userImageData = newBitrhdayUser.userImageData
            }
                    //Add alarm to currentBirthday
            let message = "Сегодня \(currentBirthday!.userfullName ?? "") празднует день рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default

            //Добавление тригера на 9 утра каждый год
            var dateComponents = Calendar.current.dateComponents([.month, .day],
                                                                from: currentBirthday!.userBirthDate!)
            dateComponents.hour = 17
            dateComponents.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
            if let identifier = currentBirthday?.userBirthdayId {
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content,
                                                    trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } else {
            StorageManager.saveObject(newBitrhdayUser)
        }
    }
    
    private func setupEditScreen() {
        if currentBirthday != nil {
            
            setupNavigationBar()
            imageIsChange = true
            
            guard let data = currentBirthday?.userImageData, let image = UIImage(data: data) else { return }
            
            userPhotoImage.image = image
            userPhotoImage.contentMode = .scaleToFill //Масштабирование изображения по размеру экрана
            
            //Конвертация даты
            let userBirthdayDate = currentBirthday?.userBirthDate
            let dateForamaterDate = DateFormatter()
            let dateFormatreWeekDay = DateFormatter()

            dateForamaterDate.dateFormat = "yyyy-MM-dd"
            dateFormatreWeekDay.dateFormat = "EEEE"
            
            let dateValueDate = dateForamaterDate.string(from: userBirthdayDate!)
            let dateValueWeekDay = dateFormatreWeekDay.string(from: userBirthdayDate!)
             
            let capitalizedDate = dateValueDate.capitalized
            let capitalizedWeekday = dateValueWeekDay.capitalized
            let fullDate = "\(capitalizedWeekday) \(capitalizedDate)"

            //
            firstName.text = currentBirthday?.userFirstName
            lastName.text = currentBirthday?.userLastName
            labelDateBirthday.text = fullDate
            datePickerLog.date = currentBirthday!.userBirthDate!
        }
    }
    
    private func setupNavigationBar() {
        
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentBirthday?.userfullName
        saveButton.isEnabled = true
    }
 
}

//MARK: Text field delegate

//Скрываем клаваиатуру по Done
extension addBirthdayViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Скрываем кнопку Save если текст пуст
    @objc func textFieldChanged() {
        if firstName.text?.isEmpty == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}


//MARK: Work with image
extension addBirthdayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker(source: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        userPhotoImage.image = info[.editedImage] as? UIImage //Возможность редактирования фото
        userPhotoImage.contentMode = .scaleAspectFill
        userPhotoImage.clipsToBounds = true
        userPhotoImage.layer.cornerRadius = userPhotoImage.frame.height / 3 //Скругление на фото

        imageIsChange = true

        dismiss(animated: true)
    }
}

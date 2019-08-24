//
//  FirstViewController.swift
//  Birthday Reminder
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Aleksei Kakoulin. All rights reserved.
//

import UIKit

class addBirthdayViewController: UITableViewController {
    
    var imageIsChange = false
    

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var labelDateBirthday: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()//Где нет коннтента убирает разделителей полей
        
        //Скрываем кнопку Save если поле Имя пустое
        saveButton.isEnabled = false
        firstName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
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
    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
    }


    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table view delegate
    //Скрываем клавиатуту везде
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
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

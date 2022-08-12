//
//  NewNotesVC.swift
//  Notes App
//
//  Created by Decagon on 11/08/2022.
//

import UIKit
import CoreData

// MARK: - Object properties
class NewNotesVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDataButton), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = UIColor.systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.textColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.attributedPlaceholder = NSAttributedString(string: "Input Title", attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 40)!])
        return textField
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemFill
        textView.text = "Your description here"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemGray
        textView.delegate = self
        textView.textAlignment = NSTextAlignment.justified
        textView.font = UIFont.systemFont(ofSize: 35)
        
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .systemFill
    }
    
    // MARK: - This function saves the data through coredata at the tap of the save button
    @objc func saveDataButton() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let newNote = Notes(entity: entity!, insertInto: context)
        newNote.id = notes.count as NSNumber
        newNote.title = inputTextField.text!
        newNote.desc = descriptionTextView.text
        do {
            try context.save()
            notes.append(newNote)
            navigationController?.popViewController(animated: true)
        }
        catch {
            print("error")
        }
    }
    
    // MARK: - This function changes the textview color text when it starts editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.systemGray6
        }
    }
    
    // MARK: - This function changes the textfield color text when it starts editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.systemGray {
            textField.text = nil
            textField.textColor = UIColor.systemGray6
        }
    }
   
    // MARK: - Delegates method of the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }

    // MARK: - Setupviews object properties
    func setupViews() {
        view.addSubview(inputTextField)
        view.addSubview(saveButton)
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            inputTextField.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTextField.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionTextView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 30),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 300),
            descriptionTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
    }

}

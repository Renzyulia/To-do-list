//
//  SecondViewController.swift
//  To-do list
//
//  Created by Julia on 01/09/2022.
//

import Foundation
import UIKit

class AddingNewThingViewController: UIViewController, UITextFieldDelegate {
  let titleTF = UITextField()
  let datePicker = UIDatePicker()
  let notesTF = UITextField()
  let thingDoneDefault = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.6961900969, green: 0.6364083905, blue: 1, alpha: 1)
    
    configureLabelTF()
    configureTitleTF()
    configureDatePicker()
    configureNotesTF()
    configureSaveButton()
    configureCancelButton()
  }
  
  func configureLabelTF() {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
    label.textColor = .black
    label.textAlignment = .center
    label.text = "Add new thing"
    
    view.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)])
  }
  
  func configureTitleTF() {
    titleTF.placeholder = "what need to do"
    titleTF.font = UIFont.systemFont(ofSize: 15)
    titleTF.borderStyle = UITextField.BorderStyle.roundedRect
    titleTF.autocorrectionType = UITextAutocorrectionType.no
    titleTF.keyboardType = UIKeyboardType.default
    titleTF.returnKeyType = UIReturnKeyType.done
    titleTF.clearButtonMode = UITextField.ViewMode.whileEditing
    titleTF.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    titleTF.delegate = self
    
    self.view.addSubview(titleTF)
    
    titleTF.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([titleTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 titleTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
                                 titleTF.widthAnchor.constraint(equalToConstant: 300),
                                 titleTF.heightAnchor.constraint(equalToConstant: 44)])
  }
  
  func configureDatePicker() {
    
    self.view.addSubview(datePicker)
    
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
                                 datePicker.widthAnchor.constraint(equalToConstant: 300),
                                 datePicker.heightAnchor.constraint(equalToConstant: 44)])
  }
  
  func configureNotesTF() {
    notesTF.placeholder = "notes"
    notesTF.font = UIFont.systemFont(ofSize: 15)
    notesTF.borderStyle = UITextField.BorderStyle.roundedRect
    notesTF.autocorrectionType = UITextAutocorrectionType.no
    notesTF.keyboardType = UIKeyboardType.phonePad
    notesTF.returnKeyType = UIReturnKeyType.done
    notesTF.clearButtonMode = UITextField.ViewMode.whileEditing
    notesTF.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    notesTF.delegate = self
    
    self.view.addSubview(notesTF)
    
    notesTF.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([notesTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 notesTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
                                 notesTF.widthAnchor.constraint(equalToConstant: 300),
                                 notesTF.heightAnchor.constraint(equalToConstant: 130)])
  }
  
  func configureSaveButton() {
    let saveButton = UIButton()
    saveButton.backgroundColor = .white
    saveButton.setTitle("Save", for: .normal)
    saveButton.setTitleColor(UIColor.black, for: .normal)
    saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    
    self.view.addSubview(saveButton)

    saveButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
                                 saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
                                 saveButton.widthAnchor.constraint(equalToConstant: 100),
                                 saveButton.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  @objc func save() {
    let context = CoreData.shared.viewContext
    let object = Thing(context: context)
    object.title = titleTF.text
    object.data = datePicker.date
    object.thingDone = false
    object.notes = notesTF.text
    do {
      try context.save()
    } catch {
      fatalError("cannot save the object")
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  func configureCancelButton() {
    let cancelButton = UIButton()
    cancelButton.backgroundColor = .white
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(UIColor.black, for: .normal)
    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    
    self.view.addSubview(cancelButton)

    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
                                 cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
                                 cancelButton.widthAnchor.constraint(equalToConstant: 100),
                                 cancelButton.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  @objc func cancel() {
    self.dismiss(animated: true, completion: nil)
  }
}



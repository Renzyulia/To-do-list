//
//  SecondViewController.swift
//  To-do list
//
//  Created by Julia on 01/09/2022.
//

import UIKit

class AddingNewThingViewController: UIViewController, UITextFieldDelegate {
  
  private let titleTextField = UITextField()
  private let datePicker = UIDatePicker()
  private let notesTextField = UITextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "BackgroundColor")
    
    configureLabelTextField()
    configureTitleTextField()
    configureDatePicker()
    configureNotesTextField()
    configureSaveButton()
    configureCancelButton()
  }
  
  private func configureLabelTextField() {
    let label = UILabel()
    label.font = .systemFont(ofSize: 25, weight: .medium)
    label.textColor = .black
    label.textAlignment = .center
    label.text = "Add new thing"
    
    view.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 label.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)])
  }
  
  private func configureTitleTextField() {
    titleTextField.placeholder = "what need to do"
    titleTextField.font = .systemFont(ofSize: 15)
    titleTextField.borderStyle = .roundedRect
    titleTextField.autocorrectionType = .no
    titleTextField.keyboardType = .default
    titleTextField.returnKeyType = .done
    titleTextField.clearButtonMode = .whileEditing
    titleTextField.contentVerticalAlignment = .center
    titleTextField.delegate = self
    
    view.addSubview(titleTextField)
    
    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
                                 titleTextField.widthAnchor.constraint(equalToConstant: 300)])
    
  }
  
  private func configureDatePicker() {
    view.addSubview(datePicker)
    
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 280),
                                 datePicker.widthAnchor.constraint(equalToConstant: 300),
                                 datePicker.heightAnchor.constraint(equalToConstant: 44)])
  }
  
  private func configureNotesTextField() {
    notesTextField.placeholder = "notes"
    notesTextField.font = .systemFont(ofSize: 15)
    notesTextField.borderStyle = .roundedRect
    notesTextField.autocorrectionType = .no
    notesTextField.keyboardType = .phonePad
    notesTextField.returnKeyType = .done
    notesTextField.clearButtonMode = .whileEditing
    notesTextField.contentVerticalAlignment = .center
    notesTextField.delegate = self
    
    view.addSubview(notesTextField)
    
    notesTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([notesTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 notesTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 330),
                                 notesTextField.widthAnchor.constraint(equalToConstant: 300),
                                 notesTextField.heightAnchor.constraint(equalToConstant: 150)])
  }
  
  private func configureSaveButton() {
    let saveButton = UIButton()
    saveButton.backgroundColor = UIColor(named: "СomplementaryСolor")
    saveButton.setTitle("Save", for: .normal)
    saveButton.setTitleColor(.black, for: .normal)
    saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    
    view.addSubview(saveButton)

    saveButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                 saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                                 saveButton.widthAnchor.constraint(equalToConstant: 100),
                                 saveButton.heightAnchor.constraint(equalToConstant: 40)])
  }
  
  @objc private func save() {
    let context = CoreData.shared.viewContext
    let object = Thing(context: context)
    object.title = titleTextField.text
    object.date = datePicker.date
    object.thingDone = false
    object.notes = notesTextField.text
    do {
      try context.save()
    } catch {
      fatalError("cannot save the object")
    }
    dismiss(animated: true, completion: nil)
  }
  
  private func configureCancelButton() {
    let cancelButton = UIButton()
    cancelButton.backgroundColor = UIColor(named: "СomplementaryСolor")
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(.black, for: .normal)
    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    
    view.addSubview(cancelButton)

    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                 cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                                 cancelButton.widthAnchor.constraint(equalToConstant: 100),
                                 cancelButton.heightAnchor.constraint(equalToConstant: 40)])
  }
  
  @objc private func cancel() {
    dismiss(animated: true, completion: nil)
  }
}

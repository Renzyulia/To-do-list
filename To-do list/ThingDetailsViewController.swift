//
//  ThingDetailsViewController.swift
//  To-do list
//
//  Created by Julia on 27/09/2022.
//

import UIKit
import CoreData

class ThingDetailsViewController: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
  
  private let thing: Thing
  private let titleThing = UITextField()
  private let datePicker = UIDatePicker()
  private let notesThing = UITextView()
  private let thingStatus = UIImageView()
  private var fetchResultsController: NSFetchedResultsController<Thing>?
  
  init(thing: Thing) {
    self.thing = thing
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "BackgroundColor")
    
    configureTitleThing()
    configureDatePicker()
    configureNotesThing()
    configureBackButton()
    configureSaveButton()
    configureStatusLabel()
    configureStatusButton()
    
    titleThing.text = thing.title
    datePicker.date = thing.date!
    notesThing.text = thing.notes
  }
  
  private func configureTitleThing() {
    titleThing.font = .systemFont(ofSize: 18)
    titleThing.borderStyle = .roundedRect
    titleThing.autocorrectionType = .no
    titleThing.keyboardType = .default
    titleThing.returnKeyType = .done
    titleThing.clearButtonMode = .whileEditing
    titleThing.contentVerticalAlignment = .center
    titleThing.delegate = self
      
    view.addSubview(titleThing)
      
    titleThing.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([titleThing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 titleThing.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
                                 titleThing.widthAnchor.constraint(equalToConstant: 300),
                                 titleThing.heightAnchor.constraint(equalToConstant: 50)])
  }
  
  private func configureDatePicker() {
    view.addSubview(datePicker)
    
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 165)])
  }
  
  private func configureNotesThing() {
    notesThing.font = .systemFont(ofSize: 15)
    notesThing.layer.cornerRadius = 10
    notesThing.layer.masksToBounds = true
    notesThing.autocorrectionType = .no
    notesThing.keyboardType = .phonePad
    notesThing.returnKeyType = .done
    notesThing.textAlignment = .left
    
    view.addSubview(notesThing)
    
    notesThing.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([notesThing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 notesThing.topAnchor.constraint(equalTo: view.topAnchor, constant: 285),
                                 notesThing.widthAnchor.constraint(equalToConstant: 300),
                                 notesThing.heightAnchor.constraint(equalToConstant: 150)])
  }
  
  private func configureStatusButton() {
    if thing.thingDone == false {
      thingStatus.image = UIImage(named: "NewThingIcon")
    } else {
      thingStatus.image = UIImage(named: "DoneThingIcon")
    }
    
    thingStatus.isUserInteractionEnabled = true
    thingStatus.backgroundColor = UIColor(named: "СomplementaryСolor")
    
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(tappedView))
    thingStatus.addGestureRecognizer(tapGesture)
    
    view.addSubview(thingStatus)
    
    thingStatus.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([thingStatus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -354),
                                 thingStatus.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90),
                                 thingStatus.widthAnchor.constraint(equalToConstant: 24),
                                 thingStatus.heightAnchor.constraint(equalToConstant: 24)])
  }
  
  @objc private func tappedView() {
    if thing.thingDone == true {
      thingStatus.image = UIImage(named: "NewThingIcon")
      thing.thingDone = false
    } else {
      thingStatus.image = UIImage(named: "DoneThingIcon")
      thing.thingDone = true
    }
  }
  
  private func configureStatusLabel() {
    let statusLabel = UILabel()
    statusLabel.text = "Thing is done"
    statusLabel.font = .systemFont(ofSize: 18)
    statusLabel.textColor = .black
    statusLabel.backgroundColor = UIColor(named: "СomplementaryСolor")
    statusLabel.textAlignment = .center
    
    view.addSubview(statusLabel)
    
    statusLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([statusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -345),
                                 statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90),
                                 statusLabel.widthAnchor.constraint(equalToConstant: 180),
                                 statusLabel.heightAnchor.constraint(equalToConstant: 40)])
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
    thing.title = titleThing.text
    thing.date = datePicker.date
    thing.notes = notesThing.text
    thing.thingDone = thing.thingDone
    dismiss(animated: true, completion: nil)
  }
  
  private func configureBackButton() {
    let backButton = UIButton()
    backButton.backgroundColor = UIColor(named: "СomplementaryСolor")
    backButton.setTitle("Back", for: .normal)
    backButton.setTitleColor(.black, for: .normal)
    backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    
    view.addSubview(backButton)

    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                 backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                                 backButton.widthAnchor.constraint(equalToConstant: 100),
                                 backButton.heightAnchor.constraint(equalToConstant: 40)])
  }
  
  @objc private func back() {
    dismiss(animated: true, completion: nil)
  }
}

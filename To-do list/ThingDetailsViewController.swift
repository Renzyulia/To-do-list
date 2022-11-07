//
//  ThingDetailsViewController.swift
//  To-do list
//
//  Created by Julia on 27/09/2022.
//

import UIKit
import CoreData

class ThingDetailsViewController: UIViewController, UITextFieldDelegate {
  
  let thing: Thing
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let labelDateThingCell = LabelDateThingCell()
  private let dateCell = DateCell()
  private let thingTitleCell = ThingTitleCell()
  private let thingNotesCell = ThingNotesCell()
  private let statusThingCell = StatusThingCell()
  lazy var setDate: Bool = {
    var setDate = true
    if thing.date == nil { setDate = false }
    return setDate
  }()
  
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

    configureBackButton()
    configureSaveButton()
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self

    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
                                 tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
                                 tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
                                 tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
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
    thing.title = thingTitleCell.titleThing.text
    thing.date = dateCell.datePicker.date
    thing.notes = thingNotesCell.notesThing.text
    thing.thingDone = thing.thingDone
    do {
      try context.save()
    } catch {
      fatalError("cannot save the object")
    }
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

extension ThingDetailsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 2
    case 2: return 1
    default: break
    }
    return section
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    switch (indexPath.section, indexPath.row) {
    case (0,0):
      if setDate == false {
        cell = labelDateThingCell
      } else {
      cell = dateCell
      dateCell.backgroundColor = UIColor(named: "BackgroundColor")
      if thing.date != nil {
        dateCell.datePicker.date = thing.date!
      }
      }
    case (1,0):
      cell = thingTitleCell
      thingTitleCell.titleThing.text = thing.title
    case (1,1):
      cell = thingNotesCell
      thingNotesCell.notesThing.text = thing.notes
    case (2,0):
      cell = statusThingCell
      statusThingCell.backgroundColor = UIColor(named: "BackgroundColor")
      if thing.thingDone == false {
        statusThingCell.icon.image = UIImage(named: "NewThingIcon")
      } else {
        statusThingCell.icon.image = UIImage(named: "DoneThingIcon")
      }
    default: break
    }
    return cell
  }
}

extension ThingDetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0,0):
      setDate = true
      tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .left)
    case (2,0):
      if thing.thingDone == true {
        statusThingCell.icon.image = UIImage(named: "NewThingIcon")
        thing.thingDone = false
      } else {
        statusThingCell.icon.image = UIImage(named: "DoneThingIcon")
        thing.thingDone = true
      }
    default: return
    }
  }
}

class LabelDateThingCell: UITableViewCell {
  let label = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    label.text = "Set date"
    label.font = .systemFont(ofSize: 15)
    label.textColor = .black
    label.textAlignment = .left

    contentView.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                 label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                                 label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}

class DateCell: UITableViewCell {
  let datePicker = UIDatePicker()
 
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    contentView.addSubview(datePicker)
    
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 datePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 datePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70),
                                 datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}

class ThingTitleCell: UITableViewCell {
  let titleThing = UITextField()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    titleThing.font = .systemFont(ofSize: 15)
    titleThing.borderStyle = .roundedRect
    titleThing.autocorrectionType = .no
    titleThing.keyboardType = .default
    titleThing.returnKeyType = .done
    titleThing.clearButtonMode = .whileEditing
    titleThing.contentVerticalAlignment = .center
      
    contentView.addSubview(titleThing)
      
    titleThing.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([titleThing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 titleThing.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 titleThing.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                 titleThing.leftAnchor.constraint(equalTo: contentView.leftAnchor)])
  }
}

class ThingNotesCell: UITableViewCell {
  let notesThing = UITextField()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    notesThing.font = .systemFont(ofSize: 15)
    notesThing.borderStyle = .roundedRect
    notesThing.autocorrectionType = .no
    notesThing.keyboardType = .default
    notesThing.returnKeyType = .done
    notesThing.clearButtonMode = .whileEditing
    notesThing.contentVerticalAlignment = .center
    
    contentView.addSubview(notesThing)
    
    notesThing.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([notesThing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 notesThing.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 notesThing.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 notesThing.rightAnchor.constraint(equalTo: contentView.rightAnchor)])
  }
}

class StatusThingCell: UITableViewCell {
  let statusThing = UILabel()
  let icon = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    statusThing.text = "Thing is done"
    statusThing.font = .systemFont(ofSize: 18)
    statusThing.textColor = .black
    statusThing.textAlignment = .left
    
    statusThing.isUserInteractionEnabled = true
    
    contentView.addSubview(statusThing)
    contentView.addSubview(icon)
    
    statusThing.translatesAutoresizingMaskIntoConstraints = false
    icon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([statusThing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 statusThing.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
                                 statusThing.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 statusThing.widthAnchor.constraint(equalToConstant: 250),
                                 icon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
                                 icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                 icon.widthAnchor.constraint(equalToConstant: 20),
                                 icon.heightAnchor.constraint(equalToConstant: 20)])
  }
}

//
//  SecondViewController.swift
//  To-do list
//
//  Created by Julia on 01/09/2022.
//

import UIKit

class AddingNewThingViewController: UIViewController, UITextFieldDelegate, DateThingCellDelegate {
  
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private var numberOfClicks = 0
  private var numberOfRowsInSecondSection = 1
  private var dateSet = false
  private let labelCell = LabelCell()
  private let titleThingCell = TitleThingCell()
  private let notesThingCell = NotesThingCell()
  private let dateThingCell = DateThingCell()
  private let calendarCell = CalendarCell()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "BackgroundColor")
    
    configureTableView()
    configureSaveButton()
    configureCancelButton()
  }
  
  func switchTurn() {
    print("SwitchTurn")
    numberOfClicks += 1
    updateCalendarVisibility()
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
    object.title = titleThingCell.textField.text
    if dateSet {
      object.date = calendarCell.calendar.date
    } else {
      object.date = nil
    }
    object.thingDone = false
    object.notes = notesThingCell.textField.text
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
  
  private func configureTableView() {
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    
    view.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                                 tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                                 tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
                                 tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
  }
  
  func updateCalendarVisibility() {
    tableView.beginUpdates()
    if numberOfClicks % 2 != 0 {
      tableView.insertRows(at: [IndexPath(row: 1, section: 2)], with: .bottom)
      numberOfRowsInSecondSection += 1
    } else {
      tableView.deleteRows(at: [IndexPath(row: 1, section: 2)], with: .top)
      numberOfRowsInSecondSection -= 1
    }
    tableView.endUpdates()
  }
}

extension AddingNewThingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 2
    case 2: return numberOfRowsInSecondSection
    default: break
    }
    return section
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    switch (indexPath.section, indexPath.row) {
    case (0,0): cell = labelCell; labelCell.backgroundColor = UIColor(named: "BackgroundColor"); labelCell.configureCell()
    case (1,0): cell = titleThingCell; titleThingCell.configureCell()
    case (1,1): cell = notesThingCell; notesThingCell.configureCell()
    case (2,0): cell = dateThingCell; dateThingCell.delegate = self; dateThingCell.configureCell()
    case (2,1): cell = calendarCell; calendarCell.configureCell(); dateSet = true
    default: break
    }
    return cell
  }
}

extension AddingNewThingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}

class LabelCell: UITableViewCell {
  private let label = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    label.font = .systemFont(ofSize: 25, weight: .medium)
    label.textColor = .black
    label.textAlignment = .center
    label.text = "Add new thing"

    contentView.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                 label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}

class TitleThingCell: UITableViewCell {
  let textField = UITextField()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    textField.placeholder = "what need to do"
    textField.font = .systemFont(ofSize: 15)
    textField.borderStyle = .roundedRect
    textField.autocorrectionType = .no
    textField.keyboardType = .default
    textField.returnKeyType = .done
    textField.clearButtonMode = .whileEditing
    textField.contentVerticalAlignment = .center
    
    contentView.addSubview(textField)
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([textField.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 textField.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 textField.rightAnchor.constraint(equalTo: contentView.rightAnchor)])
  }
}

class NotesThingCell: UITableViewCell {
  let textField = UITextField()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    textField.placeholder = "notes"
    textField.font = .systemFont(ofSize: 15)
    textField.borderStyle = .roundedRect
    textField.autocorrectionType = .no
    textField.keyboardType = .default
    textField.returnKeyType = .done
    textField.clearButtonMode = .whileEditing
    textField.contentVerticalAlignment = .center
    
    contentView.addSubview(textField)
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([textField.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 textField.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 textField.rightAnchor.constraint(equalTo: contentView.rightAnchor)])
  }
}

protocol DateThingCellDelegate: AnyObject {
  func switchTurn()
}

class DateThingCell: UITableViewCell {
  private let dateTextView = UITextView()
  let switchDate = UISwitch()
  weak var delegate: DateThingCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    dateTextView.text = "Date"
    dateTextView.font = .systemFont(ofSize: 20)
    dateTextView.autocorrectionType = .no
    dateTextView.keyboardType = .phonePad
    dateTextView.returnKeyType = .done
    dateTextView.textAlignment = .left
    
    switchDate.onTintColor = .gray
    switchDate.tintColor = .green
    switchDate.setOn(false, animated: true)
    switchDate.addTarget(self, action: #selector(switchTurn), for: .valueChanged)
    
    contentView.addSubview(dateTextView)
    contentView.addSubview(switchDate)
    
    dateTextView.translatesAutoresizingMaskIntoConstraints = false
    switchDate.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([switchDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                                 switchDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
                                 switchDate.widthAnchor.constraint(equalToConstant: 20),
                                 switchDate.heightAnchor.constraint(equalToConstant: 20),
                                 dateTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                                 dateTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 dateTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                                 dateTextView.widthAnchor.constraint(equalToConstant: 150)])
  }
  
  @objc func switchTurn() {
    delegate?.switchTurn()
  }
}

class CalendarCell: UITableViewCell {
  let calendar = UIDatePicker()
 
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell() {
    contentView.addSubview(calendar)
    
    calendar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([calendar.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 calendar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                 calendar.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                                 calendar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}

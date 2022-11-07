//
//  AddingSharedTodoList.swift
//  To-do list
//
//  Created by Julia on 15/09/2022.
//

import UIKit
import CoreData

class AddingShareTodoListViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  private let contentTableView = UITableView()
  private let identifierCell = "CellToThing"
  private let dateFormatter = DateFormatter()
  private var fetchResultsController: NSFetchedResultsController<Thing>?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "BackgroundColor")
    
    getThingsFromDataBases()
    configureTableView()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    contentTableView.reloadData()
  }
  
  private func getThingsFromDataBases() {
    let context = CoreData.shared.viewContext
    let fetchRequest = Thing.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    self.fetchResultsController = controller
    controller.delegate = self
    do {
        try controller.performFetch()
    } catch {
        fatalError("Failed to fetch entities: \(error)")
    }
  }
  
  private func configureTableView() {
    contentTableView.register(TableViewCell.self, forCellReuseIdentifier: identifierCell)
    contentTableView.backgroundColor = .clear
    contentTableView.dataSource = self
    contentTableView.delegate = self
    
    contentTableView.clipsToBounds = true
    
    view.addSubview(contentTableView)
    
    contentTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                 contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                 contentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                 contentTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
  }
}

extension AddingShareTodoListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if let frc = fetchResultsController {
        return frc.sections!.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = self.fetchResultsController?.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! TableViewCell
    
    guard let object = fetchResultsController?.object(at: indexPath) else {
      fatalError("Attempt to configure cell without a managed object")
    }
    
    let text = object.title
    dateFormatter.dateStyle = .medium
    
    let date: String = {
      var date = " "
      if object.date != nil {
        date = dateFormatter.string(from: object.date!)
      }
      return date
    }()
    
    if object.thingDone == false {
      cell.configure(text: text!, image: UIImage(named: "NewThingIcon")!, dateLabel: date)
    } else {
      cell.configure(text: text!, image: UIImage(named: "DoneThingIcon")!, dateLabel: date)
    }
    return cell
  }
}

extension AddingShareTodoListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let object = fetchResultsController?.object(at: indexPath) else { return }
    let thing = object
    let thingDetailsViewController = ThingDetailsViewController(thing: thing)
    self.present(thingDetailsViewController, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(
    _ tableView: UITableView,
    contextMenuConfigurationForRowAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
      let deleteAction = UIAction(title: NSLocalizedString("DeleteThing", comment: ""),
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive) { action in
        self?.deleteThing(indexPath: indexPath)
      }
      return UIMenu(title: "", children: [deleteAction])
    }
  }
  
  private func deleteThing(indexPath: IndexPath) {
    let context = CoreData.shared.viewContext
    let object = fetchResultsController?.object(at: indexPath)
    context.delete(object!)
    do {
      try context.save()
    } catch {
      fatalError("cannot save the object")
    }
  }
}

class TableViewCell: UITableViewCell {
  private let statusButton = UIImageView()
  private let textField = UITextField()
  private let date: UILabel = {
    let dateLabel = UILabel()
    dateLabel.font = .systemFont(ofSize: 12)
    return dateLabel
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubviewsToHierarchy()
    configureConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addSubviewsToHierarchy() {
    contentView.addSubview(statusButton)
    contentView.addSubview(textField)
    contentView.addSubview(date)
   }
  
  private func configureConstraints() {
    statusButton.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    date.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([statusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                 statusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
                                 statusButton.widthAnchor.constraint(equalToConstant: 20),
                                 statusButton.heightAnchor.constraint(equalToConstant: 20),
                                 textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                                 textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
                                 textField.widthAnchor.constraint(equalToConstant: 250),
                                 date.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
                                 date.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 date.topAnchor.constraint(equalTo: textField.bottomAnchor),
                                 date.widthAnchor.constraint(equalToConstant: 250)])
   }
  
  func configure(text: String, image: UIImage, dateLabel: String) {
    textField.text = text
    statusButton.image = image
    date.text = dateLabel
  }
}

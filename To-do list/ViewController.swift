//
//  ViewController.swift
//  To-do list
//
//  Created by Julia on 19/08/2022.
//

import UIKit
import CoreData

extension Date {
  var startOfDay: Date {
    return Calendar.current.startOfDay(for: self)
  }
  
  var endOfDay: Date {
    var dateComponents = DateComponents()
    dateComponents.day = 1
    dateComponents.second = -1
    return Calendar.current.date(byAdding: dateComponents, to: startOfDay)!
  }
}

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  private let identifierCell = "CellToThing"
  private let date = Date()
  private let motivationalLabel = UILabel()
  private var contentTableView = UITableView()
  private var fetchResultsController: NSFetchedResultsController<Thing>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "BackgroundColor")
    
    getThingsFromDataBases()
    
    configureTitleLabel()
    configureTableView()
    configureMotivationLabel()
    configureAddButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getQuote()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    contentTableView.reloadData()
  }
  
  private func getThingsFromDataBases() {
    let context = CoreData.shared.viewContext
    let fetchRequest = Thing.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    let predicate = NSPredicate(format: "date >= %@ AND date <= %@", date.startOfDay as CVarArg, date.endOfDay as CVarArg)
    fetchRequest.predicate = predicate
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    self.fetchResultsController = controller
    controller.delegate = self
    do {
        try controller.performFetch()
    } catch {
        fatalError("Failed to fetch entities: \(error)")
    }
  }
  
  private func configureTitleLabel() {
    let titleLable = UILabel()
    titleLable.font = .systemFont(ofSize: 30, weight: .medium)
    titleLable.textColor = .black
    titleLable.textAlignment = .center
    titleLable.text = "TO-DO LIST"
    
    view.addSubview(titleLable)
    
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 110)])
  }
  
  private func configureTableView() {
    contentTableView.register(MyTableViewCell.self, forCellReuseIdentifier: identifierCell)
    contentTableView.backgroundColor = .clear
    contentTableView.dataSource = self
    contentTableView.delegate = self
    
    view.addSubview(contentTableView)
    
    contentTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -31),
                                 contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
                                 contentTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 210),
                                 contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -240)])
  }
  
  private func configureMotivationLabel() {
    motivationalLabel.adjustsFontSizeToFitWidth = true
    motivationalLabel.numberOfLines = 0
    motivationalLabel.textColor = .black
    motivationalLabel.textAlignment = .center
    
    view.addSubview(motivationalLabel)
    
    motivationalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([motivationalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                 motivationalLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
                                 motivationalLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
                                 motivationalLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
                                 motivationalLabel.heightAnchor.constraint(equalToConstant: 100)])
  }
  
  private func configureAddButton() {
    let addButton = UIButton()
    
    addButton.backgroundColor = UIColor(named: "BackgroundColor")
    
    addButton.setTitle("Add", for: .normal)
    addButton.setTitleColor(.black, for: .normal)
    addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
    
    self.view.addSubview(addButton)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                 addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                                 addButton.widthAnchor.constraint(equalToConstant: 80),
                                 addButton.heightAnchor.constraint(equalToConstant: 60)])
  }
  
  @objc private func add() {
    let addingNewThingViewController = AddingNewThingViewController()
    self.present(addingNewThingViewController, animated: true, completion: nil)
  }
  
  private func getQuote() {
    var request = URLRequest(url: URL(string: "https://quotes.rest/qod")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
  
    URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
      do {
        let jsonDecoder = JSONDecoder()
        let responseModel = try jsonDecoder.decode(Model.self, from: data!)
        
        DispatchQueue.main.async {
          self?.motivationalLabel.text = responseModel.contents.quotes[0].quote
        }
      } catch {
          print("JSON Serialization error")
        }
    }).resume()
  }
}

struct Model: Decodable {
  let contents: Content
}

struct Content: Decodable {
  let quotes: [Quote]
}

struct Quote: Decodable {
  let quote: String
}

extension ViewController: UITableViewDataSource {
  
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
    let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! MyTableViewCell
    
    guard let object = fetchResultsController?.object(at: indexPath) else {
      fatalError("Attempt to configure cell without a managed object")
    }
    
    let text = object.title
    if object.thingDone == false {
      cell.configure(text: text!, image: UIImage(named: "NewThingIcon")!)
    } else {
      cell.configure(text: text!, image: UIImage(named: "DoneThingIcon")!)
    }
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let context = CoreData.shared.viewContext
    
    guard let object = fetchResultsController?.object(at: indexPath) else { return }
      object.thingDone = !object.thingDone
    do {
      try context.save()
    } catch {
      fatalError("cannot save the object")
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(
    _ tableView: UITableView,
    contextMenuConfigurationForRowAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] suggestedActions in
      let deleteAction = UIAction(title: NSLocalizedString("DeleteThing", comment: ""),
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive) { action in
        self?.deleteThing(indexPath: indexPath)
      }
      return UIMenu(title: "", children: [deleteAction])
    })
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

class CoreData {
  static let shared = CoreData()
  private init () {}
  
  lazy private var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ModelCoreData")
    container.loadPersistentStores(completionHandler: { (StoreDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  var viewContext:NSManagedObjectContext { CoreData.shared.persistentContainer.viewContext }
}

class MyTableViewCell: UITableViewCell {
  
  private let statusButton = UIImageView()
  private let textField = UITextField()
  
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
   }
  
  private func configureConstraints() {
    statusButton.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([statusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                                 statusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
                                 statusButton.widthAnchor.constraint(equalToConstant: 20),
                                 statusButton.heightAnchor.constraint(equalToConstant: 20),
                                 textField.topAnchor.constraint(equalTo: contentView.topAnchor),
                                 textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                 textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
                                 textField.widthAnchor.constraint(equalToConstant: 250)])
   }
  
  func configure(text: String, image: UIImage) {
    textField.text = text
    statusButton.image = image
  }
}


//
//  ViewController.swift
//  To-do list
//
//  Created by Julia on 19/08/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
  
  let identifireCell = "CellToThing"
  var fetchResultsController: NSFetchedResultsController<Thing>?
  let addingNewThingViewController = AddingNewThingViewController()
  
  func getThingsFromDataBases() {
    let context = CoreData.shared.viewContext
    let fetchRequest = Thing.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    self.fetchResultsController = controller
    do {
        try controller.performFetch()
    } catch {
        fatalError("Failed to fetch entities: \(error)")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.6961900969, green: 0.6364083905, blue: 1, alpha: 1)
    
    getThingsFromDataBases()
    
    configureTitleLabel()
    configureTableView()
    configureMotivationLabel()
    configureAddButton()
  }
  
  func configureTitleLabel() {
    let titleLable = UILabel()
    titleLable.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    titleLable.textColor = .black
    titleLable.textAlignment = .center
    titleLable.text = "TO-DO LIST"
    
    view.addSubview(titleLable)
    
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
  }
  
  func configureTableView() {
    let myTableView = UITableView()
    myTableView.register(MyTableViewCell.self, forCellReuseIdentifier: identifireCell)
    myTableView.dataSource = self
    myTableView.delegate = self
    
    view.addSubview(myTableView)
    
    myTableView.translatesAutoresizingMaskIntoConstraints = false
    myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -31).isActive = true
    myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
    myTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 210).isActive = true
    myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -240).isActive = true
  }
  
  func configureMotivationLabel() {
    let motivationalLabel = UILabel()
    motivationalLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
    motivationalLabel.textColor = .black
    motivationalLabel.textAlignment = .center
    motivationalLabel.text = "You are great!"
    
    view.addSubview(motivationalLabel)
    
    motivationalLabel.translatesAutoresizingMaskIntoConstraints = false
    motivationalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    motivationalLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
  }
  
  func configureAddButton() {
    let addButton = UIButton()
    addButton.backgroundColor = #colorLiteral(red: 0.6961900969, green: 0.6364083905, blue: 1, alpha: 1)
//    addButton.titleLabel!.textColor = .black
    addButton.setTitle("Add", for: .normal)
    addButton.setTitleColor(UIColor.black, for: .normal)
    addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
    
    self.view.addSubview(addButton)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                 addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                                 addButton.widthAnchor.constraint(equalToConstant: 80),
                                 addButton.heightAnchor.constraint(equalToConstant: 60)])
  }
  
  @objc func add() {
    self.present(addingNewThingViewController, animated: true, completion: nil)
  }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: identifireCell, for: indexPath) as! MyTableViewCell
    guard let object = self.fetchResultsController?.object(at: indexPath) else {
      fatalError("Attempt to configure cell without a managed object")
    }
    let text = object.title
    cell.configure(text: text!, image: UIImage(named: "DoneIcon")!)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
}

class CoreData {
  static let shared = CoreData()
  private init () {}
  
  lazy var persistentContainer: NSPersistentContainer = {
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
    
    statusButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    statusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    statusButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 1).isActive = true
    statusButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    statusButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
    textField.widthAnchor.constraint(equalToConstant: 250).isActive = true
   }
  
  func configure(text: String, image: UIImage) {
    textField.text = text
    statusButton.image = image
  }
}


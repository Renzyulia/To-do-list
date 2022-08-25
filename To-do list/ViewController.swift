//
//  ViewController.swift
//  To-do list
//
//  Created by Julia on 19/08/2022.
//

import UIKit

class ViewController: UIViewController {
  
  let identifireCell = "CellToThing"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 0.6961900969, green: 0.6364083905, blue: 1, alpha: 1)
    
    configureTitleLabel()
    configureTableView()
    configureMotivationLabel()
    
  }
  
  func configureTitleLabel() {
//    let titleLable = UILabel(frame: CGRect(x: 125.5, y: 115, width: 163, height: 36))
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
//    let myTableView = UITableView(frame: CGRect(x: 32, y: 201, width: 351, height: 465))
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
//    let motivationalLabel = UILabel(frame: CGRect(x: 126.5, y: 751, width: 161, height: 30))
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
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifireCell, for: indexPath) as! MyTableViewCell
    cell.configure(text: "buy products", image: UIImage(named: "DoneIcon")!)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
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


//
//  ViewController.swift
//  To-do list
//
//  Created by Julia on 19/08/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var myTableView = UITableView()
  let identifire = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createTable(){
    self.myTableView = UITableView(frame: view.bounds, style: .plain)
    myTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
    self.myTableView.delegate = self
    self.myTableView.dataSource = self
    
    myTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    view.addSubview(myTableView)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
    cell.textLabel?.text = "\(indexPath.row)"
    
    return cell
  }
}


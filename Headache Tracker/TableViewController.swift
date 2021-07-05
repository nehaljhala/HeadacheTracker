//
//  TableViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    

    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTCell", for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel!.text = "Cell text"
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}

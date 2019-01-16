//
//  PastaTableViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 06.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class PastaTableViewController: UITableViewController {

    private let pastas = [PastaType(name: NSLocalizedString("Spaghetti", comment: "Spaghetti pasta"), aldenteCookTime: 600, softCookTime: 900),
                  PastaType(name: NSLocalizedString("Penne", comment: "Penne pasta"), aldenteCookTime: 60, softCookTime: 120),
                  PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), aldenteCookTime: 5, softCookTime: 10)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("Pasta", comment: "Pasta selectioon title")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pastas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastaKindIdentifier", for: indexPath) as! PastaTableViewCell
        // Configure the cell...
        cell.pastaNameLabel.text = pastas[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasta = pastas[indexPath.row]
        performSegue(withIdentifier: "ShowConsistencySelector", sender: pasta)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowConsistencySelector"{
            let controller = segue.destination as! ConsistencyViewController
            controller.selectedPasta = (sender as! PastaType)
        }
    }
    

}

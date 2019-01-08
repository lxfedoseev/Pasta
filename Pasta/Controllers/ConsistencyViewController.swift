//
//  ConsistencyViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 07.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class ConsistencyViewController: UIViewController {
    
    
    @IBOutlet weak var selectedPastaMessageLabel: UILabel!
    public var selectedPasta: PastaType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }

    private func configureView(){
        self.navigationItem.title = NSLocalizedString("Consistency", comment: "Consistency title")
        self.navigationItem.largeTitleDisplayMode = .never
        selectedPastaMessageLabel.text = NSLocalizedString("You'r cooking", comment: "You'r cooking phrase") + " " + selectedPasta.name.lowercased()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimer"{
            let controller = segue.destination as! TimerViewController
            controller.selectedPasta = selectedPasta
            controller.alDente = (sender as! Bool)
        }
    }
 
    
    // MARK: - Button press handlers
    @IBAction func alDentePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowTimer", sender: true)
    }
    
    @IBAction func softPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowTimer", sender: false)
    }
    

}
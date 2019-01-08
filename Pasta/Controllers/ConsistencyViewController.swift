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
        selectedPastaMessageLabel.text = NSLocalizedString("You'r cooking", comment: "You'r cooking phrase") + " " + selectedPasta.name.lowercased()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func alDentePressed(_ sender: UIButton) {
    }
    
    @IBAction func softPressed(_ sender: UIButton) {
    }
    

}

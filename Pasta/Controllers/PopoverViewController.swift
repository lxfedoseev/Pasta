//
//  PopoverViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 02.04.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("alertTitle", comment: "alertTitle")
        messageLabel.text = NSLocalizedString("alertText", comment: "alertText")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

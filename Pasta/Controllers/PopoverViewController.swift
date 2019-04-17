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
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("alertTitle", comment: "alertTitle")
        messageLabel.text = NSLocalizedString("alertText", comment: "alertText")
        okButton.setTitle(NSLocalizedString("OK", comment: "OK message"), for: .normal)
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

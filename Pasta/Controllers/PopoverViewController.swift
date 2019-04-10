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
    }
}

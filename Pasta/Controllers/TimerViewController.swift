//
//  TimerViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 08.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    public var selectedPasta: PastaType!
    public var alDente = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    private func configureView(){
        self.navigationItem.title = NSLocalizedString("Timer", comment: "Timer title")
        self.navigationItem.largeTitleDisplayMode = .never
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

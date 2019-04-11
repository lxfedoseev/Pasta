//
//  ConsistencyViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 07.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class ConsistencyViewController: VBase {
    
    public var selectedPasta: PastaType?
    private let pastaCoderId = "selectedPasta"
    private let settings = AppSettings.shared
    
    @IBOutlet weak var alDenteButton: UIButton!
    @IBOutlet weak var softButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectedPastaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    private func configureView(){
        guard let pasta = selectedPasta else{return}
        
        selectedPastaLabel.text = NSLocalizedString("You'r cooking", comment: "You'r cooking phrase") + " " + pasta.name.lowercased()
        self.navigationItem.title = NSLocalizedString("Consistency", comment: "Consistency title")
        self.navigationItem.largeTitleDisplayMode = .never
        
        descriptionLabel.text = NSLocalizedString("description phrase", comment: "description phrase")
        alDenteButton.layer.cornerRadius = 10
        softButton.layer.cornerRadius = 10
        view.backgroundColor = backgroudColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UIAccessibility.isReduceMotionEnabled {
            selectedPastaLabel.alpha = 0
            descriptionLabel.alpha = 0
            alDenteButton.alpha = 0
            softButton.alpha = 0
        }
        appDelegate().navButtonDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch UIDevice().type {
        case .iPhoneSE,.iPhone5,.iPhone5S,.iPhone5C,.iPod5,.iPhone4,.iPhone4S:
            selectedPastaLabel.font = selectedPastaLabel.font.withSize(18.0)
            descriptionLabel.font = descriptionLabel.font.withSize(18.0)
        default:break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UIAccessibility.isReduceMotionEnabled {
            selectedPastaLabel.center.y -= 20
            descriptionLabel.center.y -= 20
            alDenteButton.center.y -= 20
            softButton.center.y -= 20
            startAnimation()
        }
    }
    
    fileprivate func startAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.selectedPastaLabel.center.y += 20
            self.selectedPastaLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [], animations: {
            self.descriptionLabel.center.y += 20
            self.descriptionLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
            self.alDenteButton.center.y += 20
            self.alDenteButton.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
            self.softButton.center.y += 20
            self.softButton.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimer"{
            let alDente = (sender as! Bool)
            let controller = segue.destination as! TimerViewController
            if let pasta = selectedPasta{
                controller.interval = alDente ? pasta.aldenteCookTime : pasta.softCookTime
            }
            settings.isTimerRunning = false
            settings.isTimerPaused = false
            settings.actualInterval = 0
        }else if segue.identifier == "showTimer2" {
            let controller = segue.destination as! TimerViewController
            controller.isLaunchedByFirstController = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showTimer2" {
            return isSegueValid(button: self.navigationItem.rightBarButtonItem)
        }
        return true
    }
 
    // MARK: - Button press handlers
    @IBAction func alDentePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowTimer", sender: true)
    }
    
    @IBAction func softPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowTimer", sender: false)
    }
    
    override func onStart() {
        super.onStart()
        configureRightNavButton(button: self.navigationItem.rightBarButtonItem)
    }
    
    // MARK: - State Encode-Decoder
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(selectedPasta, forKey: pastaCoderId)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        selectedPasta = coder.decodeObject(forKey: pastaCoderId) as? PastaType
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        configureView()
    }
}

extension ConsistencyViewController : AppDelegateNavigationButtonProtocol {
    func disableNavigationButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}


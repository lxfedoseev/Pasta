//
//  ConsistencyViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 07.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

class ConsistencyViewController: VBase {
    
    
    @IBOutlet weak var selectedPastaMessageLabel: UILabel!
    public var selectedPasta: PastaType?
    private let pastaCoderId = "selectedPasta"
    private let settings = AppSettings.shared
    
    @IBOutlet weak var alDenteButton: UIButton!
    @IBOutlet weak var softButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectedPastaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        // Do any additional setup after loading the view.
        configureView()
    }
    
    private func configureView(){
        guard let pasta = selectedPasta else{return}
        
        selectedPastaMessageLabel.text = NSLocalizedString("You'r cooking", comment: "You'r cooking phrase") + " " + pasta.name.lowercased()
        self.navigationItem.title = NSLocalizedString("Consistency", comment: "Consistency title")
        self.navigationItem.largeTitleDisplayMode = .never
        
        descriptionLabel.text = NSLocalizedString("description phrase", comment: "description phrase")
        alDenteButton.layer.cornerRadius = 10
        softButton.layer.cornerRadius = 10
        view.backgroundColor = backgroudColor()
    }
    
    func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    fileprivate func configureRightNavButton() {
        if let timeStamp = settings.timeStamp as Date? {
            let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
            if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            AppSettings.shared.isTimerRunning = false
            AppSettings.shared.isTimerPaused = false
            AppSettings.shared.actualInterval = 0
        }else if segue.identifier == "showTimer2" {
            let controller = segue.destination as! TimerViewController
            controller.isLaunchedByFirstController = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showTimer2" {
            if let timeStamp = settings.timeStamp as Date? {
                let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
                if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
                    return true
                }
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            return false
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
        configureRightNavButton()
    }
    
    // MARK: - State Encode-Decoder
    override func encodeRestorableState(with coder: NSCoder) {
        print("encodeRestorableState")
        coder.encode(selectedPasta, forKey: pastaCoderId)
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("decodeRestorableState")
        selectedPasta = coder.decodeObject(forKey: pastaCoderId) as? PastaType
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        print("applicationFinishedRestoringState")
        super.applicationFinishedRestoringState()
        configureView()
    }
}

extension ConsistencyViewController : AppDelegateNavigationButtonProtocol {
    func disableNavigationButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}


//
//  PastaCollectionViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 25.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pastaKindIdentifier"

class PastaCollectionViewController: CBase {
    
    private let settings = AppSettings.shared
    
    private let pastas = [PastaType(name: NSLocalizedString("Spaghetti", comment: "Spaghetti pasta"), jarImage: "spaghetti.png", aldenteCookTime: 8, softCookTime: 11),
                          PastaType(name: NSLocalizedString("Penne", comment: "Penne pasta"), jarImage: "penne.png", aldenteCookTime: 11, softCookTime: 16),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 10, softCookTime: 15),
                          
                          // TODO: remove this line on release
                          PastaType(name: NSLocalizedString("Test", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 0.1, softCookTime: 0.1),
                          
                          PastaType(name: NSLocalizedString("Macaroni", comment: "Macaroni pasta"), jarImage: "macaroni.png", aldenteCookTime: 7, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Conchiglie", comment: "Conchiglie pasta"), jarImage: "conchiglie.png", aldenteCookTime: 10, softCookTime: 12),
                          PastaType(name: NSLocalizedString("Fettuccine", comment: "Fettuccine pasta"), jarImage: "fettuccine.png", aldenteCookTime: 6, softCookTime: 8),
                          PastaType(name: NSLocalizedString("Fusilli", comment: "Fusilli pasta"), jarImage: "fusilli.png", aldenteCookTime: 12, softCookTime: 17),
                          PastaType(name: NSLocalizedString("Linguine", comment: "Linguine pasta"), jarImage: "linguine.png", aldenteCookTime: 9, softCookTime: 13),
                          PastaType(name: NSLocalizedString("Orecchiette", comment: "Orecchiette pasta"), jarImage: "orecchiette.png", aldenteCookTime: 11, softCookTime: 13),
                          PastaType(name: NSLocalizedString("Vermicelli", comment: "Vermicelli pasta"), jarImage: "vermicelli.png", aldenteCookTime: 2, softCookTime: 3),
                          PastaType(name: NSLocalizedString("Rigatoni", comment: "Rigatoni pasta"), jarImage: "rigatoni.png", aldenteCookTime: 12, softCookTime: 15),
                          PastaType(name: NSLocalizedString("Ziti", comment: "Ziti pasta"), jarImage: "ziti.png", aldenteCookTime: 14, softCookTime: 15),
                          PastaType(name: NSLocalizedString("Rotelle", comment: "Rotelle pasta"), jarImage: "rotelle.png", aldenteCookTime: 10, softCookTime: 12),
                          PastaType(name: NSLocalizedString("Tagliatelle", comment: "Tagliatelle pasta"), jarImage: "tagliatelle.png", aldenteCookTime: 7, softCookTime: 9),
                          PastaType(name: NSLocalizedString("Pappardelle", comment: "Pappardelle pasta"), jarImage: "pappardelle.png", aldenteCookTime: 7, softCookTime: 9),
                          PastaType(name: NSLocalizedString("Cavatappi", comment: "Cavatappi pasta"), jarImage: "cavatappi.png", aldenteCookTime: 11, softCookTime: 13),
                          PastaType(name: NSLocalizedString("Anelloni", comment: "Anelloni pasta"), jarImage: "anelloni.png", aldenteCookTime: 11, softCookTime: 13),
                          PastaType(name: NSLocalizedString("Gemelli", comment: "Gemelli pasta"), jarImage: "gemelli.png", aldenteCookTime: 12, softCookTime: 15)]

    func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func onStart() {
        super.onStart()
        configureRightNavButton()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            self.collectionView.backgroundView?.backgroundColor = UIColor.clear
            settings.isLightMode = !settings.isLightMode
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.backgroundView?.backgroundColor = backgroudColor()
                self.navigationController?.navigationBar.barTintColor = navigationBarColor()
                self.navigationController?.navigationBar.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.hasNotch {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(PastaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        configureView()
        addLeftNavigationBarInfoButton()
        //launchTimerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureRightNavButton()
        appDelegate().navButtonDelegate = self
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
    
    private func configureView() {
        self.becomeFirstResponder()
        self.navigationItem.title = NSLocalizedString("Pasta", comment: "Pasta selectioon title")
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.backgroundColor = backgroudColor()
        self.navigationController?.navigationBar.barTintColor = navigationBarColor()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowConsistencySelector"{
            let controller = segue.destination as! ConsistencyViewController
            controller.selectedPasta = (sender as! PastaType)
        }else if segue.identifier == "showTimer1" {
            let controller = segue.destination as! TimerViewController
            controller.isLaunchedByFirstController = true
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showTimer1" {
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
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PastaCollectionViewCell
    
        // Configure the cell
        cell.jarImage.image = UIImage(named: pastas[indexPath.row].jarImage)
        cell.lidImage.image = UIImage(named: "lid.png")
        cell.pastaNameLabel.text = pastas[indexPath.row].name
    
        return cell
    }

    // MARK: - Private functions
    private func launchTimerView() {
        
        if let timeStamp = settings.timeStamp as Date? {
            let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
            if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
                let viewController = storyboard?.instantiateViewController(withIdentifier: "TimerViewIdentifier") as! TimerViewController
                viewController.isLaunchedByFirstController = true
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Helper Function
    
    func lidOpenAnimation(cell: PastaCollectionViewCell, pasta: PastaType){
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            cell.lidImage.center.y -= 20
        }, completion: { _ in
            self.performSegue(withIdentifier: "ShowConsistencySelector", sender: pasta)
            self.view.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                cell.lidImage.center.y += 20
            })
        })
        
    }
    
    func addLeftNavigationBarInfoButton() {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func showInfoScreen() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            displayPopoverMessage()
        }else{
            displayAlertMessage()
        }
    }
    
    func displayAlertMessage() {
        let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: "alertTitle"), message:
            NSLocalizedString("alertText", comment: "alertText"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK message"), style: .default))
        
        self.present(alertController, animated: true)
    }
    
    func displayPopoverMessage(){
        // Load and configure your view controller.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyboard.instantiateViewController(
            withIdentifier: "popoverAlert") as! PopoverViewController
        
        // Use the popover presentation style for your view controller.
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 320, height: 280)
        
        // Specify the anchor point for the popover.
        popoverVC.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        // Present the view controller (in a popover).
        self.present(popoverVC, animated: true) {
            // The popover is visible.
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PastaCollectionViewCell
        let pasta = pastas[indexPath.row]
        let generator = UISelectionFeedbackGenerator();
        generator.selectionChanged()
        lidOpenAnimation(cell: cell, pasta: pasta)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - Collection View Flow Layout Delegate
extension PastaCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: PastaCollectionViewCell.cellWidth, height: PastaCollectionViewCell.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        var leftRightInset : CGFloat = 0.0
        if UIDevice.current.orientation.isLandscape && UIDevice.current.hasNotch {
            leftRightInset = 50.0
        }else {
            let itemsInSection = CGFloat(view.frame.size.width/CGFloat(PastaCollectionViewCell.cellWidth))
            let itmNumber = Int(itemsInSection)
            print(itmNumber)
            leftRightInset = CGFloat((Int(view.frame.size.width) - (PastaCollectionViewCell.cellWidth * itmNumber))/(itmNumber+1))
            print(leftRightInset)
        }
        
        let ret = UIEdgeInsets(top: 10.0,
                     left: leftRightInset,
                     bottom: 50.0,
                     right: leftRightInset)
        print("\(view.frame.width)")
        return ret
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension PastaCollectionViewController : AppDelegateNavigationButtonProtocol{
    func disableNavigationButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

//
//  PastaJarsViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 09.04.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pastaKindIdentifier"

class PastaJarsViewController: VBase {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!{
        didSet {
            let icon = UIImage(named: "timer_icn")
            let iconSize = CGRect(origin: .zero, size: icon!.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, for: .normal)
            rightMenuButton.customView = iconButton
            
            iconButton.addTarget(self, action:#selector(rightMenuClicked(_:)), for: .touchUpInside)
        }
    }
    
    
    private let settings = AppSettings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addLeftNavigationBarInfoButton()
    }
    
    override func onStart() {
        super.onStart()
        configureRightNavButton(button: self.navigationItem.rightBarButtonItem)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.hasNotch {
            collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureRightNavButton(button: self.navigationItem.rightBarButtonItem)
        appDelegate().navButtonDelegate = self
    }
    
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
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
            return isSegueValid(button: self.navigationItem.rightBarButtonItem)
        }
        return true
    }
    
    // MARK: - Helper Function
    
    func lidOpenAnimation(cell: PastaCollectionViewCell, pasta: PastaType){
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            cell.lidImage.center.y -= 20
        }, completion: {[weak self] _ in
            guard let self = self else {return}
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
        popoverVC.preferredContentSize = CGSize(width: 320, height: 340)
        
        // Specify the anchor point for the popover.
        popoverVC.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        // Present the view controller (in a popover).
        self.present(popoverVC, animated: true) {
            // The popover is visible.
        }
    }
    
    @objc func rightMenuClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showTimer1", sender: nil)
    }
}


// MARK: - Collection View Flow Layout Delegate
extension PastaJarsViewController : UICollectionViewDelegateFlowLayout {
    
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
            leftRightInset = CGFloat((Int(view.frame.size.width) - (PastaCollectionViewCell.cellWidth * itmNumber))/(itmNumber+1))
        }
        
        let ret = UIEdgeInsets(top: 10.0,
                               left: leftRightInset,
                               bottom: 50.0,
                               right: leftRightInset)
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

extension PastaJarsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PastaCollectionViewCell
        
        // Configure the cell
        cell.jarImage.image = UIImage(named: pastas[indexPath.row].jarImage)
        cell.lidImage.image = UIImage(named: "lid.png")
        cell.pastaNameLabel.text = pastas[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PastaCollectionViewCell
        let pasta = pastas[indexPath.row]
        let generator = UISelectionFeedbackGenerator();
        generator.selectionChanged()
        lidOpenAnimation(cell: cell, pasta: pasta)
    }
}

extension PastaJarsViewController : AppDelegateNavigationButtonProtocol{
    func disableNavigationButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

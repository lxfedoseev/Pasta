//
//  PastaCollectionViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 25.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pastaKindIdentifier"

class PastaCollectionViewController: UICollectionViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 25.0,
                                             bottom: 50.0,
                                             right: 25.0)
    
    private let pastas = [PastaType(name: NSLocalizedString("Spaghetti", comment: "Spaghetti pasta"), jarImage: "spaghetti.png", aldenteCookTime: 600, softCookTime: 900),
                          PastaType(name: NSLocalizedString("Penne", comment: "Penne pasta"), jarImage: "penne.png", aldenteCookTime: 60, softCookTime: 120),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10),
                          
                          PastaType(name: NSLocalizedString("Macaroni", comment: "Macaroni pasta"), jarImage: "macaroni.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Conchiglie", comment: "Conchiglie pasta"), jarImage: "conchiglie.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Fettuccine", comment: "Fettuccine pasta"), jarImage: "fettuccine.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Fusilli", comment: "Fusilli pasta"), jarImage: "fusilli.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Linguine", comment: "Linguine pasta"), jarImage: "linguine.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Orecchiette", comment: "Orecchiette pasta"), jarImage: "orecchiette.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Vermicelli", comment: "Vermicelli pasta"), jarImage: "vermicelli.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Rigatoni", comment: "Rigatoni pasta"), jarImage: "rigatoni.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Ziti", comment: "Ziti pasta"), jarImage: "ziti.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Rotelle", comment: "Rotelle pasta"), jarImage: "rotelle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Tagliatelle", comment: "Tagliatelle pasta"), jarImage: "tagliatelle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Pappardelle", comment: "Pappardelle pasta"), jarImage: "pappardelle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Cavatappi", comment: "Cavatappi pasta"), jarImage: "cavatappi.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Anelloni", comment: "Anelloni pasta"), jarImage: "anelloni.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Gemelli", comment: "Gemelli pasta"), jarImage: "gemelli.png", aldenteCookTime: 5, softCookTime: 10)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(PastaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        configureView()
        addRightNavigationBarInfoButton()
        launchTimerView()
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("Pasta", comment: "Pasta selectioon title")
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        let bkgImage = UIImage(named: "pattern")
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.backgroundColor = UIColor(patternImage: bkgImage!)
        
        if !AppSettings.shared.isSecondTime {
            displayAlertMessage()
            AppSettings.shared.isSecondTime = true
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowConsistencySelector"{
            let controller = segue.destination as! ConsistencyViewController
            controller.selectedPasta = (sender as! PastaType)
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
        let settings = AppSettings.shared
        
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
    
    func addRightNavigationBarInfoButton() {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func showInfoScreen() {
        displayAlertMessage()
    }
    
    func displayAlertMessage() {
        let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: "alertTitle"), message:
            NSLocalizedString("alertText", comment: "alertText"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK message"), style: .default))
        
        self.present(alertController, animated: true)
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
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

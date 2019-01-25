//
//  PastaCollectionViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 25.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PastaCollectionViewController: UICollectionViewController {
    
    private let pastas = [PastaType(name: NSLocalizedString("Spaghetti", comment: "Spaghetti pasta"), jarImage: "farfalle.png", aldenteCookTime: 600, softCookTime: 900),
                          PastaType(name: NSLocalizedString("Penne", comment: "Penne pasta"), jarImage: "penne.png", aldenteCookTime: 60, softCookTime: 120),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10),
                          PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", aldenteCookTime: 5, softCookTime: 10)]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        launchTimerView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("Pasta", comment: "Pasta selectioon title")
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastaKindIdentifier", for: indexPath) as! PastaCollectionViewCell
    
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
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pasta = pastas[indexPath.row]
        performSegue(withIdentifier: "ShowConsistencySelector", sender: pasta)
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

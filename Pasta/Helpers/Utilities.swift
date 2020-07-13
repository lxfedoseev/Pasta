//
//  Utilities.swift
//  Pasta
//
//  Created by Alex Fedoseev on 19.03.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

let π = CGFloat.pi

let pastas = [
    PastaType(name: NSLocalizedString("Spaghetti", comment: "Spaghetti pasta"), jarImage: "spaghetti.png", onePasta: "one_spaghetti.png", aldenteCookTime: 8.0, softCookTime: 11.0),
    PastaType(name: NSLocalizedString("Penne", comment: "Penne pasta"), jarImage: "penne.png", onePasta: "one_penne.png", aldenteCookTime: 11.0, softCookTime: 16.0),
    PastaType(name: NSLocalizedString("Farfalle", comment: "Farfalle pasta"), jarImage: "farfalle.png", onePasta: "one_farfalle.png", aldenteCookTime: 10.0, softCookTime: 15.0),
    PastaType(name: NSLocalizedString("Macaroni", comment: "Macaroni pasta"), jarImage: "macaroni.png", onePasta: "one_macaroni.png", aldenteCookTime: 7.0, softCookTime: 10.0),
    PastaType(name: NSLocalizedString("Conchiglie", comment: "Conchiglie pasta"), jarImage: "conchiglie.png", onePasta: "one_conchiglie.png", aldenteCookTime: 10.0, softCookTime: 12.0),
    PastaType(name: NSLocalizedString("Fettuccine", comment: "Fettuccine pasta"), jarImage: "fettuccine.png", onePasta: "one_fettuccine.png", aldenteCookTime: 6.0, softCookTime: 8.0),
    PastaType(name: NSLocalizedString("Fusilli", comment: "Fusilli pasta"), jarImage: "fusilli.png", onePasta: "one_fusilli.png", aldenteCookTime: 12.0, softCookTime: 17.0),
    PastaType(name: NSLocalizedString("Linguine", comment: "Linguine pasta"), jarImage: "linguine.png", onePasta: "one_linguine.png", aldenteCookTime: 9.0, softCookTime: 13.0),
    PastaType(name: NSLocalizedString("Orecchiette", comment: "Orecchiette pasta"), jarImage: "orecchiette.png", onePasta: "one_orecchiette.png", aldenteCookTime: 11.0, softCookTime: 13.0),
    PastaType(name: NSLocalizedString("Vermicelli", comment: "Vermicelli pasta"), jarImage: "vermicelli.png", onePasta: "one_vermicelli.png", aldenteCookTime: 2.0, softCookTime: 3.0),
    PastaType(name: NSLocalizedString("Rigatoni", comment: "Rigatoni pasta"), jarImage: "rigatoni.png", onePasta: "one_rigatoni.png", aldenteCookTime: 12.0, softCookTime: 15.0),
    PastaType(name: NSLocalizedString("Ziti", comment: "Ziti pasta"), jarImage: "ziti.png", onePasta: "one_ziti.png", aldenteCookTime: 14.0, softCookTime: 15.0),
    PastaType(name: NSLocalizedString("Rotelle", comment: "Rotelle pasta"), jarImage: "rotelle.png", onePasta: "one_rotelle.png", aldenteCookTime: 10.0, softCookTime: 12.0),
    PastaType(name: NSLocalizedString("Tagliatelle", comment: "Tagliatelle pasta"), jarImage: "tagliatelle.png", onePasta: "one_tagliatelle.png", aldenteCookTime: 7.0, softCookTime: 9.0),
    PastaType(name: NSLocalizedString("Pappardelle", comment: "Pappardelle pasta"), jarImage: "pappardelle.png", onePasta: "one_pappardelle.png", aldenteCookTime: 7.0, softCookTime: 9.0),
    PastaType(name: NSLocalizedString("Cavatappi", comment: "Cavatappi pasta"), jarImage: "cavatappi.png", onePasta: "one_cavatappi.png", aldenteCookTime: 11.0, softCookTime: 13.0),
    PastaType(name: NSLocalizedString("Anelloni", comment: "Anelloni pasta"), jarImage: "anelloni.png", onePasta: "one_anelloni.png", aldenteCookTime: 11.0, softCookTime: 13.0),
    PastaType(name: NSLocalizedString("Gemelli", comment: "Gemelli pasta"), jarImage: "gemelli.png", onePasta: "one_gemelli.png", aldenteCookTime: 12.0, softCookTime: 15.0),
    PastaType(name: NSLocalizedString("Casarecce", comment: "Casarecce pasta"), jarImage: "casarecce.png", onePasta: "one_casarecce.png", aldenteCookTime: 9.0, softCookTime: 12.0),
    PastaType(name: NSLocalizedString("Ptitim", comment: "Ptitim pasta"), jarImage: "ptitim.png", onePasta: "one_ptitim.png", aldenteCookTime: 18.0, softCookTime: 20.0)
]

func generateRandomArray<T>(from theArray: [T], count: Int) -> [T]? {

    if theArray.count < count || count < 1 {
        return nil
    }

    var rndArray = [T]()
    var indexArray = Array(0...theArray.count-1)

    for _ in 0...count-1 {
        let index = Int.random(in: 0...indexArray.count-1)
        rndArray.append(theArray[indexArray[index]])
        indexArray.remove(at: index)
    }

    return rndArray
}

func backgroudColor() -> UIColor {
    return UIColor(patternImage: UIImage(named: "pattern")!)
}

func navigationBarColor() -> UIColor {
    return UIColor(named: "navigationBarColor")!
}

func configureRightNavButton(button: UIBarButtonItem?) {
    let settings = AppSettings.shared
    
    if let timeStamp = settings.timeStamp as Date? {
        let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
        if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
            button?.isEnabled = true
            
            button?.customView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

            UIView.animate(withDuration: 1.0,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 6.0,
                options: .allowUserInteraction,
                animations: {
                    button?.customView?.transform = .identity
                },
                completion: nil)
            
        }else{
            button?.isEnabled = false
        }
    }else{
        button?.isEnabled = false
    }
}

func isSegueValid(button: UIBarButtonItem?) -> Bool {
    let settings = AppSettings.shared
    
    if let timeStamp = settings.timeStamp as Date? {
        let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
        if (settings.isTimerRunning && remainedInterval > 0) || settings.isTimerPaused {
            return true
        }
    }
    button?.isEnabled = false
    return false
}

func appDelegate () -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}


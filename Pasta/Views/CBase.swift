//
//  VBase.swift
//  Pasta
//
//  Created by Alex Fedoseev on 16.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//
import Foundation
import UIKit

class CBase: UICollectionViewController {
    
    fileprivate var listenersActivated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onStop()
        removeListeners()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        onStop()
        removeListeners()
    }
    
    internal func iniListeners() {
        if (!listenersActivated) {
            NotificationCenter.default.addObserver(self, selector: #selector(onStop), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onStart), name: UIApplication.didBecomeActiveNotification, object: nil)
            listenersActivated = true
        }
    }
    
    internal func removeListeners() {
        NotificationCenter.default.removeObserver(self)
        listenersActivated = false
    }
    
    @objc internal func onStop() {
        
    }
    @objc internal func onStart() {
        iniListeners()
    }
    
}

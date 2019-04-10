//
//  TimerViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 08.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: VBase {

    public var interval: TimeInterval = 0
    public var isTimerRunning = false
    public var isTimerPaused = false
    public var isLaunchedByFirstController = false
    
    private var seconds = 0.0
    private var timer = Timer()
    private let notificationIdentifier = "ru.lxfedoseev.pastatimernotification"
    private let settings = AppSettings.shared
    private let steamView1 = UIImageView(image: UIImage(named: "steam1"))
    private let steamView2 = UIImageView(image: UIImage(named: "steam1"))
    private let steamView3 = UIImageView(image: UIImage(named: "steam1"))
    let steamImages: [UIImage] = [UIImage(named: "steam1")!,UIImage(named: "steam2")!,UIImage(named: "steam3")!]
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startCancelButton: UIButton!
    @IBOutlet weak var stoveView: UIView!
    @IBOutlet weak var potView: UIImageView!
    @IBOutlet weak var potContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        removeNotification()
    }
    
    private func configureView(){
        self.navigationItem.title = NSLocalizedString("Timer", comment: "Timer title")
        self.navigationItem.largeTitleDisplayMode = .never
        cancelButton.layer.cornerRadius = 10
        startCancelButton.layer.cornerRadius = 10
        stoveView.layer.cornerRadius = 10

        view.backgroundColor = backgroudColor()
        
        potContainerView.insertSubview(steamView1, belowSubview: potView)
        potContainerView.insertSubview(steamView2, belowSubview: potView)
        potContainerView.insertSubview(steamView3, belowSubview: potView)
        
        let yPosition = potView.layer.position.y - potView.bounds.height/2 + steamView1.bounds.height/2
        steamView1.layer.position.y = yPosition
        steamView1.alpha = 1.0
        steamView1.translatesAutoresizingMaskIntoConstraints = false
        steamView1.centerXAnchor.constraint(equalTo: potContainerView.centerXAnchor ).isActive = true
        
        steamView2.layer.position.y = yPosition
        steamView2.alpha = 1.0
        steamView2.translatesAutoresizingMaskIntoConstraints = false
        steamView2.centerXAnchor.constraint(equalTo: potContainerView.centerXAnchor, constant: 50).isActive = true
        
        steamView3.layer.position.y = yPosition
        steamView3.alpha = 1.0
        steamView3.translatesAutoresizingMaskIntoConstraints = false
        steamView3.centerXAnchor.constraint(equalTo: potContainerView.centerXAnchor, constant: -50).isActive = true
        
        
        if !isTimerRunning && !isTimerPaused {
            seconds = interval
        }
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)
        
        if isTimerRunning {
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            stoveView.backgroundColor = UIColor.myRedColor
            animateSteam(self.steamView1)
            animateSteam(self.steamView2)
            animateSteam(self.steamView3)
        } else if isTimerPaused {
            startCancelButton.setTitle(NSLocalizedString("Resume", comment: "Resume button title"), for: .normal)
            stoveView.backgroundColor = UIColor.black
        } else {
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            cancelButton.isEnabled = false
            stoveView.backgroundColor = UIColor.black
            self.stopAnimateSteam(self.steamView1)
            self.stopAnimateSteam(self.steamView2)
            self.stopAnimateSteam(self.steamView3)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            seconds = interval
            timerLabel.text = timeString(time: TimeInterval(seconds))
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            stopAnimation()
            isTimerRunning = false
            cancelButton.isEnabled = false
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (Bool) -> ()){
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            guard settings.authorizationStatus == .authorized else {return}
            
            let notificationContent = UNMutableNotificationContent()
            
            notificationContent.title = NSLocalizedString("Time's up!", comment: "Time's up notification message")
            notificationContent.subtitle = NSLocalizedString("Pasta is ready", comment: "Pasta is ready notification message")
            notificationContent.body = NSLocalizedString("Turn off the stove and take off the pot", comment: "Turn off notification message")
            notificationContent.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
            
            let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request){ error in
                
                if error != nil {
                    print("\(error)")
                    completion(false)
                }else {
                    completion(true)
                }
            }
        }
    }
    
    // Mark: - Action Methods
    @IBAction func startPauseButtonTapped(_ sender: UIButton) {
        if !isTimerRunning && seconds > 0 { // Timer is not running and Start tapped
            
            scheduleNotification(inSeconds: seconds + 2.0) { success in
                if success {
                    print("Notification scheduled successfully")
                }else {
                    print("Error scheduling notification")
                }
            }
            
            runTimer()
            startAnimation()
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            cancelButton.isEnabled = true
            isTimerRunning = true
            isTimerPaused = false
        } else { // Timer is running and Pause button tapped
            if seconds == 0 {
                seconds = 1.0
                timerLabel.text = timeString(time: TimeInterval(seconds))
            }
            timer.invalidate()
            removeNotification()
            stopAnimation()
            startCancelButton.setTitle(NSLocalizedString("Resume", comment: "Resume button title"), for: .normal)
            isTimerRunning = false
            isTimerPaused = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        timer.invalidate()
        removeNotification()
        stopAnimation()
        startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
        cancelButton.isEnabled = false
        isTimerRunning = false
        isTimerPaused = false
        seconds = interval
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    // Mark: - overrides
    override func onStart() {
        super.onStart()
        loadSettings()
        configureView()
        launchedByFirstController()
        
    }
    override func onStop() {
        super.onStop()
        updateSettings(for: Date(), and: seconds)
        appGoesBackground()
    }
    
    // Mark: - private functions
    private func updateSettings(for currentTime: Date, and seconds: TimeInterval) {
        settings.isTimerRunning = isTimerRunning
        settings.isTimerPaused = isTimerPaused
        settings.remainedSeconds = seconds
        settings.timeStamp = currentTime
        settings.actualInterval = interval
    }
    
    private func loadSettings() {
        isTimerRunning = settings.isTimerRunning
        isTimerPaused = settings.isTimerPaused
        let savedInterval = settings.actualInterval
        if savedInterval > 0 {
            interval = savedInterval
        }

        if let timeStamp = settings.timeStamp as Date? {
            let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
            if isTimerRunning && remainedInterval > 0 {
                seconds = remainedInterval
            } else if isTimerPaused {
                seconds = settings.remainedSeconds
            } else {
                timer.invalidate()
                isTimerRunning = false
                seconds = 0
            }
        }
    }
    
    private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [self.notificationIdentifier])
    }
    
    private func launchedByFirstController() {
        if isLaunchedByFirstController && isTimerRunning {
                scheduleNotification(inSeconds: seconds + 2.0) { success in
                    if success {
                        print("Notification scheduled successfully")
                    }else {
                        print("Error scheduling notification")
                    }
                }
                runTimer()
        }
        isLaunchedByFirstController = false
    }
    
    fileprivate func startAnimation() {
        guard !isTimerRunning else { return }
        
        self.stoveView.backgroundColor = UIColor(cgColor: self.stoveView.layer.presentation()?.backgroundColor ?? UIColor.black.cgColor)
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
            animations: {
                self.stoveView.backgroundColor = UIColor.myRedColor
        }, completion: {_ in
            self.animateSteam(self.steamView1)
            self.animateSteam(self.steamView2)
            self.animateSteam(self.steamView3)
        })
    }
    
    fileprivate func stopAnimation() {
        guard  isTimerRunning else { return }
        
        self.stoveView.backgroundColor = UIColor(cgColor: self.stoveView.layer.presentation()?.backgroundColor ?? UIColor.myRedColor.cgColor)
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
                       animations: {
                        self.stoveView.backgroundColor = UIColor.black
        }, completion: {_ in
            self.finishAnimateSteam(self.steamView1)
            self.finishAnimateSteam(self.steamView2)
            self.finishAnimateSteam(self.steamView3)
        })
    }
    
    fileprivate func appGoesBackground() {
        guard isTimerRunning else { return }
        self.finishAnimateSteam(self.steamView1)
        self.finishAnimateSteam(self.steamView2)
        self.finishAnimateSteam(self.steamView3)
    }
    
    fileprivate func animateSteam(_ steam: UIImageView) {
        
        let yAnimation = CABasicAnimation(keyPath: "position.y")
        yAnimation.fromValue = potView.layer.position.y - potView.bounds.height/2 + steam.bounds.height/2
        yAnimation.toValue = potView.layer.position.y - 200
        yAnimation.duration = 5.0
        yAnimation.repeatCount = Float.infinity

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 5.0
        opacityAnimation.repeatCount = Float.infinity
        
        steam.animationImages = steamImages.shuffled()
        steam.animationDuration = 0.8
        steam.animationRepeatCount = 0

        steam.layer.add(yAnimation, forKey: "steamX")
        steam.layer.add(opacityAnimation, forKey: "steamOpacity")
        steam.startAnimating()
    }
    
    fileprivate func finishAnimateSteam(_ steam: UIImageView){
        let position = steam.layer.presentation()?.position.y
        let opacity = steam.layer.presentation()?.opacity
        steam.layer.removeAllAnimations()
        steam.stopAnimating()
        
        let yAnimation = CABasicAnimation(keyPath: "position.y")
        yAnimation.fromValue = position
        yAnimation.toValue = position! - 50
        yAnimation.duration = 1
        yAnimation.repeatCount = 1
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = opacity
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 1
        opacityAnimation.repeatCount = 1
        
        steam.animationImages = steamImages.shuffled()
        steam.animationDuration = 1
        steam.animationRepeatCount = 1
        
        steam.layer.add(yAnimation, forKey: nil)
        steam.layer.add(opacityAnimation, forKey: nil)
        steam.startAnimating()
    }
    
    fileprivate func stopAnimateSteam(_ steam: UIImageView){
        steam.layer.removeAllAnimations()
        steam.stopAnimating()
    }
    
    // MARK: - State Encode-Decoder
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        isLaunchedByFirstController = true
        launchedByFirstController()
    }
}


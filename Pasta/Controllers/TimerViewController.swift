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
    private let notificationIdentifier = "ru.almaunion.pastatimernotification"
    private let settings = AppSettings.shared
    private let steamView1 = UIImageView(image: UIImage(named: "steam1"))
//    private var steamAnimator: UIViewPropertyAnimator?
    
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
        
        steamView1.layer.position.x = potView.center.x
        steamView1.layer.position.y = potView.layer.position.y - potView.bounds.height/2 + steamView1.bounds.height/2
//        steamView1.frame.origin.x = potView.center.x
//        steamView1.frame.origin.y = potView.frame.origin.y
        steamView1.alpha = 1.0
        potContainerView.insertSubview(steamView1, belowSubview: potView)
        
        
        if !isTimerRunning && !isTimerPaused {
            seconds = interval
        }
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)
        
        if isTimerRunning {
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            print("red stove")
            stoveView.backgroundColor = UIColor.red
            animateSteam(steamView1)
        } else {
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            stoveView.backgroundColor = UIColor.black
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            stopAnimation()
            isTimerRunning = false
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
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
            
            scheduleNotification(inSeconds: seconds) { success in
                if success {
                    print("Notification scheduled successfully")
                }else {
                    print("Error scheduling notification")
                }
            }
            
            runTimer()
            startAnimation()
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            isTimerRunning = true
            isTimerPaused = false
        } else { // Timer is running and Pause button tapped
            timer.invalidate()
            removeNotification()
            stopAnimation()
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            isTimerRunning = false
            isTimerPaused = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        timer.invalidate()
        removeNotification()
        stopAnimateSteam(steamView1)
        stopAnimation()
        startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
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
        print("updateSettings")
        settings.isTimerRunning = isTimerRunning
        settings.isTimerPaused = isTimerPaused
        settings.remainedSeconds = seconds
        settings.timeStamp = currentTime
        settings.actualInterval = interval
    }
    
    private func loadSettings() {
        print("loadSettings")
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
            
                scheduleNotification(inSeconds: seconds) { success in
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
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
            animations: {
                self.stoveView.backgroundColor = UIColor.red
        }, completion: {_ in
            self.animateSteam(self.steamView1)
        })
    }
    
    fileprivate func stopAnimation() {
        guard  isTimerRunning else { return }
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [],
                       animations: {
                        self.stoveView.backgroundColor = UIColor.black
        }, completion: {_ in
            self.stopAnimateSteam(self.steamView1)
        })
    }
    
    fileprivate func appGoesBackground() {
        guard isTimerRunning else { return }
        
        self.stopAnimateSteam(self.steamView1)
    }
    
    fileprivate func animateSteam(_ steam: UIImageView) {
        
//        steamAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3.0, delay: 0.0, options: [.curveLinear,.repeat],
//        animations: {
//            steam.frame.origin.y = self.potView.frame.origin.y - 200
//            steam.alpha = 0.0
//        }, completion: {position in
//            steam.frame.origin.y = self.potView.frame.origin.y
//            steam.alpha = 1.0
//            self.animateSteam(steam)
//        })
        
        let yAnimation = CABasicAnimation(keyPath: "position.y")
        yAnimation.fromValue = potView.layer.position.y - potView.bounds.height/2 + steamView1.bounds.height/2
        yAnimation.toValue = potView.layer.position.y - 200
        yAnimation.duration = 3.0
        yAnimation.repeatCount = Float.infinity

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 3.0
        opacityAnimation.repeatCount = Float.infinity

        steam.layer.add(yAnimation, forKey: "steamX")
        steam.layer.add(opacityAnimation, forKey: "steamOpacity")
    }
    
    fileprivate func stopAnimateSteam(_ steam: UIImageView){
        
//        steamAnimator?.stopAnimation(true)
        steam.layer.removeAllAnimations()
        
    }
    
}

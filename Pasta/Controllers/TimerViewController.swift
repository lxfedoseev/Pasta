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

    public var alDente = false
    public var interval: TimeInterval = 0
    public var isTimerRunning = false
    
    private var seconds = 0.0
    
    private var timer = Timer()
    private let notificationIdentifier = "ru.almaunion.pastatimernotification"
    private let settings = AppSettings.shared
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startCancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        removeNotification()
    }
    
    private func configureView(){
        self.navigationItem.title = NSLocalizedString("Timer", comment: "Timer title")
        self.navigationItem.largeTitleDisplayMode = .never
        
        seconds = interval
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)
        if !isTimerRunning {
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
        }else {
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
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
        if seconds == 1 {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            //Send alert to indicate "time's up!"
        } else if seconds < 1 {
            timer.invalidate()
            isTimerRunning = false
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
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
        if !isTimerRunning { // Timer is not running and Start tapped
            
            scheduleNotification(inSeconds: seconds) { success in
                if success {
                    print("Notification scheduled successfully")
                }else {
                    print("Error scheduling notification")
                }
            }
            
            runTimer()
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            isTimerRunning = true
        } else { // Timer is running and Pause button tapped
            timer.invalidate()
            removeNotification()
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            isTimerRunning = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        timer.invalidate()
        removeNotification()
        startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
        isTimerRunning = false
        seconds = interval
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    // Mark: - overrides
    override func onStart() {
        super.onStart()
        loadSettings()
        configureView()
    }
    override func onStop() {
        super.onStop()
        updateSettings(for: Date(), and: seconds)
    }
    
    // Mark: - private functions
    private func updateSettings(for currentTime: Date, and seconds: TimeInterval) {
        print("updateSettings")
        settings.isTimerRunning = isTimerRunning
        settings.remainedSeconds = seconds
        settings.timeStamp = currentTime
    }
    
    private func loadSettings() {
        print("loadSettings")
        isTimerRunning = settings.isTimerRunning
        
        if let timeStamp = settings.timeStamp as Date? {
            let remainedInterval = settings.remainedSeconds - Date().timeIntervalSince(timeStamp)
            if isTimerRunning && remainedInterval > 0 {
                interval = remainedInterval
            } else {
                timer.invalidate()
                isTimerRunning = false
                seconds = 0
                timerLabel.text = timeString(time: TimeInterval(seconds))
            }
        }
    }
    
    private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [self.notificationIdentifier])
    }
    
}

//
//  TimerViewController.swift
//  Pasta
//
//  Created by Alex Fedoseev on 08.01.2019.
//  Copyright © 2019 Alex Fedoseev. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController {

    public var selectedPasta: PastaType!
    public var alDente = false
    private var interval: TimeInterval {
        return alDente ? selectedPasta.aldenteCookTime : selectedPasta.softCookTime
    }
    
    private var seconds = 0.0
    
    private var timer = Timer()
    private var isTimerRunning = false
    private let notificationIdentifier = "ru.almaunion.pastatimernotification"
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startCancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seconds = interval
        // Do any additional setup after loading the view.
        configureView()
    }
    
    private func configureView(){
        self.navigationItem.title = NSLocalizedString("Timer", comment: "Timer title")
        self.navigationItem.largeTitleDisplayMode = .never
        
        timerLabel.text = timeString(time: TimeInterval(seconds))
        if !isTimerRunning {
            cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
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
            scheduleNotification(inSeconds: 1) { success in
                if success {
                    print("Notification scheduled successfully")
                }else {
                    print("Error scheduling notification")
                }
            }
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
            runTimer()
            startCancelButton.setTitle(NSLocalizedString("Pause", comment: "Pause button title"), for: .normal)
            isTimerRunning = true
        } else { // Timer is running and Pause button tapped
            timer.invalidate()
            startCancelButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), for: .normal)
            isTimerRunning = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        timer.invalidate()
        isTimerRunning = false
        seconds = interval
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
}

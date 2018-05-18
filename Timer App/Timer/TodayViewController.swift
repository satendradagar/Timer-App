//
//  TodayViewController.swift
//  Timer
//
//  Created by Satendra Dagar on 01/05/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Cocoa
import NotificationCenter
import AudioToolbox

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet var minutes: NSTextField!
    
    @IBOutlet var seconds: NSTextField!

    @IBOutlet var minutesCell: NSTextFieldCell!
    
    @IBOutlet var secondsCell: NSTextFieldCell!
    
    var timer :Timer?
    var secondsCounter:Int32 = 0;
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }
    
    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets
    {
            return NSEdgeInsetsZero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secondsCell.focusRingType = .none
        self.minutesCell.focusRingType = .none
        self.minutes.textColor = NSColor.init(red: 0.01, green: 0, blue: 0, alpha: 1);
        self.seconds.textColor = NSColor.init(red: 0.01, green: 0, blue: 0, alpha: 1);
        resetContent()

//        timeField.cell?.formatter = dateFormatter
//    .cells().makeObjectsPerform(Selector("setFormatter:"), withObject: dateFormatter)
    }
    
    @IBAction func didClickedStart(sender:NSButton?){
        timer?.invalidate() // just in case this button is tapped multiple times
        let mins = self.minutes.intValue;
        let secs = self.seconds.intValue;

        secondsCounter = mins * 60 + secs;
        if secondsCounter <= 0 {
            return
        }
        // start the timer
        seconds.resignFirstResponder()
        minutes.resignFirstResponder()
        seconds.isEditable = false
        minutes.isEditable = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // stop timer
    @IBAction func cancelTimerButtonTapped(sender: NSButton?) {
        
        if timer == nil{
            
            resetContent()

        }
        seconds.isEditable = true
        minutes.isEditable = true

        timer?.invalidate()
        timer = nil
//        timer = nil;
    }
    
    func resetContent() -> Void {
        if timer == nil{
            self.minutes.intValue = 05;
            self.seconds.intValue = 00;
        }
        self.minutes.abortEditing()
        self.seconds.abortEditing()

    }
    
    @IBAction func didClickedStop(sender:NSButton?){
        
    }

    // called every time interval from the timer
    @objc func timerAction() {
        secondsCounter -= 1
        print("\(secondsCounter)")
//        label.stringValue = "\(counter)"
        self.updateLabels()
        if secondsCounter == 0 {
            self.cancelTimerButtonTapped(sender: nil)
            showNotification()
        }
    }
    
    func showNotification() -> Void {
        
        SystemSoundID.playFileNamed(fileName: "Glass", withExtenstion: "aiff")

        let notification = NSUserNotification()
        notification.title = "Test from Swift"
        notification.informativeText = "The body of this Swift notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = Date().addingTimeInterval(5) as Date
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    func updateLabels() -> Void {
        let (_,mins,second) = secondsToHoursMinutesSeconds(seconds: secondsCounter)
        self.minutes.intValue = Int32(mins);
        self.seconds.intValue = Int32(second)
        print("Minutes:\(mins) second:\(second)")
        self.minutes.abortEditing()
        self.seconds.abortEditing()

    }
    
    func secondsToHoursMinutesSeconds (seconds : Int32) -> (Int, Int, Int) {
        return (Int(seconds / 3600), Int((seconds % 3600) / 60), Int((seconds % 3600) % 60))
    }
}


extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}


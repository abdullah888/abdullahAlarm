//
//  AddReminderViewController.swift
//  abdullahAlarm
//
//  Created by abdullah  on 26/05/1441 AH.
//  Copyright © 1441 abdullah . All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController , UITextFieldDelegate {
    
    var reminder : Reminder?
    
    @IBOutlet weak var ReminderTextField: UITextField!
    
    
    @IBOutlet weak var TimePicker: UIDatePicker!
    
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ReminderTextField.delegate = self
        TimePicker.minimumDate = NSDate() as Date
        TimePicker.locale = NSLocale.current

        // Do any additional setup after loading the view.
    }
    
    func ChecKName() {
        let text = ReminderTextField.text ?? ""
        SaveButton.isEnabled = !text.isEmpty
    }
    
    func ChecKDate() {
        if NSDate().earlierDate(TimePicker.date) == TimePicker.date {
            SaveButton.isEnabled = false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ChecKName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SaveButton.isEnabled = false
    }
    
    
    
    
    @IBAction func TimeChanged(_ sender: UIDatePicker) {
        ChecKDate()
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
         
            if sender as AnyObject? === SaveButton {
            let name = ReminderTextField.text
            var time = TimePicker.date
            let timeIneInterval = floor(time.timeIntervalSinceReferenceDate / 60) * 60
            
            time = NSDate(timeIntervalSinceReferenceDate: timeIneInterval) as Date
            
            let notification = UILocalNotification()
            notification.alertTitle = "Reminder"
                notification.alertBody = "Don't forget to \(String(describing: name))!"
            notification.fireDate = time
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
                
         reminder = Reminder(name: name!, time: time as NSDate, notification: notification)
            

        }
    }
    

}

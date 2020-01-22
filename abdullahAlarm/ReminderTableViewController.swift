//
//  ReminderTableViewController.swift
//  abdullahAlarm
//
//  Created by abdullah  on 26/05/1441 AH.
//  Copyright © 1441 abdullah . All rights reserved.
//

import UIKit
import UserNotifications

class ReminderTableViewController: UITableViewController {
    var beenViewed = false
    var reminders = [Reminder]()
    let dateformatter = DateFormatter()
    let locale = NSLocale.current
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !beenViewed {
            beenViewed = true

            if #available(iOS 13.0, *) {
                // Only be notified of my own window scene
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIScene.didEnterBackgroundNotification, object: self.view.window?.windowScene)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            }
        }
    }
    
    @objc func didEnterBackground() {
        // Do my background stuff
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        dateformatter.locale = locale
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        
        if let saveReminders = loadReminders() {
            reminders += saveReminders
        }
        
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        // Configure the cell...
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Don" + dateformatter.string(from: reminder.time as Date)
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = reminders.remove(at: indexPath.row)
//            delete(toRemove)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveReminders()
            
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    
    @IBAction func unwindToReminderList(sender : UIStoryboardSegue){
        if let sourceView = sender.source as? AddReminderViewController , let reminder = sourceView.reminder{
            let newindexPath = NSIndexPath(row : reminders.count , section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [(newindexPath as IndexPath)], with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
    
    
    
    
    
    
    
    func saveReminders(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        if (isSuccessfulSave) {
            print ("Saved Successfully")

        } else {
            print("Failed to Save")
        }
    }

    
    func loadReminders() -> [Reminder]?{
        
        return NSKeyedUnarchiver.unarchiveObject( withFile: Reminder.ArchiveURL.path) as? [Reminder]

    }
}

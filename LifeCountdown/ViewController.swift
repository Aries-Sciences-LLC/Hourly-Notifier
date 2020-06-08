//
//  ViewController.swift
//  LifeCountdown
//
//  Created by Ozan Mirza on 8/5/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import UIKit
import ADDatePicker
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: ADDatePicker!
    @IBOutlet weak var dateLbl: DateLabel!
    @IBOutlet weak var setDateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var helpDate: UILabel!
    @IBOutlet weak var nameController: UIVisualEffectView!
    
    var stage = 0
    
    var startDate: Date!
    var endDate: Date!
    var intervals: Int!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        datePicker.yearRange(inBetween: Int(Calendar.current.component(.year, from: Date())), end: Int(Calendar.current.component(.year, from: Date())) + 4)
        
        //set Selection and Deselection Background Colors
        datePicker.bgColor = .clear
        
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .white
        
        //set Selection and Deselection Text Colors
        datePicker.selectedTextColor = .black
        datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
        
        //set Selection Hover Type
        datePicker.selectionType = .circle
        
        // set Date Picker's delegate
        datePicker.delegate = self
        
        nameController.alpha = 0
        nameController.isHidden = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {_,_  in})
        
        if UserDefaults.standard.value(forKey: "Name") != nil {
            InformationPackage.unpack()
            self.present(self.storyboard!.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func createCountdown(_ sender: UIButton) {
        if stage == 0 {
            stage = 1
            startDate = dateLbl.date
            sender.setTitle("Set End Date", for: .normal)
            sender.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.alpha = 0.6
            }
            UIView.animate(withDuration: 0.5) {
                sender.frame.origin.x = 84
                sender.frame.size.width = self.view.frame.size.width - 100
                self.backBtn.alpha = 1
                self.setDateBtn.backgroundColor = #colorLiteral(red: 0.4261761308, green: 0.6169299483, blue: 0.6751927733, alpha: 1)
                self.view.backgroundColor = #colorLiteral(red: 0.5564764738, green: 0.754239738, blue: 0.6585322022, alpha: 1)
            }
        } else if stage == 1 {
            stage = 2
            endDate = dateLbl.date
            nameController.isHidden = false
            sender.isEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.alpha = 0.6
                self.nameController.alpha = 1
            }
            (nameController.contentView.subviews[0] as? UITextField)!.becomeFirstResponder()
        } else if stage == 2 {
            name = (nameController.contentView.subviews[0] as? UITextField)!.text
            let hours = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            for i in 1...hours {
                let content = UNMutableNotificationContent()
                content.title = "Another Hour Passed While You Were Doing Your \(name!)!"
                content.subtitle = "Remember, you now have \(hours - i) from the total \(hours)"
                content.body = "You started the \(name!) at \(dateFormatter.string(from: startDate!)) and it will end at \(dateFormatter.string(from: endDate!))"
                content.badge = 0
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(i * 3600), repeats: false)
                let request = UNNotificationRequest(identifier: "hourNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
            InformationPackage.export(startDate: startDate, endDate: endDate, name: name, created: true)
            InformationPackage.pack()
            
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func redoSetting(_ sender: UIButton) {
        if stage == 1 {
            stage = 0
            startDate = nil
            self.setDateBtn.setTitle("Set Start Date", for: .normal)
            self.setDateBtn.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.alpha = 1.0
            }
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.frame.origin.x = 16
                self.setDateBtn.frame.size.width = self.view.frame.size.width - 32
                self.backBtn.alpha = 0
                self.setDateBtn.backgroundColor = #colorLiteral(red: 0.5564764738, green: 0.754239738, blue: 0.6585322022, alpha: 1)
                self.view.backgroundColor = #colorLiteral(red: 0.4261761308, green: 0.6169299483, blue: 0.6751927733, alpha: 1)
            }
        } else if stage == 2 {
            stage = 1
            endDate = nil
            sender.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.setDateBtn.alpha = 1.0
                self.nameController.alpha = 0
            }) { _ in
                self.nameController.isHidden = true
            }
            
            (nameController.contentView.subviews[0] as? UITextField)!.text = ""
            (nameController.contentView.subviews[0] as? UITextField)!.resignFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.setDateBtn.frame.origin.y = self.view.frame.size.height - 335
            self.backBtn.frame.origin.y = self.view.frame.size.height - 335
            self.setDateBtn.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.3098039216, blue: 0.3960784314, alpha: 1)
            self.backBtn.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.3098039216, blue: 0.3960784314, alpha: 1)
        }
        
        setDateBtn.setTitle("Create Session", for: UIControl.State.normal)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.setDateBtn.frame.origin.y = self.view.frame.size.height - 70
            self.backBtn.frame.origin.y = self.view.frame.size.height - 70
            self.setDateBtn.backgroundColor = #colorLiteral(red: 0.4261761308, green: 0.6169299483, blue: 0.6751927733, alpha: 1)
            self.backBtn.backgroundColor = #colorLiteral(red: 0.4261761308, green: 0.6169299483, blue: 0.6751927733, alpha: 1)
        }
        
        setDateBtn.setTitle("Set End Date", for: UIControl.State.normal)
    }
    
    @IBAction func checkForExit(_ sender: UITextField) {
        if sender.text == nil {
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.alpha = 0.6
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.setDateBtn.alpha = 1.0
            }
        }

        self.setDateBtn.isEnabled = sender.text != nil
    }
}

extension ViewController: ADDatePickerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        ADDatePicker(didChange: datePicker.intialDate)
        
        if UserDefaults.standard.value(forKey: "Name") != nil {
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController, animated: true, completion: nil)
        }
    }
    
    func ADDatePicker(didChange date: Date) {
        if stage == 1 {
            if date < startDate {
                UIView.animate(withDuration: 0.5) {
                    self.helpDate.alpha = 1.0
                    self.setDateBtn.alpha = 0.6
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.helpDate.alpha = 0.0
                    self.setDateBtn.alpha = 1.0
                }
            }
            self.setDateBtn.isEnabled = date > startDate
        }
        
        self.dateLbl.date = date
        UIView.animate(withDuration: 0.25, animations: {
            self.dateLbl.alpha = 0
        }, completion: { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            self.dateLbl.text = dateFormatter.string(from: date) == dateFormatter.string(from: Date()) ? "Today's Date" : dateFormatter.string(from: date)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.dateLbl.alpha = 1
            })
        })
    }
}

//
//  InformationViewController.swift
//  LifeCountdown
//
//  Created by Ozan Mirza on 8/5/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import UIKit
import KDCircularProgress
import UserNotifications

class InformationViewController: UIViewController {

    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var percentageView: UILabel!
    @IBOutlet weak var startingDateLbl: UILabel!
    @IBOutlet weak var endingDateLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var congratsPopUp: UIVisualEffectView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hoursLeft: UILabel!
    @IBOutlet weak var hoursUsed: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        startingDateLbl.text = dateFormatter.string(from: InformationPackage.startDate)
        endingDateLbl.text = dateFormatter.string(from: InformationPackage.endDate)
        titleLbl.text = InformationPackage.name
        
        totalHours.text = "\(InformationPackage.getTotalHours()) Total Hours"
        hoursUsed.text = "\(InformationPackage.getUsedHours()) Hours Used"
        hoursLeft.text = "\(InformationPackage.getLeftHours()) Hours Left"
        
        percentageView.text = "\(InformationPackage.getPercentUsedHours())%"
        
        (congratsPopUp.contentView.subviews[1] as? UILabel)?.text = "You just created a new session, \(String(describing: InformationPackage.name!)), during the time between the start and end date, you will receive a notification every hour"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if InformationPackage.created {
            UIView.animate(withDuration: 0.5) {
                self.congratsPopUp.alpha = 1
                self.congratsPopUp.center = self.view.center
            }
            InformationPackage.created = false
            InformationPackage.pack()
        }
        
        progressView.animate(toAngle: Double(InformationPackage.getAngleUsedHours()), duration: 1.0, completion: nil)
    }
    
    @IBAction func hidePopUp(_ sender: UIButton) {
        if (self.congratsPopUp.contentView.subviews[0] as? UILabel)?.text != "Confirmation" {
            UIView.animate(withDuration: 0.5, animations: {
                self.congratsPopUp.alpha = 0
                self.congratsPopUp.frame.origin.y = -self.congratsPopUp.frame.size.height
            })
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            InformationPackage.clear()
            dismiss(animated: true, completion: nil)
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
    
    @IBAction func cancelCountdown(_ sender: UIButton) {
        (self.congratsPopUp.contentView.subviews[0] as? UILabel)?.text = "Confirmation"
        (self.congratsPopUp.contentView.subviews[1] as? UILabel)?.text = "Are you sure that you would like to quit this session? That means that all future notifications will be deleted and that you would lose all your progress."
        (self.congratsPopUp.contentView.subviews[2] as? UIButton)?.setImage(UIImage(named: "Checkmark"), for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.infoView.frame.origin.y = self.view.frame.size.height - 20
            self.congratsPopUp.alpha = 1
            self.congratsPopUp.center.y = self.view.frame.size.height / 2
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self.view)
        
        if infoView.frame.contains(touchLocation) {
            UIView.animate(withDuration: 0.5) {
                if self.infoView.frame.origin.y == self.view.frame.size.height - 20 {
                    self.infoView.frame.origin.y = self.view.frame.size.height - self.infoView.frame.size.height - 10
                } else {
                    self.infoView.frame.origin.y = self.view.frame.size.height - 20
                }
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.congratsPopUp.alpha = 0
                self.congratsPopUp.frame.origin.y = -self.congratsPopUp.frame.size.height
            })
        }
    }
}

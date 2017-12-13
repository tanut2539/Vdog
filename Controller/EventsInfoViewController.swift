//
//  EventsInfoViewController.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class EventsInfoViewController: UITableViewController {

    var Event_Count: String! = ""
    var Event_Id: String! = ""
    var Event_HeaderTitle: String! = ""
    var Event_Date: String! = ""
    var Event_Time: String! = ""
    var Event_DogName: String! = ""
    var Event_HospitalName: String! = ""
    var Event_Details: String! = ""
    var Event_TimeStamp: String! = ""
    
    @IBOutlet weak var HeaderBackground: UIView!
    @IBOutlet weak var Images: UIImageView!
    @IBOutlet weak var TextEventsTitle: UITextField!
    @IBOutlet weak var TextEventsDate: UITextField!
    @IBOutlet weak var TextEventsTime: UITextField!
    @IBOutlet weak var TextEventsDogs: UITextField!
    @IBOutlet weak var TextEventsHospitalName: UITextField!
    @IBOutlet weak var TextEventsDetails: UITextView!
    
    @IBAction func isEditing(_ sender: Any) {
        self.setIsEnabled()
        self.setTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: setData
        self.TextEventsTitle.text = Event_HeaderTitle
        // Convert Date to String
        // Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
        dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
        let date = dateFormatter.date(from: Event_Date) //according to date format your date string
        dateFormatter.dateFormat = "d MMMM yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date!) //pass Date here
        self.TextEventsDate.text = newDate
        self.TextEventsTime.text = Event_Time
        self.TextEventsDogs.text = Event_DogName
        self.TextEventsHospitalName.text = Event_HospitalName
        self.TextEventsDetails.text = Event_Details
        // MARK: setIsDisabled()
        self.setIsDisabled()
        // MARK: Hide Keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.Images.clipsToBounds = true
        self.Images.layer.cornerRadius = 50.0
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Itim-Regular", size: 14)!
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Itim-Regular", size: 14)!
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    private func setIsDisabled() {
        self.TextEventsTitle.isEnabled = false
        self.TextEventsDate.isEnabled = false
        self.TextEventsTime.isEnabled = false
        self.TextEventsDogs.isEnabled = false
        self.TextEventsHospitalName.isEnabled = false
        self.TextEventsDetails.isEditable = false
    }
    
    private func setIsEnabled() {
        self.TextEventsTitle.isEnabled = true
        self.TextEventsDate.isEnabled = true
        self.TextEventsTime.isEnabled = true
        self.TextEventsDogs.isEnabled = true
        self.TextEventsHospitalName.isEnabled = true
        self.TextEventsDetails.isEditable = true
    }
    
    private func setTextField() {
        self.setTextFieldInterface(TextEventsTitle)
        self.setTextFieldInterface(TextEventsDate)
        self.setTextFieldInterface(TextEventsTime)
        self.setTextFieldInterface(TextEventsDogs)
        self.setTextFieldInterface(TextEventsHospitalName)
        self.setTextViewInterface(TextEventsDetails)
    }
    
    private func setTextFieldInterface(_ TextField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1).cgColor // background color
        TextField.borderStyle = UITextBorderStyle.none // border style
        TextField.layer.addSublayer(bottomLine)
    }
    
    private func setTextViewInterface(_ TextView: UITextView) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextView.frame.height - 1, width: TextView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1).cgColor // background color
        
        TextView.layer.addSublayer(bottomLine)
    }
    
    // MARK: Hide Keyboard
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
}

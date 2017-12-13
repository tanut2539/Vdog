//
//  AddEventsViewController.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class AddEventsViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, DataEnteredDelegate {

    // Loading
    var loadingView = UIView()
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var TimerString: String = ""
    var timer : Timer!
    var cntSec = 0
    var cntMS = 0
    // UserPlist
    var plistPathUser: String!
    // Data Source
    var Email: String! = ""
    
    private func LoadUserPlist() {
        let delegate = AppDelegate.sharedInstance
        plistPathUser = delegate.plistPathInUser
        
        do {
            let loadUserEmail = try String(contentsOfFile: plistPathUser)
            Email = loadUserEmail
        } catch {
            print(error)
        }
    }
    
    @IBOutlet weak var HeaderBackground: UIView!
    @IBOutlet weak var TextEventsTitle: UITextField!
    @IBOutlet weak var TextEventsDate: UITextField!
    @IBOutlet weak var TextEventsTime: UITextField!
    @IBOutlet weak var TextEventsDogs: UITextField!
    @IBOutlet weak var TextEventsHospitalName: UITextField!
    @IBOutlet weak var TextEventsDetails: UITextView!
    var DateSeleted: String! = ""
    var placeholderLabel : UILabel!
    
    @IBAction func AddEvents(_ sender: Any) {
        if TextEventsTitle.text == "" {
            // false
            let alert = UIAlertController(title: nil, message: "กรุณากรอกหัวข้อนัดหมาย", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "แก้ไขหัวข้อนัดหมาย", style: .default, handler: {(action) -> Void in
                self.TextEventsTitle.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if TextEventsDate.text == "" {
                // false
                let alert = UIAlertController(title: nil, message: "กรุณาเลือกวันนัดหมาย", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "เลือกวันนัดหมาย", style: .default, handler: {(action) -> Void in
                    self.TextEventsDate.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                if TextEventsTime.text == "" {
                    // false
                    let alert = UIAlertController(title: nil, message: "กรุณาเลือกเวลานัดหมาย", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "เลือกเวลานัดหมาย", style: .default, handler: {(action) -> Void in
                        self.TextEventsTime.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if TextEventsDogs.text == "" {
                        // false
                        let alert = UIAlertController(title: nil, message: "กรุณาเลือกสุนัข", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "เลือกสุนัข", style: .default, handler: {(action) -> Void in
                            self.TextEventsDogs.becomeFirstResponder()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if TextEventsHospitalName.text == "" {
                            // false
                            let alert = UIAlertController(title: nil, message: "กรุณาเลือกคลินิก", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "เลือกคลินิก", style: .default, handler: {(action) -> Void in
                                self.TextEventsHospitalName.becomeFirstResponder()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if TextEventsDetails.text == "" {
                                // false
                                let alert = UIAlertController(title: nil, message: "กรุณากรอกรายละเอียด", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "แก้ไขรายละเอียด", style: .default, handler: {(action) -> Void in
                                    self.TextEventsDetails.becomeFirstResponder()
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                // then
                                self.AddEvents()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoadUserPlist()
        if DateSeleted == "" {
            
        } else {
            // Convert String to Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
            dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
            let date = dateFormatter.date(from: DateSeleted) //according to date format your date string
            dateFormatter.dateFormat = "d MMMM yyyy" //Your New Date format as per requirement change it own
            let newDate = dateFormatter.string(from: date!) //pass Date here
            self.TextEventsDate.text = newDate
        }
        
        self.TextEventsTime.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height:34 ))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1)
        let canecelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(AddEventsViewController.canclePressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventsViewController.donePressed(sender:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let TimePicker = UIDatePicker()
        TimePicker.datePickerMode = UIDatePickerMode.time
        TimePicker.addTarget(self, action: #selector(AddEventsViewController.TimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.TextEventsTime.inputView = TimePicker
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "Itim-Regular", size: 20)!,
                NSAttributedStringKey.foregroundColor : UIColor.darkGray,
                ], for: .normal)
        
        toolbar.setItems([canecelButton,flexButton, doneButton], animated: true)
        self.TextEventsTime.inputAccessoryView = toolbar

        // MARK: setTextField()
        self.setTextField()
        // MARK: Hide Keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))

        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }
    
    @objc func TimePickerValueChanged(sender: UIDatePicker )
    {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.medium
        formatter.dateFormat = "HH:mm:ss"
        self.TextEventsTime.text = formatter.string(from: sender.date)
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem)
    {
        self.TextEventsTime.resignFirstResponder()
        view.endEditing(true)
        
    }
    
    @objc func canclePressed(sender: UIBarButtonItem)
    {
        self.TextEventsTime.resignFirstResponder()
        view.endEditing(true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectedDogs" {
            let view = segue.destination as! SelectedDogsViewController
            view.delegate = self
        }
    }
    
    func userDidEnterInformation(info: String) {
        self.TextEventsDogs.text = info
    }
    
    private func AddEvents() {
        let urlPath = "https://devth.me/dog/API/AddEvents.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        // Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
        dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
        let date = dateFormatter.date(from: TextEventsDate.text!) //according to date format your date string
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date!) //pass Date here
        // Convert Notification Formate
        let dformate = DateFormatter()
        dformate.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dformate.locale = Locale(identifier: "en_US")
        let s = dformate.date(from: "\((newDate)) \(TextEventsTime.text!)")
        // Create Notification List
        let CreateNotification = NotificationsItem(deadline: s!, title: TextEventsTitle.text!, UUID: UUID().uuidString)
        NotificationsList.sharedInstance.addItem(CreateNotification)
        // Request Response
        let postString = "Email=\((Email!))&HeaderTitle=\(TextEventsTitle.text!)&Date=\((newDate))&Time=\(TextEventsTime.text!)&DogName=\(TextEventsDogs.text!)&HospitalName=\(TextEventsHospitalName.text!)&Details=\(TextEventsDetails.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                
                    if Code == "200" {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AddEventsViewController.Success), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AddEventsViewController.UnSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }
    
    @objc private func Success() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:30" {
            self.timer.invalidate()
            self.TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            self.cntMS = 0
            self.cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "เพิ่มนัดหมายเสร็จสิ้น", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ดูปฏิทินนัดหมาย", style: .default, handler: {(action) -> Void in
                self.TextEventsTitle.text = ""
                self.TextEventsDate.text = ""
                self.TextEventsTime.text = ""
                self.TextEventsDogs.text = ""
                self.TextEventsHospitalName.text = ""
                self.TextEventsDetails.text = ""
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func UnSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            self.timer.invalidate()
            self.TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            self.cntMS = 0
            self.cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "ไม่สามารถทำรายการได้ในขณะนี้", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "แก้ไขข้อมูล", style: .default, handler: {(action) -> Void in
                self.TextEventsTitle.text = ""
                self.TextEventsDate.text = ""
                self.TextEventsTime.text = ""
                self.TextEventsDogs.text = ""
                self.TextEventsHospitalName.text = ""
                self.TextEventsDetails.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Show Dialog Waiting
    private func showLoading() {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(self.loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.loadingView.center
        
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = self.loadingView.center
        
        self.loadingView.addSubview(container)
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
    // Hide Dialog Waiting
    private func hideLoading() {
        UIView.animate(withDuration: 0.0, delay: 0.01, options: .curveEaseOut, animations: {
            self.container.alpha = 0.0
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }, completion: { finished in
            self.activityIndicator.removeFromSuperview()
            self.container.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let removeView  = win.viewWithTag(1)
            removeView?.removeFromSuperview()
        })
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

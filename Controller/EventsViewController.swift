//
//  EventsViewController.swift
//  Vdog
//
//  Created by tanut2539 on 9/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit
import FSCalendar

class EventsViewController: UITableViewController, FSCalendarDataSource, FSCalendarDelegate {

    // Loading
    var loadingView = UIView()
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var TimerString: String = ""
    var timer : Timer!
    var cntSec = 0
    var cntMS = 0
    // Data Source
    var Email: String! = ""
    var Event_Count: [String] = []
    var Event_Id: [String] = []
    var Event_HeaderTitle: [String] = []
    var Event_Date: [String] = []
    var Event_Time: [String] = []
    var Event_DogName: [String] = []
    var Event_HospitalName: [String] = []
    var Event_Details: [String] = []
    var Event_TimeStamp: [String] = []
    var DateSelected: String! = ""
    // Calendar
    let Date = NSDate()
    // UserPlist
    var plistPathUser: String!
    
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
    
    @IBOutlet weak var CalendatEvents: FSCalendar!
    @IBOutlet var NoEvents: UIView!
    
    @IBAction func AddEvents(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddEvents", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEvents") as! AddEventsViewController
        if DateSelected == "" {
            // Convert Date
            let Date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
            let dateString = Date
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let DateNow = dateFormatter.string(from: dateString as Date)
            vc.DateSeleted = DateNow
        } else {
            vc.DateSeleted = DateSelected
        }
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func DayToday(_ sender: Any) {
        
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    fileprivate var lunar: Bool = false {
        didSet {
            self.CalendatEvents.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.CalendatEvents.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: Locale.init(identifier: "th_TH"))
        self.CalendatEvents.appearance.titleFont = UIFont(name: "Itim-Regular", size: 14)!
        self.CalendatEvents.appearance.headerTitleFont = UIFont(name: "Itim-Regular", size: 14)!
        self.CalendatEvents.appearance.weekdayFont = UIFont(name: "Itim-Regular", size: 14)!
        self.CalendatEvents.appearance.subtitleFont = UIFont(name: "Itim-Regular", size: 14)!
        self.CalendatEvents.delegate = self
        // LoadUserPlist
        self.LoadUserPlist()
        // Refresh Data
        self.RefreshData()
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // MARK: TableViewDelegate
        self.tableView.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(RefreshData), for: UIControlEvents.valueChanged)
        
    }
    
    /*private func CreateNotificationWhenLoginAnotherDevice() {
        // Convert Notification Formate
        let dformate = DateFormatter()
        dformate.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dformate.locale = Locale(identifier: "en_US")
        let s = dformate.date(from: "\((EDate!)) \((ETime!))")
        // Create Notification List
        let CreateNotification = NotificationsItem(deadline: s!, title: ETitle! as String, UUID: UUID().uuidString)
        NotificationsList.sharedInstance.addItem(CreateNotification)
        print("Test = ",CreateNotification)
    }*/

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DateSelected = self.formatter.string(from: date)
        self.EventSelected(Date: DateSelected)
        self.RefreshEventSelected(Date: DateSelected)
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // LoadUserPlist
        self.LoadUserPlist()
        // Refresh Data
        self.RefreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // LoadUserPlist
        self.LoadUserPlist()
        // Refresh Data
        self.RefreshData()
    }
    
    private func EventToday() {
        let urlPath = "https://devth.me/dog/API/EventsList.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        // Convert Date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
        let dateString = Date
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let DateNow = dateFormatter.string(from: dateString as Date)
        // Request Response
        let postString = "Date=\((DateNow))&Email=\((Email!))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                    if(Code != "406"){
                        let Count = (dataDict as AnyObject).object(forKey: "Event_Count") as! NSString as String!
                        let Id = (dataDict as AnyObject).object(forKey: "Event_ID") as! NSString as String!
                        let Title = (dataDict as AnyObject).object(forKey: "Event_HeaderTitle") as! NSString as String!
                        let Date = (dataDict as AnyObject).object(forKey: "Event_Date") as! NSString as String!
                        let Time = (dataDict as AnyObject).object(forKey: "Event_Time") as! NSString as String!
                        let Dname = (dataDict as AnyObject).object(forKey: "Event_DogName") as! NSString as String!
                        let Hname = (dataDict as AnyObject).object(forKey: "Event_HospitalName") as! NSString as String!
                        let Details = (dataDict as AnyObject).object(forKey: "Event_Details") as! NSString as String!
                        let TimeStamp = (dataDict as AnyObject).object(forKey: "Event_TimeStamp") as! NSString as String!
                        // Append Value
                        Event_Count.append(Count!)
                        Event_Id.append(Id!)
                        Event_HeaderTitle.append(Title!)
                        Event_Date.append(Date!)
                        Event_Time.append(Time!)
                        Event_DogName.append(Dname!)
                        Event_HospitalName.append(Hname!)
                        Event_Details.append(Details!)
                        Event_TimeStamp.append(TimeStamp!)
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }
    
    private func EventSelected(Date: String!) {
        let urlPath = "https://devth.me/dog/API/EventsList.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        
        let postString = "Date=\(Date!)&Email=\((Email!))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                    if(Code != "406"){
                        let Count = (dataDict as AnyObject).object(forKey: "Event_Count") as! NSString as String!
                        let Id = (dataDict as AnyObject).object(forKey: "Event_ID") as! NSString as String!
                        let Title = (dataDict as AnyObject).object(forKey: "Event_HeaderTitle") as! NSString as String!
                        let Date = (dataDict as AnyObject).object(forKey: "Event_Date") as! NSString as String!
                        let Time = (dataDict as AnyObject).object(forKey: "Event_Time") as! NSString as String!
                        let Dname = (dataDict as AnyObject).object(forKey: "Event_DogName") as! NSString as String!
                        let Hname = (dataDict as AnyObject).object(forKey: "Event_HospitalName") as! NSString as String!
                        let Details = (dataDict as AnyObject).object(forKey: "Event_Details") as! NSString as String!
                        let TimeStamp = (dataDict as AnyObject).object(forKey: "Event_TimeStamp") as! NSString as String!
                        // Append Value
                        Event_Count.append(Count!)
                        Event_Id.append(Id!)
                        Event_HeaderTitle.append(Title!)
                        Event_Date.append(Date!)
                        Event_Time.append(Time!)
                        Event_DogName.append(Dname!)
                        Event_HospitalName.append(Hname!)
                        Event_Details.append(Details!)
                        Event_TimeStamp.append(TimeStamp!)
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (Event_Count.count) == 0 {
            self.tableView.backgroundView = NoEvents
            return Event_Count.count
        } else {
            self.tableView.backgroundView = nil
            return Event_Count.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsCell
        Cell.TitleEvent.text = self.Event_HeaderTitle[indexPath.row]
        // Convert Date to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
        dateFormatter.locale = Locale.init(identifier: "th_TH")//type Date location
        let date = dateFormatter.date(from: self.Event_Date[indexPath.row]) //according to date format your date string
        dateFormatter.dateFormat = "d MMM yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date!) //pass Date here
        
        
        Cell.DateEvent.text = "วันนัดหมาย: \((newDate))"
        Cell.DogEvent.text = "ชื่อสุนัข: \((self.Event_DogName[indexPath.row]))"
        Cell.HospitalEvent.text = self.Event_HospitalName[indexPath.row]
        Cell.DetailsEvent.text = self.Event_Details[indexPath.row]
        return Cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventsInfo") {
            let EventsInfo = segue.destination as! EventsInfoViewController
            EventsInfo.Event_HeaderTitle = Event_HeaderTitle[(self.tableView.indexPathForSelectedRow?.row)!]
            EventsInfo.Event_Date = Event_Date[(self.tableView.indexPathForSelectedRow?.row)!]
            EventsInfo.Event_Time = Event_Time[(self.tableView.indexPathForSelectedRow?.row)!]
            EventsInfo.Event_DogName = Event_DogName[(self.tableView.indexPathForSelectedRow?.row)!]
            EventsInfo.Event_HospitalName = Event_HospitalName[(self.tableView.indexPathForSelectedRow?.row)!]
            EventsInfo.Event_Details = Event_Details[(self.tableView.indexPathForSelectedRow?.row)!]
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
    
    // RefreshData
    
    @objc private func RefreshData() {
        // Clear Result
        self.Event_Count.removeAll()
        self.Event_Id.removeAll()
        self.Event_HeaderTitle.removeAll()
        self.Event_Date.removeAll()
        self.Event_DogName.removeAll()
        self.Event_HospitalName.removeAll()
        self.Event_Details.removeAll()
        self.Event_TimeStamp.removeAll()
        // API ReadData
        self.EventToday()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    @objc private func RefreshEventSelected(Date: String!) {
        // Clear Result
        self.Event_Count.removeAll()
        self.Event_Id.removeAll()
        self.Event_HeaderTitle.removeAll()
        self.Event_Date.removeAll()
        self.Event_DogName.removeAll()
        self.Event_HospitalName.removeAll()
        self.Event_Details.removeAll()
        self.Event_TimeStamp.removeAll()
        // API ReadData
        self.EventSelected(Date: Date)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

}

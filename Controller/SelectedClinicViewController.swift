//
//  SelectedClinicViewController.swift
//  Vdog
//
//  Created by tanut2539 on 14/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

protocol ClinicDelegate: class {
    func SelectedClinic(info: String)
}

class SelectedClinicViewController: UITableViewController {

    // Data Source
    var Email: String! = ""
    var Clinic_ID: [String] = []
    var Clinic_Count: [String] = []
    var Clinic_Name: [String] = []
    var Clinic_Address: [String] = []
    var Clinic_Phone: [String] = []
    // Delegate Pass Data
    weak var delegate: ClinicDelegate? = nil
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoadUserPlist()
        self.GetClinicList()
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Clinic_Count.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectedClinicCell
        Cell.ClinicName.text = Clinic_Name[indexPath.row]
        return Cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        delegate?.SelectedClinic(info: Clinic_Name[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    private func GetClinicList() {
        let urlPath = "https://devth.me/dog/API/GetClinicList.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        
        let postString = "Email=\((Email!))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                    if(Code != "406"){
                        let Count = (dataDict as AnyObject).object(forKey: "Clinic_Count") as! NSString as String!
                        let Id = (dataDict as AnyObject).object(forKey: "Clinic_ID") as! NSString as String!
                        let Name = (dataDict as AnyObject).object(forKey: "Clinic_Name") as! NSString as String!
                        let Address = (dataDict as AnyObject).object(forKey: "Clinic_Address") as! NSString as String!
                        let Phone = (dataDict as AnyObject).object(forKey: "Clinic_Phone") as! NSString as String!
                        // Append Value
                        Clinic_Count.append(Count!)
                        Clinic_ID.append(Id!)
                        Clinic_Name.append(Name!)
                        Clinic_Address.append(Address!)
                        Clinic_Phone.append(Phone!)
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }

}

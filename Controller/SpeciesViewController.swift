//
//  SpeciesViewController.swift
//  Vdog
//
//  Created by tanut2539 on 12/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

protocol SpeciesDelegate: class {
    func userDidEnterInformation(info: String)
}

class SpeciesViewController: UITableViewController {

    // Data Source
    var Species_Count: String! = ""
    var Species_ID: [String] = []
    var Species_Name: [String] = []
    var Species_Type: [String] = []
    // Delegate Pass Data
    weak var delegate: SpeciesDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetSpecisList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Species_Count.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpeciesCell
        Cell.SpeciesName.text = Species_Name[indexPath.row]
        return Cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        delegate?.userDidEnterInformation(info: Species_Name[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    private func GetSpecisList() {
        let urlPath = "https://devth.me/dog/API/SpeciesList.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                    if(Code != "406"){
                        let Count = (dataDict as AnyObject).object(forKey: "Species_Count") as! NSString as String!
                        let Id = (dataDict as AnyObject).object(forKey: "Species_ID") as! NSString as String!
                        let Name = (dataDict as AnyObject).object(forKey: "Species_Name") as! NSString as String!
                        let Type = (dataDict as AnyObject).object(forKey: "Species_Type") as! NSString as String!
                        // Append Value
                        Species_Count.append(Count!)
                        Species_ID.append(Id!)
                        Species_Name.append(Name!)
                        Species_Type.append(Type!)
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }

}

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

class SpeciesViewController: UITableViewController,UISearchBarDelegate {

    // Data Source
    var Species_Count: String! = ""
    var Species_ID: [String] = []
    var Species_Name: [String] = []
    var Species_Type: [String] = []
    var filteredData: [String]!
    // Delegate Pass Data
    weak var delegate: SpeciesDelegate? = nil
    
    @IBOutlet weak var AutoComplete: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetSpecisList()
        
        // Search DogType
        self.AutoComplete.delegate = self
        self.AutoComplete.backgroundImage = UIImage()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Itim-Regular", size: 17.0)
        filteredData = Species_Name
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
        // MARK: Hide Keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpeciesCell
        Cell.SpeciesName.text = filteredData[indexPath.row]
        return Cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        delegate?.userDidEnterInformation(info: filteredData[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? Species_Name : Species_Name.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        self.tableView.reloadData()
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
    
    // MARK: Hide Keyboard
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }

}

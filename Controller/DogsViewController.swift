//
//  DogsViewController.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class DogsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
    var Dog_Count: [String] = []
    var Dog_Id: [String] = []
    var Dog_Name: [String] = []
    var Dog_Blood: [String] = []
    var Dog_Gender: [String] = []
    var Dog_Type: [String] = []
    var Dog_BirthDay: [String] = []
    var Dog_Weight: [String] = []
    var Dog_Picture: [String] = []
    var Dog_TimeStamp: [String] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var url: NSURL!
    // UserPlist
    var plistPathUser: String!
    
    @IBOutlet var AlertMessage: UIView!
    
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
    
    @IBAction func Reload(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(DogsViewController.TimeReload), userInfo: nil, repeats: true)
        self.showLoading()
    }
    
    @IBAction func AddDogs(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddDogs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddDogs") as! AddDogsViewController
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    @objc private func TimeReload() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "00:50" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            // Refresh Data
            self.RefreshData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 12.5, bottom: 15, right: 12.5)
        layout.itemSize = CGSize(width: 140.0, height: 180.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10.0
        self.collectionView!.collectionViewLayout = layout

        // MARK: LoadPlist()
        self.LoadUserPlist()
        // ReadData
        self.RefreshData()
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: LoadPlist()
        self.LoadUserPlist()
        // ReadData
        self.RefreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // MARK: LoadPlist()
        self.LoadUserPlist()
        // ReadData
        self.RefreshData()
    }
    
    private func GetDogList() {
        let urlPath = "https://devth.me/dog/API/DogsList.php"
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
                        let Count = (dataDict as AnyObject).object(forKey: "Dog_Count") as! NSString as String!
                        let Id = (dataDict as AnyObject).object(forKey: "Dog_ID") as! NSString as String!
                        let Dname = (dataDict as AnyObject).object(forKey: "Dog_Name") as! NSString as String!
                        let Blood = (dataDict as AnyObject).object(forKey: "Dog_Blood") as! NSString as String!
                        let Gender = (dataDict as AnyObject).object(forKey: "Dog_Gender") as! NSString as String!
                        let Type = (dataDict as AnyObject).object(forKey: "Dog_Type") as! NSString as String!
                        let BirthDay = (dataDict as AnyObject).object(forKey: "Dog_BirthDay") as! NSString as String!
                        let Weight = (dataDict as AnyObject).object(forKey: "Dog_Weight") as! NSString as String!
                        let Picture = (dataDict as AnyObject).object(forKey: "Dog_Picture") as! NSString as String!
                        let TimeStamp = (dataDict as AnyObject).object(forKey: "Dog_TimeStamp") as! NSString as String!
                        // Append Value
                        Dog_Count.append(Count!)
                        Dog_Id.append(Id!)
                        Dog_Name.append(Dname!)
                        Dog_Blood.append(Blood!)
                        Dog_Gender.append(Gender!)
                        Dog_Type.append(Type!)
                        Dog_BirthDay.append(BirthDay!)
                        Dog_Weight.append(Weight!)
                        Dog_Picture.append(Picture!)
                        Dog_TimeStamp.append(TimeStamp!)
                    }
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if Dog_Count.count == 0 {
            self.collectionView?.backgroundView = self.AlertMessage
            return Dog_Count.count
        } else {
            self.collectionView?.backgroundView = nil
            return Dog_Count.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DogsCell
        Cell.DogName.text = self.Dog_Name[indexPath.row]
        if self.Dog_Picture[indexPath.row] == "" {
            Cell.Images.image = #imageLiteral(resourceName: "IconApp_1024.png")
        } else {
            url = URL(string: "\((self.Dog_Picture[indexPath.row]))")! as NSURL
            let data = NSData(contentsOf: url as URL)
            if data != nil {
                Cell.Images.image = UIImage(data: data! as Data)
            } else {
                Cell.Images.image = #imageLiteral(resourceName: "IconApp_1024.png")
            }
        }
        Cell.frame.size.width = screenWidth / 2
        Cell.frame.size.height = screenHeight / 2
        return Cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (screenHeight < 667) {
            return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        } else if (screenHeight < 736) {
            return UIEdgeInsets(top: 30, left: 35, bottom: 30, right: 35)
        } else {
            return UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (screenHeight < 667) {
            return CGSize(width: 140, height: 180)
        } else if (screenHeight < 736) {
            return CGSize(width: 140, height: 180)
        } else {
            return CGSize(width: 140, height: 180)
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
        self.Dog_Count.removeAll()
        self.Dog_Id.removeAll()
        self.Dog_Name.removeAll()
        self.Dog_Blood.removeAll()
        self.Dog_Gender.removeAll()
        self.Dog_Type.removeAll()
        self.Dog_BirthDay.removeAll()
        self.Dog_Weight.removeAll()
        self.Dog_Picture.removeAll()
        self.Dog_TimeStamp.removeAll()
        // ReadData
        self.GetDogList()
        self.collectionView?.reloadData()
    }


}

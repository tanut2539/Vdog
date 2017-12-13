//
//  SignInViewController.swift
//  Vdog
//
//  Created by tanut2539 on 9/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignInViewController: UIViewController {

    // Loading
    var loadingView = UIView()
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var TimerString: String = ""
    var timer : Timer!
    var cntSec = 0
    var cntMS = 0
    // Result
    var dict : [String : AnyObject]!
    var FBEmail: String! = ""
    var FBFname: String! = ""
    var FBLname: String! = ""
    var FBPicture: String! = ""
    
    @IBOutlet weak var TextInputEmail: UITextField!
    @IBOutlet weak var TextInputPassword: UITextField!
    @IBOutlet weak var FacebookLogin: UIButton!
    
    @IBAction func SignInAction(_ sender: Any) {
        if TextInputEmail.text == "" {
            // false
            let alert = UIAlertController(title: nil, message: "กรุณากรอกอีเมล", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "กรอกอีเมลใหม่", style: .default, handler: {(action) -> Void in
                self.TextInputEmail.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let providedEmailAddress = TextInputEmail.text
            let isEmailAddressValid = AppDelegate.isValidEmailAddress(emailAddressString: providedEmailAddress!)
            if isEmailAddressValid {
                if TextInputPassword.text == "" {
                    // false
                    let alert = UIAlertController(title: nil, message: "กรุณากรอกรหัสผ่าน", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "กรอกรหัสผ่าน", style: .default, handler: {(action) -> Void in
                        self.TextInputPassword.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // then
                    self.SignInWithEmail(email: TextInputEmail.text!, password: TextInputPassword.text!)
                }
            } else {
                let alert = UIAlertController(title: "รูปแบบอีเมลผิดพลาด\n"+"กรุณากรอกใหม่อีกครั้ง", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "กรอกอีเมลใหม่", style: .default, handler: {(action) -> Void in
                    self.TextInputEmail.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func GetFacebookLogin() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    @IBAction func SignInFacebook(_ sender: Any) {
        self.GetFacebookLogin()
    }
    
    private func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    self.FBEmail = self.dict["email"]! as! String
                    self.FBFname = self.dict["first_name"]! as! String
                    self.FBLname = self.dict["last_name"]! as! String
                    if let picture = self.dict["picture"] as? Dictionary<String,Any> {
                        if let data = picture["data"] as? Dictionary<String,Any> {
                            if let pictureUrl = data["url"] as? String {
                                self.FBPicture = pictureUrl
                            }
                        }
                    }
                    // API_Facebook Register
                    self.RegisteredFacebook(email: self.FBEmail,fname: self.FBFname,lname: self.FBLname,picture: self.FBPicture)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.TextInputEmail.attributedPlaceholder = NSAttributedString(string: "กรอกอีเมล",
                                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.TextInputPassword.attributedPlaceholder = NSAttributedString(string: "กรอกรหัสผ่าน",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        // MARK: setTextField()
        self.setTextField()
        // MARK: Hide Keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        // MARK: Remove Navigation Controller
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    private func SignInWithEmail(email: String, password: String) {
        let urlPath = "https://devth.me/dog/API/CheckLogin.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        
        let postString = "User_Email=\((TextInputEmail.text!))&User_Password=\((TextInputPassword.text!))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest,returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                     if Code == "100" {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.LoginWithEmailFacebook), userInfo: nil, repeats: true)
                        self.showLoading()
                     } else if Code == "200" {
                        var delegate = AppDelegate.sharedInstance
                        let pathForThePlistFile = AppDelegate.sharedInstance.plistPathInUser
                        do {
                            try self.TextInputEmail.text?.write(toFile: pathForThePlistFile, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print(error)
                        }
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.LoginWithEmailSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else if Code == "201" {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.LoginWithEmailUnSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else if Code == "202" {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.LoginWithPasswordUnSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else if Code == "406" {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.LoginWithEmailNotMatch), userInfo: nil, repeats: true)
                        self.showLoading()
                    }
                }
            }
        } catch {
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }
    
    @objc private func LoginWithEmailSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let mainStoryBoard = UIStoryboard(name: "Events", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "Controller")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    @objc private func LoginWithEmailFacebook() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "ขออภัยอีเมลนี้ได้เข้าสู่ระบบผ่าน Facebook", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "เข้าสู่ระบบผ่าน Facebook", style: .default, handler: {(action) -> Void in
                self.GetFacebookLogin()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func LoginWithEmailUnSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "อีเมลไม่ถูกต้อง\n"+"กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "กรอกอีเมลใหม่", style: .default, handler: {(action) -> Void in
                self.TextInputEmail.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func LoginWithPasswordUnSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "รหัสผ่านไม่ถูกต้อง\n"+"กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "กรอกรหัสผ่านใหม่", style: .default, handler: {(action) -> Void in
                self.TextInputPassword.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func LoginWithEmailNotMatch() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "เข้าสู่ระบบไม่สำเร็จ\n"+"กรุณาเลือกการดำเนินการต่อไปนี้", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "เข้าสู่ระบบใหม่อีกครั้ง", style: .default, handler: {(action) -> Void in
                self.TextInputEmail.text = ""
                self.TextInputPassword.text = ""
                self.TextInputEmail.becomeFirstResponder()
            }))
            alert.addAction(UIAlertAction(title: "สมัครสมาชิก", style: .default, handler: {(action) -> Void in
                
            }))
            alert.addAction(UIAlertAction(title: "ลืมรหัสผ่าน", style: .default, handler: {(action) -> Void in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func RegisteredFacebook(email: String,fname: String,lname: String, picture: String) {
        let urlPath = "https://devth.me/dog/API/RegisterFB.php"
        let jsonURL : URL = URL(string: urlPath)!
        let request = NSMutableURLRequest(url: jsonURL)
        request.httpMethod = "POST"
        
        let postString = "Facebook_Email=\((email))&Facebook_Fname=\((fname))&Facebook_Lname=\((lname))&Facebook_Picture=\((picture))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let response:AutoreleasingUnsafeMutablePointer<URLResponse?>?=nil
        
        do{
            let jsonSource:Data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonSource, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableArray{
                
                for dataDict : Any in jsonObjects  {
                    
                    let Code = (dataDict as AnyObject).object(forKey: "Code") as! NSString as String
                    
                    if Code == "200" {
                        var delegate = AppDelegate.sharedInstance
                        let pathForThePlistFile = AppDelegate.sharedInstance.plistPathInUser
                        do {
                            try email.write(toFile: pathForThePlistFile, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print(error)
                        }
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.FacebookSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else if Code == "201" {
                        var delegate = AppDelegate.sharedInstance
                        let pathForThePlistFile = AppDelegate.sharedInstance.plistPathInUser
                        do {
                            try email.write(toFile: pathForThePlistFile, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print(error)
                        }
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.FacebookUnSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    } else {
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SignInViewController.FacebookUnSuccess), userInfo: nil, repeats: true)
                        self.showLoading()
                    }
                    
                }
            }
        }catch{
            print("ขาดการเชื่อมต่อกรุณาต่ออินเทอร์เน็ต")
        }
    }
    
    @objc private func FacebookSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let mainStoryBoard = UIStoryboard(name: "Events", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "Controller")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    @objc private func FacebookUnSuccess() {
        if cntMS == 99 {
            cntMS = 0
            cntSec += 1
        }else{
            cntMS += 1
        }
        TimerString = String(format: "%02d:%02d", cntSec, cntMS)
        if TimerString == "01:00" {
            timer.invalidate()
            TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            cntMS = 0
            cntSec = 0
            self.hideLoading()
            let mainStoryBoard = UIStoryboard(name: "Events", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "Controller")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
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
        self.setTextFieldInterface(TextInputEmail)
        self.setTextFieldInterface(TextInputPassword)
    }
    
    private func setTextFieldInterface(_ TextField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1).cgColor // background color
        TextField.borderStyle = UITextBorderStyle.none // border style
        TextField.layer.addSublayer(bottomLine)
    }
    
    // MARK: Hide Keyboard
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }


}

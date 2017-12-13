//
//  SettingsViewController.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 1 {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let titleFont = [NSAttributedStringKey.font: UIFont(name: "Itim-Regular", size: 18.0)!]
            let messageFont = [NSAttributedStringKey.font: UIFont(name: "Itim-Regular", size: 18.0)!]
            let titleAttrString = NSMutableAttributedString(string: "คุณต้องการออกจากระบบ", attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: "ใช่หรือไม่ ?", attributes: messageFont)
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            alert.setValue(messageAttrString, forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "ใช่ ต้องการออกจากระบบ", style: .destructive, handler: {(action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SettingsViewController.LogoutSuccess), userInfo: nil, repeats: true)
                self.showLoading()
            }))
            alert.addAction(UIAlertAction(title: "ไม่ ต้องการอยู่ในระบบต่อ", style: .default, handler: {(action) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    @objc public func LogoutSuccess(){
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
            let delegate = AppDelegate.sharedInstance
            plistPathUser = delegate.plistPathInUser
            do {
                if FileManager.default.fileExists(atPath: plistPathUser) {
                    try FileManager.default.removeItem(atPath: plistPathUser)
                }
            } catch {
                print(error)
            }
            self.hideLoading()
            let mainStoryBoard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInView")
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
    
}

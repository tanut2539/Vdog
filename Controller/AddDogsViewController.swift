//
//  AddDogsViewController.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class AddDogsViewController: UITableViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SpeciesDelegate,UITextFieldDelegate {
    
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
    // Blood
    var bloodlist = ["DEA1.1","DEA1.2","DEA3","DEA4","DEA5","DEA6","DEA7","DEA8"]
    var newPic: Bool?
    
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
    
    @IBOutlet weak var DogImages: UIImageView!
    @IBOutlet weak var TextInputName: UITextField!
    @IBOutlet weak var TextInputDate: UITextField!
    @IBOutlet weak var TextInputGender: UITextField!
    @IBOutlet weak var TextInputType: UITextField!
    @IBOutlet weak var TextInputWeight: UITextField!
    @IBOutlet weak var TextInputBlood: UITextField!
    
    @IBAction func SelectedPhotos(_ sender: Any) {
        let PickerController = UIImagePickerController()
        PickerController.delegate = self
        PickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(PickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        
        DogImages.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 2){
            return bloodlist.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 2){
            return bloodlist[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 2){
            self.TextInputBlood.text = bloodlist[row]
        }
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "บันทึกรูปภาพไม่สำเร็จ", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func AddDogs(_ sender: Any) {
        if TextInputName.text == "" {
            // false
            let alert = UIAlertController(title: nil, message: "กรุณากรอกชื่อสุนัข", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "แก้ไขชื่อสุนัข", style: .default, handler: {(action) -> Void in
                self.TextInputName.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if TextInputDate.text == "" {
                // false
                let alert = UIAlertController(title: nil, message: "กรุณาระบุวันเกิดสุนัข", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "แก้ไขวันเกิดสุนัข", style: .default, handler: {(action) -> Void in
                    self.TextInputDate.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                if TextInputGender.text == "" {
                    // false
                    let alert = UIAlertController(title: nil, message: "กรุณาเลือกเพศสุนัข", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "เลือกเพศสุนัข", style: .default, handler: {(action) -> Void in
                        self.TextInputGender.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if TextInputType.text == "" {
                        // false
                        let alert = UIAlertController(title: nil, message: "กรุณาเลือกสายพันธุ์สุนัข", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "เลือกสายพันธุ์สุนัข", style: .default, handler: {(action) -> Void in
                            self.TextInputType.becomeFirstResponder()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if TextInputWeight.text == "" {
                            // false
                            let alert = UIAlertController(title: nil, message: "กรุณาระบุน้ำหนักสุนัข", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "แก้ไขน้ำหนักสุนัข", style: .default, handler: {(action) -> Void in
                                self.TextInputWeight.becomeFirstResponder()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if TextInputBlood.text == "" {
                                // false
                                let alert = UIAlertController(title: nil, message: "กรุณาระบุกรุ๊ปเลือดสุนัข", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "เลือกกรุ๊ปเลือดสุนัข", style: .default, handler: {(action) -> Void in
                                    self.TextInputBlood.becomeFirstResponder()
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                // then
                                self.AddDogs()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Selected Blood Dogs
        self.TextInputBlood.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height:34 ))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1)
        let canecelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(AddEventsViewController.canclePressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventsViewController.donePressed(sender:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont(name: "Itim-Regular", size: 20)!,
                NSAttributedStringKey.foregroundColor : UIColor.darkGray,
                ], for: .normal)
        
        toolbar.setItems([canecelButton,flexButton, doneButton], animated: true)
        
        let blood = UIPickerView()
        blood.delegate = self
        blood.tag = 2
        self.TextInputBlood.inputView = blood
        self.TextInputBlood.inputAccessoryView = toolbar
        self.LoadUserPlist()
        // MARK: setTextField()
        self.setTextField()
        // MARK: Hide Keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        // MARK: Remove Back Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.DogImages.clipsToBounds = true
        self.DogImages.layer.cornerRadius = 60.0
    }
    
    @objc func donePressed(sender: UIBarButtonItem)
    {
        self.TextInputBlood.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func canclePressed(sender: UIBarButtonItem)
    {
        self.TextInputBlood.resignFirstResponder()
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
        if segue.identifier == "SelectedSpecies" {
            let view = segue.destination as! SpeciesViewController
            view.delegate = self
        }
    }
    
    func userDidEnterInformation(info: String) {
        self.TextInputType.text = info
    }
    
    private func AddDogs() {
        
        let image = self.DogImages.image!
        let imgData = UIImageJPEGRepresentation(image, 1)!
        
        let parameters = ["name": "Project Vdog",
                          "Email": "\((Email!))",
                          "Dog_Name": "\((TextInputName.text!))",
                          "Dog_BirthDay": "\((TextInputDate.text!))",
                          "Dog_Gender": "\((TextInputGender.text!))",
                          "Dog_Type": "\((TextInputType.text!))",
                          "Dog_Weight": "\((TextInputWeight.text!))",
                          "Dog_Blood": "\((TextInputBlood.text!))"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "userfile",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://devth.me/dog/API/AddDogs.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                        if let status = response.response?.statusCode {
                            switch(status){
                            case 200:
                                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AddDogsViewController.Success), userInfo: nil, repeats: true)
                                self.showLoading()
                            default:
                                let alert = UIAlertController(title: nil, message: "ไม่สามารถทำรายการได้ในขณะนี้", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "แก้ไขข้อมูล", style: .default, handler: {(action) -> Void in
                                    self.TextInputName.text = ""
                                    self.TextInputDate.text = ""
                                    self.TextInputGender.text = ""
                                    self.TextInputType.text = ""
                                    self.TextInputWeight.text = ""
                                    self.TextInputBlood.text = ""
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
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
        if TimerString == "00:50" {
            self.timer.invalidate()
            self.TimerString = String(format: "%02d:%02d", cntSec, cntMS)
            self.cntMS = 0
            self.cntSec = 0
            self.hideLoading()
            let alert = UIAlertController(title: nil, message: "เพิ่มสุนัขสำเร็จ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ดูสุนัขของฉัน", style: .default, handler: {(action) -> Void in
                self.TextInputName.text = ""
                self.TextInputDate.text = ""
                self.TextInputGender.text = ""
                self.TextInputType.text = ""
                self.TextInputWeight.text = ""
                self.TextInputBlood.text = ""
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
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
        self.setTextFieldInterface(TextInputName)
        self.setTextFieldInterface(TextInputDate)
        self.setTextFieldInterface(TextInputType)
        self.setTextFieldInterface(TextInputGender)
        self.setTextFieldInterface(TextInputWeight)
        self.setTextFieldInterface(TextInputBlood)
    }
    
    private func setTextFieldInterface(_ TextField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: TextField.frame.height - 1, width: TextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1).cgColor // background color
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

//
//  AppDelegate.swift
//  Vdog
//
//  Created by tanut2539 on 9/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var UserEmail: String = ""
    var plistPathUser: String!
    var plistPathInUser: String = String()
    static let sharedInstance: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // LoadUserFirst
        self.preparePlistUser()
        let delegate = AppDelegate.sharedInstance
        plistPathUser = delegate.plistPathInUser
        do {
            let loadUserEmail = try String(contentsOfFile: plistPathUser)
            UserEmail = loadUserEmail
        } catch {
            print(error)
        }
        if UserEmail != "" {
            let mainStoryBoard = UIStoryboard(name: "Events", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Controller")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        } else {
            let mainStoryBoard = UIStoryboard(name: "SignIn", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInView")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        }
        // Register Notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        // Start Application
        /*let mainStoryBoard = UIStoryboard(name: "SignIn", bundle: nil)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInView") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController*/
        // Set Back Icon NavigationController
        let backArrowImage = #imageLiteral(resourceName: "arrow-left")
        let renderedImage = backArrowImage.withRenderingMode(.automatic)
        UINavigationBar.appearance().backIndicatorImage = renderedImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = renderedImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        // Set Font NavigationController
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Itim-Regular", size: 18)!,NSAttributedStringKey.foregroundColor : UIColor.white]
        // Set NavigationController Color
        UINavigationBar.appearance().tintColor = UIColor.white
        // Set NavigationController Border Color
        UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(color: UIColor(red:140.0/255.0, green:171.0/255.0, blue:165.0/255.0, alpha:1))
        // Set NavigationController Background Color
        UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(color: UIColor(red:140.0/255.0, green:171.0/255.0, blue:165.0/255.0, alpha:1)), for: .default)
        // Set StatusBarStyle
        UIApplication.shared.statusBarStyle = .lightContent
        //let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //statusBar.backgroundColor = UIColor(red:18.0/255.0, green:61.0/255.0, blue:109.0/255.0, alpha:1)
        
        // Facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func preparePlistUser(){
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        plistPathInUser = rootPath + "/Email.plist"
        if !FileManager.default.fileExists(atPath: plistPathInUser) {
            let plistPathInBundle = Bundle.main.path(forResource: "Email", ofType: "plist") as String!
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInUser)
            }catch{
                print(error)
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.preparePlistUser()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Vdog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Func isValidEmailAddress
    
    static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

}


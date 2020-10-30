//
//  AppDelegate.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-11.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "V6EJIEOncrKSxZXQTrOW5B0u66qCNYQNro9GuLKm"
            $0.clientKey = "pdp2lWHpca4mAbxc0FwPpTYQXEDr0PFLPNKgKDM3"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        
        
        
        
        
        notificationCenter.delegate = self
        
        
        //APP-ID
        return true
    }
    
    
    func requestNotificationAuthorization() {
        // Code here
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options, completionHandler: {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications :(")
            }
        })
        
        notificationCenter.getNotificationSettings(completionHandler: {
            (settings) in
            if settings.authorizationStatus != .authorized {
                print("No loco.")
            }
        })
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    /*func createInstallationsOnParse(deviceTokenData: Data) {
        if let installation = PFInstallation.current() {
            installation.setDeviceTokenFrom(deviceTokenData)
            installation.setObject(["News"], forKey: "channels")
            installation.saveInBackground{
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully saved your push installation to Back4App!")
                    
                }
                else {
                    if let myError = error {
                        print("Error saving parse installation \(myError.localizedDescription)")
                        
                    }
                    else {
                        print("Unknown error with parse installation")
                    }
                }
            }
        }
    }*/

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

        
        /*let rootViewController = window?.rootViewController
        let tabBarController = rootViewController?.storyboard?.instantiateViewController(identifier: "VaccinationTabBarController") as! VaccinationTabBarController
        
        tabBarController.save()*/
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        /*let rootViewController = window?.rootViewController
        let tabBarController = rootViewController?.storyboard?.instantiateViewController(identifier: "VaccinationTabBarController") as! VaccinationTabBarController
        
        tabBarController.save()*/

    }
    
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        /*let rootViewController = window?.rootViewController
        let tabBarController: VaccinationTabBarController
        if #available(iOS 13.0, *) {
            tabBarController = rootViewController?.storyboard?.instantiateViewController(identifier: "VaccinationTabBarController") as! VaccinationTabBarController
        } else {
            // Fallback on earlier versions
            tabBarController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "VaccinationTabBarController") as! VaccinationTabBarController
        }
         let defaults = UserDefaults.standard
        tabBarController.loadFrom(defaults: defaults)*/
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        /*let rootViewController = window?.rootViewController
        let tabBarController = rootViewController?.storyboard?.instantiateViewController(identifier: "VaccinationTabBarController") as! VaccinationTabBarController
        
        tabBarController.save()*/
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
                       //tabBarController.modalPresentationStyle = .fullScreen
                   window?.rootViewController = tabBarController//(tabBarController, animated: true, completion: nil)
        }
        
        
           
            
        
    }
    
    //Private methods:
    func scheduleNotifications(notificationType: String, identifier: String) {
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = "Bra att du kommer igång Emil"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: identifier, content: content
            , trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
 
    
    
    
    
    
    
    
    
    
    //RayWenderlich
    /* func registerForPushNotifications() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
             [weak self] granted, error in
             print("Permission granted: \(granted)")
             guard granted else { return}
             self?.getNotificationSettings()
         }
     }
     func getNotificationSettings() {
         UNUserNotificationCenter.current().getNotificationSettings { settings in
             print("Notification settings: \(settings)")
             guard settings.authorizationStatus == .authorized else {return}
             DispatchQueue.main.async {
                 UIApplication.shared.registerForRemoteNotifications()
             }
         }
     }
     
    /* func startPushNotifications() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) {
             (granted, error) in
             print("Permission granted: \(granted)")
             guard granted else {return}
             self.getNotificationSettings()
         }
     }
     
     
     func getNotificationSettings() {
         UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
             print("Notification settings: \(settings)")
             guard settings.authorizationStatus == .authorized else {return}
             UIApplication.shared.registerForRemoteNotifications()
             
         })
     }*/*/


}


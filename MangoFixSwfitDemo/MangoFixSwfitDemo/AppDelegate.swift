//
//  AppDelegate.swift
//  MangoFixSwfitDemo
//
//  Created by Tianyu Xia on 2022/3/8.
//

import UIKit
//import MangoFix

let aes128Key = "123456"
let aes128Iv = "abcdef"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func encryptPlainScirptToDocument() -> Bool {
        let scriptURL = Bundle.main.url(forResource: "demo.mg", withExtension: nil)
        let script =  try? String.init(contentsOf: scriptURL!)
        guard script != nil else {
            return false
        }
        let scriptData = script!.data(using: String.Encoding.utf8)
        guard scriptData != nil else {
            return false
        }
        let nsscriptData = NSData.init(data: scriptData!)
        let enecryptedData = nsscriptData.aes128ParmEncrypt(withKey: aes128Key, iv: aes128Iv)
        guard enecryptedData != nil else {
            return false
        }
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let encryptedScriptPath = docPath!.appending("/demo_encrypted.mg")
        let encryptedScriptURL = URL.init(fileURLWithPath: encryptedScriptPath)
        try! enecryptedData?.write(to: encryptedScriptURL)
        return true
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let writeResult = encryptPlainScirptToDocument();
        if !writeResult {
            return true
        }
        
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let encryptedScriptPath = docPath!.appending("/demo_encrypted.mg")
        let encryptedScriptURL = URL.init(fileURLWithPath: encryptedScriptPath)
        let context = MFContext.init(aes128Key: aes128Key, iv: aes128Iv)


        context.evalMangoScript(with: encryptedScriptURL)

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


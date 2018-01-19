//
//  File.swift
//  APICallingAlamofireDemo
//
//  Created by Ragini pasaru on 17/01/18.
//

import Foundation
import DGActivityIndicatorView
import AVFoundation
import SystemConfiguration
import SDWebImage

class CommonInstance {
    typealias CompletionBlock = (_ error: NSError?, _ response : AnyObject?) -> Void
    
    var hudCounter: Int = 0
    var window : UIWindow?
    //var hud : MBProgressHUD!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class var sharedInstance: CommonInstance {
        let instance = CommonInstance()
        return instance
    }
    
    // Activity Indicator using HUD
    func showHUD(show : Bool){
        if (window == nil) {
            window = UIApplication.shared.windows.last
        }
        
        if (show == false){
            hudCounter -= 1;
            if (hudCounter <= 0){
                hudCounter = 0
                DispatchQueue.main.async(execute: {
                   // MBProgressHUD.hide(for: self.window!, animated: true)
                    //SVConstants.showHUD()
                })
            }
        }else{
            hudCounter += 1;
            DispatchQueue.main.async(execute: {
                //SVConstants.showHUD()
               // self.hud = MBProgressHUD.showAdded(to: self.window!, animated: true)
                let activityIndicatorView : DGActivityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballClipRotate, tintColor: UIColor.lightGray, size: 50)
                activityIndicatorView.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)  //CGRectMake(0.0, 0.0, 50.0, 50.0)
//                self.hud.customView = activityIndicatorView
//                activityIndicatorView.startAnimating()
//                self.hud.mode = MBProgressHUDMode.customView
//                self.hud.dimBackground = true
//                self.hud.color = UIColor.clear
            })
        }
        print("Hud Counter : \(hudCounter) HuD Flag : \(show)")
    }
    
    // Check internet connectivity
    func hasConnectivity() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    // Alert With Title
    func presentAlertWithTitle(title: String, message : String, btnTitle : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: btnTitle, style: .default) {
            (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // Get UIImage from URL
    func getUIImageFromUrl(_ url : String) -> UIImage {
        let url = URL(string: url)
        //    var data = Data()
        if url != nil {
            let data = try! Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            return UIImage(data: data)!
        }
        return UIImage()
    }

    // Set Color using hex
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0xFF)/255.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}



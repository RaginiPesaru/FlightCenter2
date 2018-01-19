//
//  CommonFunctions.swift
//
//  Created by Ragini pasaru on 17/01/18.
//

import Foundation
import UIKit

func showAlert(_ title : String?, message : String?, btnTitle : String)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: btnTitle, style: .default) { action in
        // perhaps use action.title here
    })
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}

func uicolorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

//MARK: ProgressHUD
func ShowMBProgressHUD(_ navigationController : UINavigationController, lableTitle : String?)
{
    //let spinnerActivity = MBProgressHUD.showAdded(to: navigationController.view, animated: true)
    //spinnerActivity.isUserInteractionEnabled = false
}

func hideMBProgressHUD(_ navigationController : UINavigationController) {
    //MBProgressHUD.hide(for: navigationController.view, animated: true)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


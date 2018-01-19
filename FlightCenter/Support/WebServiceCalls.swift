
//
//  WebServiceCalls.swift
//
//  Created by Ragini pasaru on 17/01/18.
//

import UIKit
import CoreData
import Alamofire
import SVProgressHUD

// server path

let kBasePath = "https://glacial-caverns-15124.herokuapp.com/flights/all"

let rootControll = UIApplication.shared.keyWindow?.rootViewController

typealias CompletionBlock = (_ json : NSDictionary?, _ successed : Bool?, _ errorCode : Int?) -> ()
typealias CartCountCompletionBlock = (_ count : String?, _ successed : Bool?, _ errorCode : Int?) -> ()

class WebServiceCalls: NSObject {
    
    typealias CompletionBlock = (_ error: NSError?, _ response : AnyObject?) -> Void
    static var completionBlock: CompletionBlock?
    static var isLoaded: Bool = false
    
    // MARK: Master
    
    static func callWebservice(apiPath : String, method : HTTPMethod, header : [String : String], params : [String : Any], options : NSDictionary?, onSuccess : CompletionBlock? = nil) {
        
        let API_URL = "\(kBasePath)\(apiPath)"
        let webservice = String(format: "%@",API_URL)
        
        if CommonInstance.sharedInstance.hasConnectivity() == true {
            if options != nil {
//                if let showHud = (options?.value(forKey: "showProgres") as AnyObject).boolValue {
//                    if showHud == true {
//                        CommonInstance.sharedInstance.showHUD(show: true)
//                    }
//                }
                SVConstants.showHUD()
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                NSLog("path : \(webservice)")
                NSLog("Parameter : \(jsonString)")
                NSLog("API Call Started")
            } catch let error as NSError {
                print(error)
            }
            
            Alamofire.request(webservice, method: method, parameters: params, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let resultValue):
                    CommonInstance.sharedInstance.showHUD(show: false)
                    SVConstants.hideHUD()
                    onSuccess!(nil,resultValue as AnyObject?)
                case .failure(let error):
                    SVConstants.hideHUD()

                    CommonInstance.sharedInstance.showHUD(show: false)
                    print("Error - \(error.localizedDescription)")
                    onSuccess!(error as NSError?,nil)
                    break
                }
            }
        }
        else {
            CommonInstance.sharedInstance.presentAlertWithTitle(title: "Alert", message: "No internet connection.", btnTitle: "Ok")
            print("Unable to create Reachability")
            return
        }
    }
    
    static func displayIndicator()
    {
        if !isLoaded
        {
            CommonInstance.sharedInstance.showHUD(show: true)
        }
    }
}

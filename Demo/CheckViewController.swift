
//
//  CheckViewController.swift
//  Demo
//
//  Created by Tb on 2018/4/8.
//  Copyright © 2018年 Tb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CheckViewController: UIViewController {

    public var authToken: String = ""
    public let adress = "广东省深圳市南山区郎山二路5号"
    public let lon = 113.9510909715426
    public let lat = 22.56399040860167
    public let checkUrl = "https://apps.epipe.cn/member/v3/check/sign"
    
    
    init(authToken: String) {
        super.init(nibName: nil, bundle: nil)
        self.authToken = authToken
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    func getDeviceID() -> String?{
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        return deviceUUID
    }
    func UA() -> String {
        let kWidth = UIScreen.main.bounds.size.width
        let kHeight = UIScreen.main.bounds.size.height
        let machineModelName = UIDevice.current.machineModelName
        let phoneVersion   = UIDevice.current.systemVersion;
        return "\(kWidth)" +  "\(kHeight)" + machineModelName! + phoneVersion
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var params: [String : String] = [:]
        params["address"] = adress
        params["lon"] =  "\(self.lon)"
        params["lat"] =  "\(self.lat)"
        
         let requestHeader : HTTPHeaders = ["auth_token" : self.authToken, "_client" : "ios","imei" : getDeviceID()! , "ua": UA()];

        
        Alamofire.request(checkUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: requestHeader).responseJSON { (response) in
            if response.error == nil {
                let json = JSON(response.result.value!)
                print(json)
                
                if let jsonStr = json["h"]["code"].int {
                    if jsonStr == 200 {
                        SVProgressHUD.showSuccess(withStatus: "打卡成功！")
                        SVProgressHUD.dismiss(withDelay: 0.7, completion: {
                            self.navigationController?.popViewController(animated: true)

                        })
                    } else {
                        let checkErrorMsg = "打卡失败" + json["h"]["msg"].string!
                      SVProgressHUD.showError(withStatus:checkErrorMsg)
                        print(checkErrorMsg)
                    }
                }
            } else {
                SVProgressHUD .showError(withStatus: "失败！" + String(describing: response.error))
                print("错误:" + String(describing: response.error))
            }
        }
    }
}

/*
 {
 b =     {
 authToken = "f8112e85-4ceb-45d0-add5-0450677ff4f4";
 companyId = 29d13eec6bb746c2a0c35326e940c1ab;
 imPassword = 8CCE6157EABF065BD14DD0F5B114776F3ACF4BA2;
 imUserName = 27ff07bf1849495a9192bb8919414018;
 userId = 27ff07bf1849495a9192bb8919414018;
 };
 h =     {
 code = 200;
 msg = "\U64cd\U4f5c\U6210\U529f";
 tid = "aec3e6fa-5987-41f8-9237-72b7f916e02e";
 };
 }
 */

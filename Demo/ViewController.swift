//
//  ViewController.swift
//  Demo
//
//  Created by Tb on 2018/4/8.
//  Copyright © 2018年 Tb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FCUUID


protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
}

class ViewController: UIViewController {
    
    let loginURl = "https://apps.epipe.cn/member/v3/user/login/password"
    let APPVERSION = "3.4.1"
    
    var autoToken : String = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let defaults = UserDefaults.standard
//        let iphone = defaults.string(forKey: "userIphone")
//        let pwd = defaults.string(forKey: "userPwd")
        
        
        let iphone = UserDefaults.AccountInfo.string(forKey: .userMobile)
        if let userMobile = iphone {
            self.nameTextField.text = userMobile
        }
        let pwd = UserDefaults.AccountInfo.string(forKey: .userPwd)

        if let userPwd = pwd {
            self.pwdTextField.text = userPwd
        }
    }
    @IBAction func login(_ sender: Any) {
        var dict : [String : String] = [:]
        dict["account"] = self.nameTextField.text
        dict["password"] = self.pwdTextField.text
        
        let uuidString = FCUUID.uuidForDevice()!
        print("uuidString: \(uuidString)")
        
        let requestHeader : HTTPHeaders = ["auth_token" : "", "_client" : "ios","imei" : uuidString , "ua": UA()];
        
        Alamofire.request(loginURl, method: .post, parameters: dict, encoding: URLEncoding.default, headers: requestHeader).responseJSON { (response) in
            if response.error == nil {
                 print(response.result.value as! NSDictionary)
                
                let resultDict = response.result.value as? NSDictionary
                
                let final = resultDict?["h"] as? [String : Any]
                print((final?["code"])!)
                
                
                if let resultFin = final?["code"] as? Int  {
                    print(resultFin)
                    if  resultFin == 200 {
                        
                        // 保存账号与密码
                        UserDefaults.AccountInfo.set(value: self.nameTextField.text, forKey: .userMobile)
                        UserDefaults.AccountInfo.set(value: self.pwdTextField.text, forKey: .userPwd)
                        
//                        let defaults = UserDefaults.standard
//                        defaults.set(self.nameTextField.text, forKey: "userIphone")
//                        defaults.set(self.pwdTextField.text, forKey: "userPwd")
//                        defaults.synchronize()
                       
                        let dict111 = (resultDict!["b"]) as! NSDictionary
                        let token = dict111["authToken"]
                        print("Token:\(token!)")
                        
                        let check = CheckViewController(authToken: token as! String)
                    
                         SVProgressHUD.showSuccess(withStatus: "登录成功！")
                         SVProgressHUD.setDefaultStyle(.dark)
                         SVProgressHUD.dismiss(withDelay: 0.7, completion: {
                             self.navigationController?.pushViewController(check, animated: true)
                        })
                        
                    } else if(resultFin == 60) {//新设备登录，请进行安全验证!
                        // 保存账号与密码
                        UserDefaults.AccountInfo.set(value: self.nameTextField.text, forKey: .userMobile)
                        UserDefaults.AccountInfo.set(value: self.pwdTextField.text, forKey: .userPwd)
                        
                        let check = CheckLogViewController()
                        self.navigationController!.pushViewController(check, animated: true)
                        
                    } else {
                        if let errorMsg = final?["msg"] as? String  {
                            SVProgressHUD .showError(withStatus: "登录失败！" + errorMsg)
                            print("错误:" + errorMsg)
                        }
                    }
                } else {
                    print("resultFin 为nil")
                }

                
            } else {
                print("登录失败\(String(describing: response.error))")
            }
        }
    }
}

extension ViewController {
    
//    func getDeviceID() -> String?{
//        let deviceUUID = FCUUID.uuidForDevice
//        return deviceUUID
//    }
//    + (NSString *)getDeviceID {
//    // NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *deviceUUID = [FCUUID uuidForDevice];
//    NSLog(@"----------deviceUUID:%@",deviceUUID);
//    return deviceUUID;
//    }
    func UA() -> String {
        let kWidth = UIScreen.main.bounds.size.width
        let kHeight = UIScreen.main.bounds.size.height
        let machineModelName = UIDevice.current.machineModelName
        let phoneVersion   = UIDevice.current.systemVersion;
        //        return "v" + "=" + APPVERSION + "w" + "=" + "\(kWidth)" + "h" + "=" +  "\(kHeight)" + "m" + "=" + machineModelName! + "os" + "=" + "IOS" + phoneVersion
        return "v=\(APPVERSION)w=\(kWidth)h=\(kHeight)m=\(machineModelName!)os=IOS\(phoneVersion)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension UserDefaults {
    // 账户信息
    struct AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case userMobile
            case userPwd
        }
    }
    
//    static func set(value: String, forKey key: AccountInfo) {
//        let key = key.rawValue
//        UserDefaults.standard.set(value, forKey: key)
//    }
//
//    static func string(forKey key: AccountInfo) -> String? {
//        let key = key.rawValue
//        return UserDefaults.standard.string(forKey: key)
//    }
}



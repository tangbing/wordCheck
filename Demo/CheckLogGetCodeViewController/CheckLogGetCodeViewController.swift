//
//  CheckLogGetCodeViewController.swift
//  Demo
//
//  Created by Tb on 2018/8/23.
//  Copyright © 2018年 Tb. All rights reserved.
//

import UIKit
import Alamofire
import FCUUID
import SVProgressHUD

class CheckLogGetCodeViewController: UIViewController {

    var userPhone : String? = nil
    let url : String = "https://apps.epipe.cn/member/v3/sms/getcode"
    let vaildLogUrl : String = "https://apps.epipe.cn/member/v3/user/check/shortmsg"
//    let APPVERSION = "3.4.1"

    let codeTextField : UITextField = UITextField()
    
    lazy var sureBtn : UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.backgroundColor = UIColor.colorWithHexString("#CCCCCC")
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.layer.masksToBounds = true
        sureBtn.layer.cornerRadius = 4
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitleColor(UIColor.colorWithHexString("#FFFFFF"), for: .normal)
        sureBtn.backgroundColor = UIColor.colorWithHexString("#FFB963")
        sureBtn.addTarget(self, action: #selector(sure), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var codeBtn : UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.backgroundColor = UIColor.colorWithHexString("#CCCCCC")
        codeBtn.setTitle("发送验证码", for: .normal)
        codeBtn.layer.masksToBounds = true
        codeBtn.layer.cornerRadius = 4
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        codeBtn.setTitleColor(UIColor.colorWithHexString("#FFFFFF"), for: .normal)
        codeBtn.backgroundColor = UIColor.colorWithHexString("#FFB963")
        codeBtn.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        return codeBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号验证安全"
        
        self.view.backgroundColor = UIColor.white;
        
        // 发送验证码
        self.codeTextField.borderStyle = .roundedRect
        self.view.addSubview(self.codeTextField);
        
        self.codeTextField.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.view.snp.top).offset(100)
        }
        
        self.view.addSubview(self.codeBtn)
        self.codeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.codeTextField.snp.bottom).offset(150)
        }
        
        self.view.addSubview(self.sureBtn)
        self.sureBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension CheckLogGetCodeViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - 验证登录
    @objc func sure() {
        let iphone = UserDefaults.AccountInfo.string(forKey: .userMobile)
        if let userMobile = iphone {
            self.userPhone = userMobile
        }
        var param : [String : String] = Dictionary()
        param["mobile"] = self.userPhone
        param["code"] = self.codeTextField.text!
        
        let uuidString = FCUUID.uuidForDevice()!
        print("uuidString: \(uuidString)")
        
        let requestHeader : HTTPHeaders = ["auth_token" : "", "_client" : "ios","imei" : uuidString , "ua": "123".UA()];
        
        Alamofire.request(vaildLogUrl, method: .post, parameters: param, encoding: URLEncoding.default, headers: requestHeader).responseJSON { (response) in
            print("sure response:\(response)")

            if response.error == nil {
                print(response.result.value as! NSDictionary)
                
                let resultDict = response.result.value as? NSDictionary
                
                let final = resultDict?["h"] as? [String : Any]
                print((final?["code"])!)
                
                if let resultFin = final?["code"] as? Int  {
                    print(resultFin)
                    if  resultFin == 200 {
                        let dict111 = (resultDict!["b"]) as! NSDictionary
                        let token = dict111["authToken"]
                        print("Token:\(token!)")
                        SVProgressHUD.showSuccess(withStatus: "验证登录成功")
                        let checkVc = CheckViewController(authToken: token as! String)
                        self.navigationController?.pushViewController(checkVc, animated: true)
                    }
                }else {
                    if let errorMsg = final?["msg"] as? String  {
                        SVProgressHUD .showError(withStatus: "验证登录失败！" + errorMsg)
                        print("错误:" + errorMsg)
                    }
                }
            }
            
        }
    }
    
    // MARK: - 发送验证码
    @objc func getCode() {
        let iphone = UserDefaults.AccountInfo.string(forKey: .userMobile)
        if let userMobile = iphone {
            self.userPhone = userMobile
        }
        var param : [String : String] = Dictionary()
        param["mobile"] = self.userPhone
        param["type"] = "7"
        
        let uuidString = FCUUID.uuidForDevice()!
        print("uuidString: \(uuidString)")
        
        let requestHeader : HTTPHeaders = ["auth_token" : "", "_client" : "ios","imei" : uuidString , "ua": "123".UA()];
        
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: requestHeader).responseJSON { (response) in
            
            print("getcode response:\(response)")
            
            if response.error == nil {
                print(response.result.value as! NSDictionary)
                
                let resultDict = response.result.value as? NSDictionary
                
                let final = resultDict?["h"] as? [String : Any]
                print((final?["code"])!)
                
                if let resultFin = final?["code"] as? Int  {
                    print(resultFin)
                    if  resultFin == 200 {
                        SVProgressHUD.showSuccess(withStatus: "发送验证码成功")
                    }
                }else {
                    if let errorMsg = final?["msg"] as? String  {
                        SVProgressHUD .showError(withStatus: "发送验证码失败！" + errorMsg)
                        print("错误:" + errorMsg)
                    }
                }
            }
            
        }
        
    }
}

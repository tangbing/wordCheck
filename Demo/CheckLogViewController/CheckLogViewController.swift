
//
//  CheckLogViewController.swift
//  Demo
//
//  Created by Tb on 2018/8/23.
//  Copyright © 2018年 Tb. All rights reserved.
//

import UIKit
import SnapKit

class CheckLogViewController: UIViewController {

    lazy var checkButton : UIButton = {
        let checkButton = UIButton(type: .custom)
        checkButton.layer.masksToBounds = true
        checkButton.layer.cornerRadius = 4
        checkButton.setTitle("开始验证", for: .normal)
        checkButton.backgroundColor = UIColor.colorWithHexString("#0fc37c")
        checkButton.setTitleColor(UIColor.colorWithHexString("#FFFFFF"), for: .normal)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        checkButton.addTarget(self, action: #selector(check), for: .touchUpInside)
        return checkButton
    }()
    
    lazy var checkStateImageView : UIImageView = {
       let img = UIImage(named: "verify_log")
       let checkStateImageView = UIImageView.init(image: img)
        return checkStateImageView
    }()
    lazy var checkMsgLabel : UILabel = {
        let checkMsgLabel = UILabel()
        checkMsgLabel.text = "你正在一台新设备登录优管App，为了你的账号安全，请进行安全登录"
        checkMsgLabel.textColor = UIColor.colorWithHexString("#999999")
        checkMsgLabel.font = UIFont.systemFont(ofSize: 14)
        checkMsgLabel.numberOfLines = 0
        checkMsgLabel.textAlignment = .center
        return checkMsgLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号安全验证"
        self.view.backgroundColor = UIColor.white
        setupUI()
        setupConstraints()
    }

    
    // MARK: - 初始化UI
    func setupUI() {
        self.view.addSubview(checkStateImageView)
         self.view.addSubview(checkMsgLabel)
        self.view.addSubview(checkButton)
    }
    
    func setupConstraints() {
        self.checkStateImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.top.equalTo(self.view.snp.top).offset(45 + 64)
            make.centerX.equalToSuperview()
        }
        
        self.checkMsgLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkStateImageView.snp.bottom).offset(45)
            make.left.equalToSuperview().offset(70);
            make.right.equalToSuperview().offset(-70);
        }
        
        self.checkButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.top.equalTo(self.checkMsgLabel.snp.bottom).offset(30)
        }
    }
    @objc func check() {
        print("click check!")
        let getCode = CheckLogGetCodeViewController()
        self.navigationController?.pushViewController(getCode, animated: true)
        
    }
    
}

extension CheckViewController {
   
}

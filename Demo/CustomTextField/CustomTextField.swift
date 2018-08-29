
//
//  CustomTextField.swift
//  Demo
//
//  Created by Tb on 2018/8/23.
//  Copyright © 2018年 Tb. All rights reserved.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    var placeHolderText : String?
    
    let blankView = UIView()
    let textField = UITextField()
    
    init(frame: CGRect, placeHolderText: String?) {
        super.init(frame: frame)
        if let resultPlaceText = placeHolderText{
            self.placeholder = resultPlaceText
        }
        setupUI()
    }
    lazy var line : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.colorWithHexString("#CCCCCC")
        return line
    }()
    
    lazy var codeBtn : UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.backgroundColor = UIColor.colorWithHexString("#CCCCCC")
        codeBtn.isHidden = true
        codeBtn.layer.masksToBounds = true
        codeBtn.layer.cornerRadius = 4
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        codeBtn.setTitleColor(UIColor.colorWithHexString("#FFFFFF"), for: .normal)
        codeBtn.backgroundColor = UIColor.colorWithHexString("#FFB963")
        return codeBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        blankView.backgroundColor = UIColor.colorWithHexString("#FFFFFF")
        blankView.frame = self.bounds
        self.addSubview(blankView)
        blankView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        let typeLabel = UILabel()
        typeLabel.backgroundColor = UIColor.colorWithHexString("#FFFFFF")
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.colorWithHexString("#666666")
        typeLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.bottom.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
       
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
           make.left.equalTo(typeLabel.snp.right)
           make.top.equalTo(10)
           make.height.equalTo(typeLabel.snp.height).offset(-20)
           make.width.equalTo(0.5)
        }
        self.textField.clearsOnBeginEditing = false
        self.textField.backgroundColor = UIColor.colorWithHexString("#FFFFFF")
        self.addSubview(self.textField)
        
        self.addSubview(self.codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make
        }
        
        
        
        
    }
    
}

//
//  BaseCell.swift
//  Innovision
//
//  Created by Ray on 2017/5/1.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import UIKit
import SnapKit

class BaseCell: UITableViewCell {
    
    var iconView: UIImageView!
    
    var descriptionView: UIView!
    
    var eventView: UIView?
    
    let screenSize = UIScreen.main.bounds
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.clear
        
        initView()
    }
    
    func initView() {
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = UIColor.white
        self.contentView.addSubview(iconView!)
        
        
        descriptionView = UIView()
        descriptionView.backgroundColor = UIColor.white
        self.contentView.addSubview(descriptionView)
        
        iconView.snp.makeConstraints{ (make) in
            make.width.equalTo(80)
            make.height.equalTo(70)
            make.left.equalTo(self.contentView).offset(6)
            make.centerY.equalTo(descriptionView)
            make.top.greaterThanOrEqualTo(self.contentView.snp.top).offset(2)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-2)
        }
        
        descriptionView.snp.makeConstraints{ (make) in
            make.left.equalTo(iconView!.snp.right).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
            make.top.equalTo(self.contentView).offset(2)
            make.bottom.equalTo(self.contentView).offset(-2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

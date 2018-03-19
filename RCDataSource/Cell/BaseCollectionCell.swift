//
//  BaseCollectionCell.swift
//  Innovision
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}

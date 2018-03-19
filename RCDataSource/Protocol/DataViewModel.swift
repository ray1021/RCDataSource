//
//  DataViewModel.swift
//  Innovision
//
//  Created by Ray on 2017/5/1.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import Foundation

protocol DataViewModel: class {
    
    associatedtype ViewModel
    
    func updateWithViewModel(_ viewModel: ViewModel)
}

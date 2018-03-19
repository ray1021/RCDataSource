//
//  CellConfigurator.swift
//  Innovision
//
//  Created by Ray on 2017/5/1.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

//
//  CellConfigurator.swift
//  LuckyCoinIOS
//
//  Created by newegg on 2016/5/10.
//  Copyright © 2016年 Ray. All rights reserved.
//

import Foundation


//MARK: TableView
protocol CellConfiguratorType {
    
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }

    func updateCell(_ cell: BaseCell)
    
    func cellViewModel() -> Any
}

struct CellConfigurator<Cell> where Cell: DataViewModel, Cell: BaseCell {
    
    let viewModel: Cell.ViewModel
    let reuseIdentifier: String = NSStringFromClass(Cell.self)
    let cellClass: AnyClass = Cell.self
    
    func updateCell(_ cell: BaseCell) {
        if let cell = cell as? Cell {
            cell.updateWithViewModel(viewModel)
        }
    }
    
    func cellViewModel() -> Any {
        return viewModel
    }
}

extension CellConfigurator: CellConfiguratorType {
    
}


struct TagCellConfigurator<Cell> where Cell: DataViewModel, Cell: BaseCell {
    
    let viewModel: Cell.ViewModel
    let reuseIdentifier: String = NSStringFromClass(Cell.self)
    let cellClass: AnyClass = Cell.self
    var tag:String!
    
    func updateCell(_ cell: BaseCell) {
        if let cell = cell as? Cell {
            cell.accessibilityLabel = tag
            cell.updateWithViewModel(viewModel)
        }
    }
    
    func cellViewModel() -> Any {
        return viewModel
    }
}

extension TagCellConfigurator: CellConfiguratorType {
    
}


//MARK: CollectionView
protocol CollectionConfiguratorType {
    
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }
    
    func updateCell(_ cell: BaseCollectionCell)
    
    func cellViewModel() -> Any
}

struct CollectionConfigurator<Cell> where Cell: DataViewModel, Cell: BaseCollectionCell {
    
    let viewModel: Cell.ViewModel
    let reuseIdentifier: String = NSStringFromClass(Cell.self)
    let cellClass: AnyClass = Cell.self
    
    func updateCell(_ cell: BaseCollectionCell) {
        if let cell = cell as? Cell {
            cell.updateWithViewModel(viewModel)
        }
    }
    
    func cellViewModel() -> Any {
        return viewModel
    }
}

extension CollectionConfigurator: CollectionConfiguratorType {
    
}




//
//  RCCollectionDataSource.swift
//  Innovision
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import UIKit

class RCCollectionDataSource: NSObject,UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    var sections: [[CollectionConfiguratorType]] = []
    var items: [CollectionConfiguratorType] = []
    
    typealias configureCellBlock = (BaseCollectionCell , Any , IndexPath) -> Void
    var configureCell :configureCellBlock?
    
    var collectionDidSelected :configureCellBlock?
    
    typealias configureMoveCellBlock = (UICollectionView ,IndexPath ,IndexPath) -> Void
    var configureMoveCell :configureMoveCellBlock?
    
    
    typealias configureHeadBlock = (UICollectionView ,String , IndexPath) -> UICollectionReusableView
    var configureHeadView :configureHeadBlock?
    
    func configureHeadView(_ block:configureHeadBlock?) {
        self.configureHeadView = block
    }
    
    
    func configureCell(_ block:@escaping configureCellBlock) {
        self.configureCell = block
    }
    
    func configureDidMoveCell(_ block:@escaping configureMoveCellBlock) {
        self.configureMoveCell = block
    }
    
    func configureDidSelectdCell(_ block:@escaping configureCellBlock) {
        self.collectionDidSelected = block
    }
    
    //MARK: 設定資料
    func configureItems(_ items:Array<CollectionConfiguratorType>){
        self.items = items
    }
    
    func configureSections(_ sections:Array<Array<CollectionConfiguratorType>>){
        self.sections = sections
    }
    
    
    //MARK:註冊 Cell
    func registerCells(_ collectionView : UICollectionView , indexPath: IndexPath) {
        if self.sections.count > 0 {
            let cellConfigurator = sections[indexPath.section][indexPath.row]
            collectionView.register(cellConfigurator.cellClass,
                                    forCellWithReuseIdentifier: cellConfigurator.reuseIdentifier)
        }else{
            let cellConfigurator = items[indexPath.row]
            collectionView.register(cellConfigurator.cellClass,
                                    forCellWithReuseIdentifier: cellConfigurator.reuseIdentifier)
        }
    }
    
    
    
    // MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if sections.count > 0{
            return  sections.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections.count > 0{
            return sections[section].count
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        var cellConfigurator:CollectionConfiguratorType! = nil
        if self.sections.count > 0 {
            cellConfigurator = sections[indexPath.section][index]
        }else{
            cellConfigurator = items[index]
        }
        
        registerCells(collectionView, indexPath: indexPath)
        
        let cell:BaseCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellConfigurator.reuseIdentifier, for: indexPath) as! BaseCollectionCell
        
        cellConfigurator.updateCell(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            if let headView = self.configureHeadView {
                return headView(collectionView, kind , indexPath)
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.sections.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = indexPath.row
        var cellConfigurator:CollectionConfiguratorType! = nil
        if self.sections.count > 0 {
            cellConfigurator = sections[indexPath.section][index]
        }else{
            cellConfigurator = items[index]
        }
        
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! BaseCollectionCell
        if let collectionDidSelected = self.collectionDidSelected {
            collectionDidSelected(cell ,cellConfigurator.cellViewModel() , indexPath)
        }
    }
    
    //MARK: 排序
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if self.sections.count > 0 {
            let moveItem = sections[sourceIndexPath.section][sourceIndexPath.row]
            let moveToItem = sections[sourceIndexPath.section][destinationIndexPath.row]
            sections[sourceIndexPath.section][destinationIndexPath.row] = moveItem
            sections[sourceIndexPath.section][sourceIndexPath.row] = moveToItem
            
            if let configureMoveCell = self.configureMoveCell {
                configureMoveCell(collectionView ,sourceIndexPath ,destinationIndexPath)
            }
            
        }else{
            let moveItem = items[sourceIndexPath.row]
            let moveToItem = items[destinationIndexPath.row]
            items[destinationIndexPath.row] = moveItem
            items[sourceIndexPath.row] = moveToItem
            
            if let configureMoveCell = self.configureMoveCell {
                configureMoveCell(collectionView ,sourceIndexPath ,destinationIndexPath)
            }
        }
    }
}

//
//  RCDataSource.swift
//  Innovision
//
//  Created by Ray on 2017/5/1.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import UIKit

class RCDataSource : NSObject , UITableViewDataSource , UITableViewDelegate , UIScrollViewDelegate {
    
    var items: [CellConfiguratorType] = []
    
    var isEdit:Bool = false
    var isMove:Bool = false
    
    var sectionTitles: [String] = []
    var sections: [Array<CellConfiguratorType>] = []
    
    var editIndexPaths = [NSIndexPath]()
    
    var headView:UIView?
    
    typealias configureCellBlock = (BaseCell , Any , IndexPath) -> Void
    var configureCell :configureCellBlock?
    
    typealias displayCellBlock = (BaseCell , Any , IndexPath) -> Void
    var displayCell :displayCellBlock?
    
    typealias configureCellEditBlock = (Any ,UITableViewCellEditingStyle , IndexPath) -> Void
    var configureEditCell :configureCellEditBlock?
    
    typealias TableViewDidSelectedBlock = (Any) -> Void
    var tableViewDidSelected :TableViewDidSelectedBlock?
    
    typealias TableViewDidSelectedClosure = (BaseCell , Any , IndexPath) -> Void
    var tableViewDidSelectedClosure :TableViewDidSelectedClosure?
    
    typealias scrollViewDidScrollBlock = (_ scrollView: UIScrollView) -> Void
    var scrollBlock :scrollViewDidScrollBlock?
    
    typealias ScrollToTopBlock = (_ scrollView: UIScrollView) -> Void
    var scrollToTopBlock :ScrollToTopBlock?
    
    typealias configureHeightBlock = (UITableView , IndexPath) -> CGFloat
    var configureHeight :configureHeightBlock?
    
    typealias configureCanEditCellBlock = (UITableView , IndexPath) -> Bool
    var configureCanEditCell :configureCanEditCellBlock?
    

    
    override init() {
        super.init()
    }
    
    func configureRowHeight(_ block:@escaping configureHeightBlock) {
        self.configureHeight = block
    }
    
    func configureSectionTitles(_ sectionTitles:Array<String>) {
        self.sectionTitles = sectionTitles
    }
    
    func configureSections(_ sections:Array<Array<CellConfiguratorType>>) {
        self.sections = sections
    }
    
    func configureItems(_ items:Array<CellConfiguratorType> ){
        self.items = items
    }
    
    
    func configureHeadView(_ view:UIView)  {
        self.headView = view;
    }
    
    func registerCells(_ tableView : UITableView , cellConfigurator:CellConfiguratorType) {
        tableView.register(cellConfigurator.cellClass, forCellReuseIdentifier: cellConfigurator.reuseIdentifier)
    }
    
    func configureDisplayCell(_ block:@escaping displayCellBlock) {
        self.displayCell = block
    }
    
    func configureCell(_ block:@escaping configureCellBlock) {
        self.configureCell = block
    }
    
    func configureEditCell(_ block:@escaping configureCellEditBlock) {
        self.configureEditCell = block
    }
    
    func configureCanEditCell(_ block:@escaping configureCanEditCellBlock) {
        self.configureCanEditCell = block
    }
    
    
    func configureTableViewDidSelected(_ block :@escaping TableViewDidSelectedBlock ){
        self.tableViewDidSelected = block
    }
    
    func configureTableViewDidSelectedClosure(_ closure :@escaping TableViewDidSelectedClosure ){
        self.tableViewDidSelectedClosure = closure
    }
    
    func scrollBlock(_ block:@escaping scrollViewDidScrollBlock) {
        self.scrollBlock = block
    }
    
    func scrollToTopBlock(_ block:@escaping scrollViewDidScrollBlock) {
        self.scrollToTopBlock = block
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollBlock = self.scrollBlock {
            scrollBlock(scrollView)
        }
    }
    
    private func scrollViewScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let scrollToTopBlock = self.scrollToTopBlock {
            scrollToTopBlock(scrollView)
        }
        return true
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if sections.count > 0 {
            return sections[section].count
        }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if sections.count > 0 {
            return sections.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionTitles.count > 0 {
            return sectionTitles[section]
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        
        let cellConfigurator:CellConfiguratorType!
        if sections.count > 0 {
            cellConfigurator = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }else{
            cellConfigurator = items[(indexPath as NSIndexPath).row]
        }
        
        
        if let displayCell = self.displayCell {
            displayCell(cell as! BaseCell , cellConfigurator.cellViewModel() , indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellConfigurator:CellConfiguratorType!
        if sections.count > 0 {
            cellConfigurator = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }else{
            cellConfigurator = items[(indexPath as NSIndexPath).row]
        }
        
        //註冊
        self.registerCells(tableView, cellConfigurator: cellConfigurator)
        
        var cell:BaseCell? = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.reuseIdentifier) as? BaseCell
        
        if cell == nil {
            cell = BaseCell(style: .default , reuseIdentifier: cellConfigurator.reuseIdentifier)
        }
        cellConfigurator.updateCell(cell!)
        
        if let configureCell = self.configureCell {
            configureCell(cell! , cellConfigurator.cellViewModel() , indexPath)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellConfigurator:CellConfiguratorType!
        if sections.count > 0 {
            cellConfigurator = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }else{
            cellConfigurator = items[(indexPath as NSIndexPath).row]
        }
        
        print("didSelectRowAtIndexPath : \(cellConfigurator.cellViewModel())")
        
        if let tableViewDidSelected = self.tableViewDidSelected {
            tableViewDidSelected(cellConfigurator.cellViewModel())
        }
        
        
        if let tableViewDidSelectedClosure = self.tableViewDidSelectedClosure {
            let cell = tableView.cellForRow(at: indexPath) as! BaseCell
            tableViewDidSelectedClosure(cell , cellConfigurator.cellViewModel() , indexPath)
        }
    }
    
    //MAEK: 刪除 Delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if let configureCanEditCell = self.configureCanEditCell {
           return configureCanEditCell(tableView , indexPath)
        }
        
        return isEdit
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .default, title: "delete") { action, index in
//            print("more button tapped")
//        }
//        return [delete]
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let cellConfigurator:CellConfiguratorType!
        if sections.count > 0 {
            cellConfigurator = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }else{
            cellConfigurator = items[(indexPath as NSIndexPath).row]
        }
        
        if let editCell = self.configureEditCell {
            editCell(cellConfigurator.cellViewModel() , editingStyle , indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let configureHeight = self.configureHeight {
            return configureHeight(tableView , indexPath)
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isMove
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sections.count > 0 {
            var sectionItems = sections[sourceIndexPath.section]
            let toMove = sectionItems[sourceIndexPath.row]
            sectionItems.remove(at: sourceIndexPath.row)
            sectionItems.insert(toMove, at: destinationIndexPath.row)
        }else{
            let toMove = items[sourceIndexPath.row]
            items.remove(at: sourceIndexPath.row)
            items.insert(toMove, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isEdit {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

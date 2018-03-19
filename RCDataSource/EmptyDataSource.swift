//
//  EmptyDataSource.swift
//  Innovision
//
//  Created by Ray on 2017/5/1.
//  Copyright © 2017年 rcdesign. All rights reserved.
//

import DZNEmptyDataSet

class EmptyDataSource: NSObject ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private let pinkColor = "f29b87"
    
    var title:String! = ""
    var image:UIImage! = UIImage.init(named: "empty-state")
    
    var buttonTitle:String! = ""
    
    private var currentTableView:UITableView!
    private var currentCollectionView:UICollectionView!
    
    typealias EmptyButtonClickedClosure = () -> Void
    var emptyButtonClicked :EmptyButtonClickedClosure?
    
    func configureTableView(_ tableView:UITableView , title:String , image:UIImage ) {
        self.title = title
        self.image = image
        
        self.currentTableView = tableView
        self.currentTableView.emptyDataSetSource = self
        self.currentTableView.emptyDataSetDelegate = self
        self.currentTableView.tableFooterView = UIView()
    }
    
    func configureTableView(_ tableView:UITableView , title:String ,buttonTitle:String) {
        self.title = title
        self.buttonTitle = buttonTitle
        
        self.currentTableView = tableView
        self.currentTableView.emptyDataSetSource = self
        self.currentTableView.emptyDataSetDelegate = self
        
        self.currentTableView.tableFooterView = UIView()
        self.currentTableView.reloadEmptyDataSet()
    }
    
    func configureCollectionView(_ collectionView:UICollectionView , title:String ,buttonTitle:String) {
        self.title = title
        self.buttonTitle = buttonTitle
        
        self.currentCollectionView = collectionView
        self.currentCollectionView.emptyDataSetSource = self
        self.currentCollectionView.emptyDataSetDelegate = self

        self.currentCollectionView.reloadEmptyDataSet()
    }
    
    func reloadEmptyDataSet()  {
        self.currentTableView.reloadEmptyDataSet()
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        scrollView.contentMode = .scaleAspectFit
        return self.image
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font : fontAvenirNextBold(18),
                          NSAttributedStringKey.foregroundColor: UIColor(hexString: pinkColor)!
        ]
        if self.buttonTitle  == "" {
            return nil
        }
        return NSAttributedString.init(string: self.buttonTitle, attributes: attributes)
    }
    
    func configureEmptyButtonClicked(_ closure:@escaping EmptyButtonClickedClosure) {
        self.emptyButtonClicked = closure
    }
    
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        if let emptyButtonClicked = self.emptyButtonClicked {
            emptyButtonClicked()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes =  [NSAttributedStringKey.font: fontAvenirNextBold(18),
                           NSAttributedStringKey.foregroundColor:UIColor.lightGray
        ]
        return NSAttributedString.init(string: title, attributes:attributes)
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    private func fontAvenirNext(_ size:Float) -> UIFont {
        let font = UIFont(name: "AvenirNext", size: CGFloat(size))
        if font == nil {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        return font!
    }
    
    private func fontAvenirNextBold(_ size:Float) -> UIFont {
        let font = UIFont(name: "AvenirNext-DemiBold", size: CGFloat(size))
        if font == nil {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        return font!
    }
    
}

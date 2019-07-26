//
//  BidListContainerViewController.swift
//  Flivery User
//
//  Created by eww090 on 28/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class BidListContainerViewController: BaseViewController {

    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollObject: UIScrollView!
    @IBOutlet weak var viewLineHeight: UIView!
    
    @IBOutlet weak var btnMyBid: UIButton!

    @IBOutlet weak var btnOpenBid: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Bid List"
        self.setNavBarWithBackWithAdd(Title: "Bid List")
//        self.setNavBarWithMenuORBack(Title: "Bid List".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)

        btnMyBid.setTitle("My Bid".localized, for: .normal)
        btnOpenBid.setTitle("Open Bid".localized, for: .normal)
        
    }

    @objc func addTapped()
    {
        
    }

    @IBAction func btnMyBid(_ sender: Any) {

        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        constraintLeading.constant = 0
    }

    @IBAction func btnOpenBid(_ sender: Any) {

        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
        constraintLeading.constant = viewLineHeight.frame.width
    }
   
}
extension BidListContainerViewController : RefreshData{
    func dataRefresh() {
        if let bidListVC = self.childViewControllers[1] as? OpenBidListViewController{
            bidListVC.webserviceCallToGetOpenBidList()
        }
        if let myBid = self.childViewControllers[0] as? MyBidListViewController {
            myBid.refreshData(myBid.refreshControl)
            
        }
    }
    
    
}

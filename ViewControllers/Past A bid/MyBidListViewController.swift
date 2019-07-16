//
//  MyBidListViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MyBidListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK: ===== Outlets ======
    @IBOutlet weak var tblView: UITableView!
    
      //MARK: ===== Variables ======
    private let refreshControl = UIRefreshControl()
    var arrNumberOfOnlineCars : [[String:AnyObject]]!
    var aryData = [[String:AnyObject]]()
    let dateFormatter = DateFormatter()
    let date = Date()

     //MARK: ===== View Controller Life Cycle ======
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblView.refreshControl = refreshControl
        arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        webserviceCallToGetBidList()
       self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
    }
   
      //MARK: ===== Refresh Data ======
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallToGetBidList()
    }

    //MARK: ===== API Call Get Bids ======
    func webserviceCallToGetBidList()
    {
    
        webserviceForGetCustomerBid("" as AnyObject) { (result, status) in
        
                if (status) {
                    print(result)
                    
                    self.aryData = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
                    
                    SingletonClass.sharedInstance.customerBids = self.aryData
                    
                    self.tblView.reloadData()
                    
                    self.refreshControl.endRefreshing()
                }
                else {
                    print(result)
                    UtilityClass.defaultMsg(result:result)
                  //  UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }

        }
    }
   
     //MARK: ===== Tableview Datasource and Delegate Methods ======
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aryData.count > 0 ?  aryData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if aryData.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataFoundTableViewCell") as! NoDataFoundTableViewCell
            cell.lblNoDataFound.text = "No Data Found !"
            return cell
        } else {
            
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "MyBidListViewCell") as! MyBidListViewCell
        
        customCell.selectionStyle = .none
        customCell.btnViewDetails.tag = indexPath.row
        customCell.btnViewDetails.addTarget(self, action:#selector(viewDetailsBtnAction(_:)), for: .touchUpInside)
        
        if let distance = aryData[indexPath.row]["Distance"] as? String{
            customCell.lblDistance.text = distance
        }
        if let PickupLocation = aryData[indexPath.row]["PickupLocation"] as? String{
            customCell.lblPickupLocation.text = PickupLocation
        }
        if let price = aryData[indexPath.row]["Budget"] as? String{
            customCell.lblPrice.text = price
        }
        if let deadHead = aryData[indexPath.row]["DeadHead"] as? String{
            customCell.lblDeadhead.text = deadHead
        }
         if let pickup = aryData[indexPath.row]["PickupDateTime"] as? String{
            let pickupDate : [String] = pickup.components(separatedBy: " ")
            var date : String = pickupDate[0]
            let datestring = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd MMMM")
            customCell.lblPickupDate.text = datestring
        }
            if let modelId = aryData[indexPath.row]["ModelId"] as? String{
                for i in arrNumberOfOnlineCars{
                    if i["Id"] as! String == modelId{
                        let imgUrl = i["Image"] as! String
                        customCell.iconVehicle.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
                        customCell.lblVehicleName.text = i["Name"] as? String
                        break
                    }
                }
            }
        if let droplocation = aryData[indexPath.row]["DropoffLocation"] as? String{
            customCell.lblDropofLocation.text = droplocation
        }
            if let bids = aryData[indexPath.row]["DriverBids"] as? String{
                customCell.lblBidCount.text = "Bids - " + bids
            }
            
        return customCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if aryData.count == 0 {
            return self.tblView.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: ===== View Details Button Action ======
    @objc func viewDetailsBtnAction(_ sender:UIButton) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailsViewController") as! BidDetailsViewController
        detailVC.aryData = [aryData[sender.tag]]
        detailVC.isFromOpenBid = false
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

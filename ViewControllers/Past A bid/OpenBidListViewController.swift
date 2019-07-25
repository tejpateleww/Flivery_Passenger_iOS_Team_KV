//
//  OpenBidListViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class OpenBidListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   //MARK:- ===== Outlets ======
    @IBOutlet weak var tblView: UITableView!
    
    
    //MARK:- ===== Variables ======
    private let refreshControl = UIRefreshControl()
    var aryData = [[String:AnyObject]]()
    let dateFormatter = DateFormatter(format: "yyyy/MM/dd")
    let date = Date()
    var arrNumberOfOnlineCars : [[String:AnyObject]]!
   
     //MARK:- ===== View Controller LifeCycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        webserviceCallToGetOpenBidList()
        self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
    
         arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]
        // Do any additional setup after loading the view.
    }
    
    //MARK:- ===== Data Refresh ======
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallToGetOpenBidList()
    }

    //MARK:- ===== API Call Customer OpenBids  ======
        func webserviceCallToGetOpenBidList()
        {
            webserviceForGetCustomerOpenBid("" as AnyObject) { (result, status) in
           
                if (status) {
                    print(result)
                    
                    self.aryData = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
                    
                    SingletonClass.sharedInstance.CustomerOpenBids = self.aryData
                    
                    self.tblView.reloadData()

                    self.refreshControl.endRefreshing()
                }
                else {
                    print(result)
                    UtilityClass.defaultMsg(result: result)
                   // UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
                }
            }
    }
    
    //MARK:- ===== API Call Customer Bid Cancel ======
    func webserviceCallToCancelBid(bidID : String)
    {
        webserviceForGetCustomerPostBidCancel(bidID as AnyObject) { (result, status) in
            if (status) {
                print(result)
                
                let message = (result as! NSDictionary).object(forKey: "message") as! String
               // self.navigationController?.popViewController(animated: true)
                //UtilityClass.showAlert("", message: message, vc: self)
                self.webserviceCallToGetOpenBidList()
            }
            else {
                print(result)
                UtilityClass.defaultMsg(result: result)
                // UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }
        }
    }
    
    //MARK:- ===== TableView Datasource And Delegate Methods ======
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
        customCell.btnDelete.tag = indexPath.row
        customCell.btnViewDetails.addTarget(self, action:#selector(viewDetailsBtnAction(_:)), for: .touchUpInside)
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(_:)), for:.touchUpInside)
        if let distance = aryData[indexPath.row]["Distance"] as? String{
            customCell.lblDistance.text = distance
        }
        if let PickupLocation = aryData[indexPath.row]["PickupLocation"] as? String{
            customCell.lblPickupLocation.text = PickupLocation
        }
        if let price = aryData[indexPath.row]["Budget"] as? String{
            customCell.lblPrice.text = "USD " + price
        }
        if let deadHead = aryData[indexPath.row]["DeadHead"] as? String{
            customCell.lblDeadhead.text = deadHead
        }
            customCell.lblBidId.text = "Bid Id - " + String(describing: aryData[indexPath.row]["BidId"]!)

        if let pickup = aryData[indexPath.row]["PickupDateTime"] as? String{
            let pickupDate : [String] = pickup.components(separatedBy: " ")
            var date : String = pickupDate[0]
            let datestring = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd MMMM")
            customCell.lblPickupDate.text =  datestring
        }
        if let droplocation = aryData[indexPath.row]["DropoffLocation"] as? String{
            customCell.lblDropofLocation.text = droplocation
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
        if let bids = aryData[indexPath.row]["DriverBids"] as? String{
            customCell.lblBidCount.text = "Bids - " + bids
        }else if let bids = aryData[indexPath.row]["DriverBids"] as? String{
            customCell.lblBidCount.text = "Bids - " + String(bids)
        }
          
       return customCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return aryData.count != 0 ?  UITableViewAutomaticDimension : self.tblView.frame.height
    }

    
    //MARK:- ===== View Details Button Action ======
    @objc func viewDetailsBtnAction(_ sender:UIButton) {
      let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailsViewController") as! BidDetailsViewController
        detailVC.aryData = [aryData[sender.tag]]
        detailVC.isFromOpenBid = true
      self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    //MARK:- ===== Delete Button Action ======
    @objc func btnDeleteAction(_ sender:UIButton){
        let alertController = UIAlertController(title: appName, message: "Are you sure want to delete this bid?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let bidID = self.aryData[sender.tag]["Id"] as? String{
                print(bidID)
                if bidID != "0"{
                    self.webserviceCallToCancelBid(bidID: bidID)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        }
}
//"data": [
//{
//"Id": "54",
//"PassengerId": "2",
//"ModelId": "1",
//"PickupLocation": "Excellent Web world, Science city, Ahmedabad",
//"DropoffLocation": "Thaltej Ahmedabad",
//"PickupLat": "23.0726365",
//"PickupLng": "72.51423",
//"DropOffLat": "23.0584756",
//"DropOffLon": "72.4876135",
//"PickupDateTime": "2019-06-30 11:30:00",
//"DeadHead": "11 mins",
//"Distance": "4.791",
//"ShipperName": "EWW Driver",
//"Budget": "100",
//"Weight": "12",
//"Quantity": "104",
//"CardId": "1",
//"Notes": "test",
//"Image": "images/passenger/d343c560559068050035b6c1dcfef0e0.png",
//"Status": "0",
//"CreatedDate": "2019-07-01 16:31:25"
//}
//]
//}
extension OpenBidListViewController : RefreshData{
    func dataRefresh() {
        webserviceCallToGetOpenBidList()
    }
    
    
}


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

    @IBOutlet weak var tblView: UITableView!
    private let refreshControl = UIRefreshControl()
     var arrNumberOfOnlineCars : [[String:AnyObject]]!
     var aryData = [[String:AnyObject]]()
    let dateFormatter = DateFormatter()
    let date = Date()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblView.refreshControl = refreshControl
        arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        webserviceCallToGetBidList()
       self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
    }
   
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallToGetBidList()
    }

    //MARK: ===== API Call Get Bids ======
    func webserviceCallToGetBidList()
    {
        let param = [
        "PassengerId" : SingletonClass.sharedInstance.strPassengerID
        
            ] as [String:Any]
        print(param)
        
        webserviceForGetCustomerBid(param as AnyObject) { (result, status) in
        
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
            
        
//        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
//
//        //
//        //
//        customCell.lblTicketID.text = "Ticket ID: \(dictData["TicketId"] as! String)"
//        customCell.lblTitle.text = dictData["TicketTitle"] as! String
//        let StrStatus = dictData["Status"] as! String
//
//        if StrStatus == "0"
//        {
//            customCell.lblStatus.text = "Pending"
//        }
//        if StrStatus == "1"
//        {
//            customCell.lblStatus.text = "Processing"
//        }
//        if StrStatus == "2"
//        {
//            customCell.lblStatus.text = "Complete"
//        }
//
        return customCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
//
//        //
//        //
//
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        viewController.strTicketID = dictData["TicketId"] as! String
//        viewController.strTicketTile = dictData["TicketTitle"] as! String
//
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
         let dictData = arrReviewData[indexPath.row]
         if let cell = tblView.cellForRow(at: indexPath) as? HelpListViewCell
         {
         cell.lblDescription.isHidden = !cell.lblDescription.isHidden
         if cell.lblDescription.isHidden
         {
         expandedCellPaths.remove(indexPath)
         cell.lblDescription.text = ""
         cell.iconArrow.image = UIImage.init(named: "arrow-down-leftBlue")
         cell.viewCell.layer.borderColor = UIColor.clear.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         else
         {
         expandedCellPaths.insert(indexPath)
         cell.lblDescription.text = dictData["Answers"] as? String
         cell.iconArrow.image = UIImage.init(named: "arrow-down-Blue")
         cell.viewCell.layer.borderColor = UIColor.black.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         
         DispatchQueue.main.async {
         self.tblView.beginUpdates()
         self.tblView.endUpdates()
         }
         
         //            DispatchQueue.main.async {
         //                self.tableView.reloadRows(at: [indexPath], with: .automatic)
         //            }
         
         }
         */
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if aryData.count == 0 {
            return self.tblView.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    @objc func viewDetailsBtnAction(_ sender:UIButton) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailsViewController") as! BidDetailsViewController
        detailVC.aryData = [aryData[sender.tag]]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

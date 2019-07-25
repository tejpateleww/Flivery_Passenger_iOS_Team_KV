//
//  BidDetailsViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class BidDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- ====== Outlets ======
    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var iconVehicle: UIImageView!
    @IBOutlet weak var lblBidCount: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblPickupDateTitle: UILabel!
    @IBOutlet weak var lblDeaheadTitle: UILabel!
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblDeahead: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDriveOfferTitle: UILabel!
    @IBOutlet weak var lblBidId: UILabel!
    @IBOutlet weak var tblView: UITableView!

    var isFromOpenBid = Bool()
  
    //MARK:- ====== Variables ======
    private let refreshControl = UIRefreshControl()
    var bidDetail = [String:Any]()
    var aryData = [[String:AnyObject]]()
    var arrNumberOfOnlineCars : [[String:AnyObject]]!
    var arrBidDetails = [[String:AnyObject]]()
    let dateFormatter = DateFormatter(format: "yyyy/MM/dd")
    let date = Date()
    var strbidID = String()
    var strDriverID = String()
    var isselected = Bool()
    
  //MARK:- ====== View Controller Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bid Detail"
        self.setDefaultBackButton()
        self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
        arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]
        DataSetup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- ====== Data Setup Method======
    func DataSetup(){
         self.viewLabel.isHidden = self.arrBidDetails.count > 0 ? false : true
        if let distance = aryData[0]["Distance"] as? String{
            lblDistance.text = distance
        }
        lblBidId.text = "Bid Id - " + String(describing: aryData[0]["BidId"]!)

        if let PickupLocation = aryData[0]["PickupLocation"] as? String{
            lblPickupLocation.text = PickupLocation
        }
        if let price = aryData[0]["Budget"] as? String{
            lblPrice.text = "USD " + price
        }
        if let deadHead = aryData[0]["DeadHead"] as? String{
            lblDeahead.text = deadHead
        }
        if let pickup = aryData[0]["PickupDateTime"] as? String{
            let pickupDate : [String] = pickup.components(separatedBy: " ")
            var date : String = pickupDate[0]
            let datestring = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd MMMM")
            lblPickupDate.text =  datestring
        }
        if let droplocation = aryData[0]["DropoffLocation"] as? String{
            lblDropoffLocation.text = droplocation
        }

        if(isFromOpenBid == true)
        {
            if let bids = aryData[0]["DriverBids"] as? String{
                lblBidCount.text = "Bids - " + bids
                if bids != "0"{
                    if let bidID = aryData[0]["Id"] as? String{
                        print(bidID)
                        if bidID != "0"{
                            GetBidDetails(bidID: bidID)
                        }
                    }
                }
            }
            else if let bids = aryData[0]["DriverBids"] as? Int{
                lblBidCount.text = "Bids - " + "\(bids)"
                if bids != 0{
                    if let bidID = aryData[0]["Id"] as? String{
                        print(bidID)
                        if bidID != "0"{
                            GetBidDetails(bidID: bidID)
                        }
                    }
                }
            }
        }
        else
        {
             bidAcceptedByDriver()
        }
        if let modelId = aryData[0]["ModelId"] as? String{
            for i in arrNumberOfOnlineCars{
                if i["Id"] as! String == modelId{
                    let imgUrl = i["Image"] as! String
                    iconVehicle.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
                    lblVehicleName.text = i["Name"] as? String
                    break
                }
            }
        }
    }


    func bidAcceptedByDriver()
    {

        let dictData = aryData[0] as? [String:Any]


        var strDriverID = String()

        if let DriverID = dictData?["DriverId"] as? String
        {
            strDriverID = DriverID
        }
        else if let DriverID = dictData?["DriverId"] as? Int
        {
            strDriverID = String(DriverID)
        }
        if(strDriverID != "0")
        {
            self.arrBidDetails = self.aryData
        }
        self.tblView.reloadData()

//        let dictData = [String:Any]()
//        dictData["Fullname"] =
//        dictData["DriverImage"] = 
//        dictData["DriverBudget"] =
//        dictData["DriverNotes"] =
//        dictData["DriverRating"] =
//        dictData["DeadHead"] =
//        dictData["BidId"] =
//        dictData["DriverId"] =

    }
    
     //MARK:- ====== Api call For Get Bid Details ======
    func GetBidDetails(bidID : String){
       
        webserviceForGetCustomerBidDetails(bidID as AnyObject) { (result, status) in
            if (status) {
                print(result)
                self.arrBidDetails = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
                SingletonClass.sharedInstance.CustomerBidDetails = self.arrBidDetails
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
    //MARK:- ====== Tableview Datasource And Delegate Methods ======
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrBidDetails.count > 0 ?  arrBidDetails.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if arrBidDetails.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataFoundTableViewCell") as! NoDataFoundTableViewCell
            cell.lblNoDataFound.text = "No driver has made any bid!"
            return cell
        } else {
        
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "DriverOffersListViewCell") as! DriverOffersListViewCell
            customCell.btnMessage.addTarget(self, action: #selector(btnActionSendMessage(_:)), for: .touchUpInside)
            customCell.btnMessage.tag = indexPath.row
        customCell.selectionStyle = .none
        customCell.btnAccept.tag = indexPath.row
            customCell.btnAccept.addTarget(self, action: #selector(btnActionAccept(_:)), for: .touchUpInside)
        if let driverName = arrBidDetails[indexPath.row]["Fullname"] as? String{
            customCell.lblDriverName.text = driverName
        }
        if let imageUrl = arrBidDetails[indexPath.row]["DriverImage"] as? String{
             customCell.imgProfile.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + imageUrl), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        if let bidPrice = arrBidDetails[indexPath.row]["DriverBudget"] as? String{
            customCell.lblAmount.text = "USD " + bidPrice
        }
        if let driverNotes = arrBidDetails[indexPath.row]["DriverNotes"] as? String{
            customCell.lblDetail.text = driverNotes
        }
        if let ratingcount = arrBidDetails[indexPath.row]["DriverRating"] as? String{
            customCell.ratingView.rating = Double(ratingcount)!
            customCell.lblRate.text =  ratingcount
        }
        if let deadHead = arrBidDetails[indexPath.row]["DeadHead"] as? String{
            customCell.lblTime.text = deadHead
        }
        if let bidID = arrBidDetails[indexPath.row]["BidId"] as? String{
           strbidID = bidID
        }
        if let DriverID = arrBidDetails[indexPath.row]["DriverId"] as? String{
           strDriverID = DriverID
        }
             customCell.lblAccepted.textColor =  ThemeGreenColor
            if isFromOpenBid {
                customCell.vwChat.isHidden = false
                customCell.vwAccept.isHidden = false
                customCell.lblAccepted.isHidden = true
                
            }else {
                customCell.vwChat.isHidden = true
                customCell.vwAccept.isHidden = true
                customCell.lblAccepted.isHidden = false
                
            }
            
        return customCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return arrBidDetails.count != 0 ? UITableViewAutomaticDimension : self.tblView.frame.height
       
    }
    //MARK:- ====== Accept Button Action ======
    @objc func btnActionAccept(_ sender : UIButton){
        isselected = true
        webserviceForBidAccept()
    }
    @objc func btnActionSendMessage(_ sender : UIButton){
      var dict =  arrBidDetails[sender.tag]
        
        guard let vwChatController = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController else {
            return
        }
        
        guard let BidID = dict["BidId"] as? String else {
            return
        }
        guard let DriverID = dict["DriverId"] as? String else {
            return
        }
        guard let DriverName = dict["Fullname"] as? String else {
            return
        }
     
        vwChatController.strBidID = BidID
        vwChatController.strDriverID = DriverID
        vwChatController.strDriverName = DriverName
        
        self.navigationController?.pushViewController(vwChatController, animated: true)
//        isselected = true
//        webserviceForBidAccept()
    }
    
    //MARK:- ====== Api call For AcceptBid ======
    func webserviceForBidAccept(){
        let statusType = isselected == true ? "1" : "0"
        let param = [
            "BidId" : strbidID,
            "DriverId" : strDriverID,
            "Status"  : statusType
        ] as [String:Any]
        
        print(param)
        webserviceForGetCustomerBidAccept(param as AnyObject) { (result, status) in
            if (status) {
                print(result)
                /*
                if let objData = result["status"] as? String
                {
                    if(objData == "1")
                    {
                        UtilityClass.showAlert("", message: "Success", vc: self)
                         self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        UtilityClass.showAlert("", message: "Error", vc: self)

                    }
                }
                else if let objData = result["status"] as? Int
                {
                    if(objData == 1)
                    {
                        UtilityClass.showAlert("", message: "Success", vc: self)
                         self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        UtilityClass.showAlert("", message: "Error", vc: self)

                    }
                } */

//                let objData = (result as! NSDictionary).object(forKey: "data") as! [String:AnyObject]
//                let msg = (result as! NSDictionary).object(forKey: "message") as! String
//                self.navigationController?.popViewController(animated: true)
//                UtilityClass.showAlert("", message: msg, vc: self)
                
//                self.tblView.reloadData()
                
                self.refreshControl.endRefreshing()
                if let VwBidList = self.navigationController?.viewControllers[1] as? BidListContainerViewController {
                    VwBidList.dataRefresh()
                    self.navigationController?.popViewController(animated: true)
                }
               
            }
            else {
                print(result)
                UtilityClass.defaultMsg(result: result)
                // UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }
        }
    }
    


}
//"Id": "72",
//"PassengerId": "14",
//"ModelId": "3",
//"PickupLocation": "Excellent WebWorld, 203-206 City Center Opp Shukan Mall, Science City Rd, Science City, Sola, Ahmedabad, Gujarat 380060, India",
//"DropoffLocation": "Sola Cross Road, 132 Feet Ring Rd, Memnagar, Ahmedabad, Gujarat 380063, India",
//"PickupLat": "23.0726365",
//"PickupLng": "72.5164187",
//"DropOffLat": "23.0527303",
//"DropOffLon": "72.54663309999999",
//"PickupDateTime": "2019-07-02 17:39:24",
//"DeadHead": "11 mins",
//"Distance": "4.436",
//"ShipperName": "xyz",
//"Budget": "50",
//"Weight": "45",
//"Quantity": "5",
//"CardId": "18",
//"Notes": "xyccc",
//"Image": "images/passenger/f311b826f1984728c229dbef256bdf8d.png",
//"Status": "0",
//"CreatedDate": "2019-07-02 17:40:10",
//"DPassengerId": "14",
//"DriverId": "5",
//"BidId": "72",
//"DriverNotes": "test",
//"DriverStatus": "1",
//"DriverBudget": "50",
//"DriverDatetime": "2019-07-02 17:50:00",
//"DriverID": "5",
//"Fullname": "Jon Snow",
//"DriverImage": "images/driver/5/2ac088c174f62515e65f31636186d8aa.png",
//"UserId": "5",
//"DriverRating": "4"

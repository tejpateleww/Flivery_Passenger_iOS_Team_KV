//
//  UpCommingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingVC: UIViewController, UITableViewDataSource, UITableViewDelegate { 

    
//    var aryData = NSArray()
    var aryData:[[String:Any]] = []
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    let notAvailable: String = "N/A"
    
    var bookinType = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeWhiteColor
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoDataFound.text = "No Data Found".localized
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(self.refreshControl)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func reloadDataTableView()
    {
//        self.aryData = SingletonClass.sharedInstance.aryUpComming
        
        if self.aryData.count > 0 {
            self.lblNoDataFound.isHidden = true
        } else {
            self.lblNoDataFound.isHidden = false
        }
        
        self.tableView.reloadData()
        
        
//        self.tableView.frame.size = tableView.contentSize
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryData.count > 0 {
            //            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
            cell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
            cell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
            cell.lblPickUpTimeTitle.text = "PICKUP TIME".localized
            cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
            cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
            
            
            
          
            
            
            cell.btnCancelRequest.setTitle("Track Your Trip".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.font = UIFont.bold(ofSize: 8.0)
            
            //            cell.viewCell.layer.cornerRadius = 10
            //            cell.viewCell.clipsToBounds = true
            
            let dictData = aryData[indexPath.row]
            
            
            
            /////
            
            cell.lblParcelTypeTitle.text = "PARCEL TYPE".localized
            cell.lblParcelWeightTitle.text = "PARCEL WEIGHT".localized
            cell.lblTripFareTitle.text = "DELIVERY FARE".localized
            
            cell.lblTaxTitle.text = "TAX".localized
            cell.lblTotalTitle.text = "TOTAL".localized
            
            
            if let parcelWeight = dictData["Weight"] as? String {
                cell.lblParcelWeight.text =  ": " + String(format: "%.2f", Double((parcelWeight != "") ? parcelWeight : "0.0")!) + " Kg"
            }
            if let TripFare = dictData["TripFare"] as? String {
                cell.lblTripFare.text = ": \(currencySign)" +  String(format: "%.2f", Double((TripFare != "") ? TripFare : "0.0")!)
            }
            if let dictParcelDetails = dictData["Parcel"] as? [String:Any] {
                if let parcelName = dictParcelDetails["Name"] as? String {
                    cell.lblParcelType.text =  ": " + parcelName
                }
            }
            if let Tax = dictData["Tax"] as? String {
                cell.lblTax.text = ": \(currencySign)\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!))"
                //                        if Tax == "" || Tax == "0" {
                //                            cell.StackTax.isHidden = true
                //                        } else {
                //                            cell.StackTax.isHidden = false
                //                        }
            }
            if let GrandTotal = dictData["GrandTotal"] as? String {
                cell.lblTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((GrandTotal != "") ? GrandTotal : "0.0")!))"
                
                //                        if GrandTotal == "" || GrandTotal == "0" {
                //                            cell.StackGrandTotal.isHidden = true
                //                        } else {
                //                            cell.StackGrandTotal.isHidden = false
                //                        }
            }
            
            /// changeeee
            
            
            if let BookingID = dictData[ "Id"] as? String {
                cell.lblBookingId.text = "\("Booking Id".localized) : \(BookingID)"
            }
            
            //            cell.lblBookingID.attributedText = formattedString
            if let Createdate = dictData[ "CreatedDate"] as? String {
                cell.lblDateAndTime.text =  ": " + Createdate
            }
            
            //            if let Notes = dictData["Notes"] as? String {
            //                cell.lblNotes.text = Notes
            //            }
            
            if let PickupLocation = dictData[ "PickupLocation"] as? String {
                cell.lblPickupAddress.text = ": " + PickupLocation // PickupLocation
            }
            if let DropOffAddress = dictData[ "DropoffLocation"] as? String {
                cell.lblDropoffAddress.text =  ": " + DropOffAddress  // DropoffLocation
            }
            if let pickupTime = dictData[ "PickupDateTime"] as? String {
                if pickupTime == "" {
                    cell.lblPickUpTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickUpTime.text = ": " +  pickupTime
                    //                        setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            if let vehicleType = dictData["Model"] as? String {
                cell.lblVehicleType.text = ": " + vehicleType
            }
            if let PaymentType = dictData["PaymentType"] as? String {
                cell.lblPaymentType.text = ": " + PaymentType
            }
            
//            if let ParcelArray = dictData["parcel_info"] as? [[String:Any]] {
//                cell.arrParcel = ParcelArray
//                cell.setParcelDetail()
//            }
            
            
            if let strParcelImage = dictData["ParcelImage"] as? String {
                cell.imgParcelImage.sd_setShowActivityIndicatorView(true)
                cell.imgParcelImage.sd_setIndicatorStyle(.gray)
                cell.imgParcelImage?.sd_setImage(with: URL(string: strParcelImage), completed: { (image, error, cacheType, url) in
                    cell.imgParcelImage.sd_removeActivityIndicator()
                    cell.imgParcelImage.contentMode = .scaleAspectFit
                })
            }
            if let strBidID = dictData["BidId"] as? String, strBidID != "0"{
               cell.vwDeliveryFare.isHidden = false
                cell.vwTax.isHidden = false
               cell.vwTotal.isHidden = false
            }else {
                cell.vwDeliveryFare.isHidden = true
                cell.vwTax.isHidden = true
               cell.vwTotal.isHidden = true
            }
            cell.ViewDeliveredParcelImage.isHidden = true
            let myString = aryData[ indexPath.row]["DriverName"] as? String
            cell.lblDriverName.text = myString
            
            bookinType = aryData[ indexPath.row]["BookingType"] as! String
            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            cell.btnCancelRequest.tag = indexPath.row
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryData.count > 0 {
//            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
            cell.lblPickupAddressTitle.text = "Pickup Location".localized
            cell.lblDropoffAddressTitle.text = "Dropoff Location".localized
            cell.lblPickUpTimeTitle.text = "PICKUP TIME".localized
            cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
            cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
            
            cell.btnCancelRequest.setTitle("Track Your Trip".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.font = UIFont.bold(ofSize: 11.0)
            
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            
            let dictData = aryData.object(at: indexPath.row) as! NSDictionary
            
            if let BookingID = dictData.object(forKey: "Id") as? String {
                cell.lblBookingId.text = "\("Booking Id".localized) : \(BookingID)"
            }
            
            //            cell.lblBookingID.attributedText = formattedString
            cell.lblDateAndTime.text = dictData.object(forKey: "CreatedDate") as? String
            cell.lblPickupAddress.text = dictData.object(forKey: "PickupLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = dictData.object(forKey: "DropoffLocation") as? String  // DropoffLocation
            
            if let pickupTime = dictData.object(forKey: "PickupDateTime") as? String {
                if pickupTime == "" {
                    cell.lblPickUpTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickUpTime.text = pickupTime
//                        setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            cell.lblVehicleType.text = dictData.object(forKey: "Model") as? String
            cell.lblPaymentType.text = dictData.object(forKey: "PaymentType") as? String
            
            let myString = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
            cell.lblDriverName.text = myString
            
            bookinType = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingType") as! String
            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            cell.btnCancelRequest.tag = indexPath.row
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        return cell
        */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let cell = tableView.cellForRow(at: indexPath) as? UpCommingTableViewCell {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
    }
    
    @objc func CancelRequest(sender: UIButton)
    {
        let Index = sender.tag
        let currentData = aryData[Index]
        guard let bookingID = currentData["Id"] as? String else {
            return
        }
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to cancel this request?", cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Yes", "No"], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2)
            {
                
                
                let socketData = (self.navigationController?.childViewControllers[0] as! HomeViewController).socket
                //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController).socket
                let showTopView = self.navigationController?.childViewControllers[0] as! HomeViewController //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController)
                
                if (SingletonClass.sharedInstance.isTripContinue) {
                    
                    //            if (SingletonClass.sharedInstance.bookingId == String(bookingID)) {
                    
                    //                    UtilityClass.setCustomAlert(title: "Your trip has started", message: "You cannot cancel this request.") { (index, title) in
                    //                    }
//                    AlertMessage.showMessageForError("Your trip has started \n You cannot cancel this request.")
                    //            }
                    UtilityClass.setCustomAlert(title: "", message: "Your trip has started \n You cannot cancel this request.") { (index, title) in
                    }
                }
                else {
                    if self.bookinType == "Book Now"
                    {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
                        showTopView.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        self.webserviceOfBookingHistory()
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        //                        self.navigationController?.popViewController(animated: true)
                        //                }
                        
                        
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                    else {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
                        self.webserviceOfBookingHistory()
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        //                        self.navigationController?.popViewController(animated: true)
                        //                }
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                }
            }
        })
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func changeDateAndTimeFormate(dateAndTime: String) -> String {
        
        let time = dateAndTime // "22:02:00"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd HH-mm-ss"
        
        var fullDate = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm"
        
        var time2 = dateFormatter.string(from: fullDate!)
        
        return time2
    }
    
    @objc func webserviceOfBookingHistory()
    {
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            UtilityClass.setCustomAlert(title: "", message: "Internet connection not available") { (index, title) in
            }
            //            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            //            }
            return
        }
        webserviceForUpcomingBookingList(dictParams: SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                self.aryData = result["history"] as! [[String:Any]]
                print(self.aryData)
                self.reloadDataTableView()
                self.refreshControl.endRefreshing()
                
            }
            else {
                
                print(result)
                var ErrorMessage = String()
                if let res = result as? String {
                    ErrorMessage = res
                    //                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    //                    }
                }
                else if let resDict = result as? NSDictionary {
                    ErrorMessage = resDict.object(forKey: "message") as! String
                    //                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    //                    }
                }
                else if let resAry = result as? NSArray {
                    ErrorMessage = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                    //                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    //                    }
                }
                UtilityClass.setCustomAlert(title: "", message: ErrorMessage) { (index, title) in
                }
//                AlertMessage.showMessageForError(ErrorMessage)
                //                if let res = result as? String {
                //                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                //                    }
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.setCustomAlert(title: "", message: resDict[ "message"] as! String) { (index, title) in
                //                    }
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary)[ "message"] as! String) { (index, title) in
                //                    }
                //                }
            }
        }
    }
}

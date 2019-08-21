//
//  PastBookingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

protocol GiveTipAlertDelegate {
    func didOpenTipViewController(BookingId:String, BookingType:String)
}

class PastBookingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var DelegateForTip:GiveTipAlertDelegate!
    var aryData : [[String:Any]] = []
    var strPickupLat = String()
    var strPickupLng = String()
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var strNotAvailable: String = "N/A"
    
    var expandedCellPaths = Set<IndexPath>()
    
    
    
    var PageLimit:Int = 10
    var NeedToReload:Bool = false
    var PageNumber:Int = 1
    
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.ReloadNewData),
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
        reloadTableView()
        getPastBookingHistory()
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

     func setLocalization()
     {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView()
    {
        if self.aryData.count > 0 {
            self.lblNoDataFound.isHidden = true
        } else {
            self.lblNoDataFound.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func ReloadNewData() {
        self.PageNumber = 1
        self.NeedToReload = false
        self.aryData.removeAll()
        self.tableView.reloadData()
//        self.webserviceOfPastbookingpagination(index: self.PageNumber)
         getPastBookingHistory()
    }
    
    func reloadMoreHistory() {
        self.PageNumber += 1
//        self.webserviceOfPastbookingpagination(index: self.PageNumber)
         getPastBookingHistory()
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
        
            var CustomCell = UITableViewCell()
            
            if aryData.count > 0 {
                let currentData = aryData[indexPath.row]
                
                if let TripStatus = currentData["Status"] as? String {
                    if TripStatus == "canceled" {
                        
                        let CancelledCell = tableView.dequeueReusableCell(withIdentifier: "CanceledBookingTableViewCell") as! CanceledBookingTableViewCell
                        
                        CancelledCell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
                        CancelledCell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
//                        CancelledCell.lblPickupAddressTitle.text = "PICKUP TIME".localized
                        
                        CancelledCell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                        CancelledCell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
//                        CancelledCell.lblTripStatusTitle.text = "TRIP STATUS".localized
                        
                        CancelledCell.lblParcelTypeTitle.text = "PARCEL TYPE".localized
                        CancelledCell.lblParcelWeightTitle.text = "PARCEL WEIGHT".localized
                        CancelledCell.lblDeliveryDistanceTitle.text = "DELIVERY DISTANCE".localized
                        CancelledCell.lblDeliveryDurationTitle.text = "DELIVERY DURATION".localized
                        
                        
                        if let DriverName = currentData["DriverName"] as? String {
                            CancelledCell.lblDriverName.text = DriverName
                        } else {
                            CancelledCell.lblDriverName.text = ""
                        }
                        
                        if let BookingId = currentData["Id"] as? String {
                            CancelledCell.lblBookingId.text = "\("Booking Id :".localized) \(BookingId)"
                        }
                        
                        if let pickupAddress = currentData["PickupLocation"] as? String {
                            CancelledCell.lblPickupAddress.text = ": " + pickupAddress
                        }
                        
                        if let dropOffAddress = currentData["DropoffLocation"] as? String {
                            CancelledCell.lblDropoffAddress.text = ": " + dropOffAddress
                        }
                        
                        if let dateAndTime = currentData["CreatedDate"] as? String {
                            CancelledCell.lblDateAndTime.text =  ": " + dateAndTime
                        }
                        
                        if let VehicleType = currentData[ "Model"] as? String {
                            CancelledCell.lblVehicleType.text = ": " + VehicleType
                            
                            //                        if VehicleType == ""{
                            //                            CancelledCell.StackVehicleType.isHidden  = true
                            //                        } else {
                            //                            CancelledCell.StackVehicleType.isHidden = false
                            //                        }
                        }
                        CancelledCell.imgStatus.image = UIImage.init(named: "cancelled")
                        CancelledCell.lblStatus.text = "CANCELED"
                        
                        if let PaymentType = currentData[ "PaymentType"] as? String {
                            CancelledCell.lblPaymentType.text = ": " + PaymentType
                            //                        if PaymentType == "" {
                            //                            CancelledCell.StackPaymentType.isHidden = true
                            //                        } else {
                            //                            CancelledCell.StackPaymentType.isHidden = false
                            //                        }
                        }
                        
                        
                        //////////////////////
                        if let dictParcelDetails = currentData["Parcel"] as? [String:Any] {
                            if let parcelName = dictParcelDetails["Name"] as? String {
                                CancelledCell.lblParcelType.text =  ": " + parcelName
                            }
                        }
                        //                        if let parcelType = currentData["Model"] as? String {
                        //                            cell.lblParcelType.text =  ": " + parcelType
                        //                        }
                        if let parcelWeight = currentData["Weight"] as? String {
                            CancelledCell.lblParcelWeight.text =  ": " + String(format: "%.2f", Double((parcelWeight != "") ? parcelWeight : "0.0")!) + " Kg"
                        }
                        if let DistanceTravelled = currentData["TripDistance"] as? String {
                            CancelledCell.lblDeliveryDistance.text = ": \(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) Km"
                            
                        }
                        if let strParcelImage = currentData["ParcelImage"] as? String {
                            CancelledCell.imgvwParcelImage.sd_setShowActivityIndicatorView(true)
                            CancelledCell.imgvwParcelImage.sd_setIndicatorStyle(.gray)
                            CancelledCell.imgvwParcelImage?.sd_setImage(with: URL(string: strParcelImage), completed: { (image, error, cacheType, url) in
                                CancelledCell.imgvwParcelImage.sd_removeActivityIndicator()
                                CancelledCell.imgvwParcelImage.contentMode = .scaleAspectFit
                            })
                        }
                        if let waitingTime = currentData["TripDuration"] as? String
                        {
                            
                            var strWaitingTime: String = "00:00:00"
                            
                            if waitingTime != "" {
                                let intWaitingTime = Int(waitingTime)
                                let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                                if WaitingTimeIs.0 == 0 {
                                    if WaitingTimeIs.1 == 0 {
                                        strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                                    } else {
                                        strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                    }
                                } else {
                                    strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                }
                            }
                            else {
                                strWaitingTime = waitingTime
                            }
                            CancelledCell.lblDeliveryDuration.text = ": " + strWaitingTime
                            
                            
                        }
                        ////////////////////
//                        CancelledCell.lblTripStatus.text = TripStatus
//                         CancelledCell.lblTripStatus.isHidden = true
//                        CancelledCell.lblTripStatus.isHidden = true
                        CancelledCell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                        CancelledCell.selectionStyle = .none
                        CustomCell = CancelledCell
                    }
                    else
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell
                        
                        cell.imgStatus.image = UIImage.init(named: "verified")
                        cell.lblStatus.text = "COMPLETED"
                        
                        cell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
                        cell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
                        cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized

                        //////////////////
                        cell.lblParcelTypeTitle.text = "PARCEL TYPE".localized
                        cell.lblParcelWeightTitle.text = "PARCEL WEIGHT".localized
                        cell.lblDistanceTravelledTitle.text = "DELIVERY DISTANCE".localized
                        cell.lblDeliveryDurationTitle.text = "DELIVERY DURATION".localized
                        cell.lblWeightCostTitle.text = "WEIGHT CHARGE".localized
                        cell.lblSubTotalTitle.text = "SUB TOTAL".localized
                        /////////////////
                        
                        cell.lblPickupTimeTitle.text = "PICKUP TIME".localized
                        cell.lblDropoffTimeTitle.text = "DROPOFF TIME".localized
                        
                        cell.lblTripFareTitle.text = "DELIVERY FARE".localized
                        
                       
                        cell.lblBookingDate.text = "BOOKING DATE".localized
                       
//                        cell.lblWaitingTimeTitle.text = "WAITING TIME".localized
                        cell.lblBookingCharge.text = "BOOKING CHARGE".localized
                        cell.lblTaxTitle.text = "TAX".localized
                        cell.lblDiscountTitle.text = "DISCOUNT".localized
                        cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                        cell.lblTotalTitle.text = "TOTAL".localized
                        
                        
                        cell.btnTips.setTitle("TIPS".localized, for: .normal)
                        cell.btnTips.titleLabel?.font = UIFont.bold(ofSize: 11.0)
                        
                        cell.selectionStyle = .none
                        //            cell.viewCell.layer.cornerRadius = 10
                        //            cell.viewCell.clipsToBounds = true
                        //        cell.viewCell.layer.shadowRadius = 3.0
                        //        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                        //        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
                        //        cell.viewCell.layer.shadowOpacity = 1.0
                        
                        
                        //            cell.lblDriverName.text = ""
                        
                        if let DriverName = currentData[ "DriverName"] as? String {
                            cell.lblDriverName.text = DriverName
                        } else {
                            cell.lblDriverName.text = ""
                        }
                        //=================
                        
                        if let dictParcelDetails = currentData["Parcel"] as? [String:Any] {
                            if let parcelName = dictParcelDetails["Name"] as? String {
                                 cell.lblParcelType.text =  ": " + parcelName
                            }
                        }
//                        if let parcelType = currentData["Model"] as? String {
//                            cell.lblParcelType.text =  ": " + parcelType
//                        }
                        if let parcelWeight = currentData["Weight"] as? String {
                            cell.lblParcelWeight.text =  ": " + String(format: "%.2f", Double((parcelWeight != "") ? parcelWeight : "0.0")!) + " Kg"
                        }
                        if let DistanceTravelled = currentData["TripDistance"] as? String {
                            cell.lblDistanceTravelled.text = ": \(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) Km"

                        }
                        if let waitingTime = currentData["TripDuration"] as? String
                        {
                            
                            var strWaitingTime: String = "00:00:00"
                            
                            if waitingTime != "" {
                                let intWaitingTime = Int(waitingTime)
                                let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                                if WaitingTimeIs.0 == 0 {
                                    if WaitingTimeIs.1 == 0 {
                                        strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                                    } else {
                                        strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                    }
                                } else {
                                    strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                }
                            }
                            else {
                                strWaitingTime = waitingTime
                            }
                            cell.lblDeliveryDuration.text = ": " + strWaitingTime
                            
                       
                        }
                        if let TripFare = currentData["TripFare"] as? String {
                            cell.lblTripFare.text = ": \(currencySign)" +  String(format: "%.2f", Double((TripFare != "") ? TripFare : "0.0")!)
                        }
                        if let weightCharge = currentData["WeightCharge"] as? String {
                            cell.lblWeightCharge.text = ": \(currencySign)" +  String(format: "%.2f", Double((weightCharge != "") ? weightCharge : "0.0")!)
                        }
                        
                        if let subTotal = currentData["SubTotal"] as? String {
                            cell.lblSubtotal.text = ": \(currencySign)" +  String(format: "%.2f", Double((subTotal != "") ? subTotal : "0.0")!)
                        }
                    
                        //=======================
                        if let BookingId = currentData["Id"] as? String {
                            cell.lblBookingID.text = "\("Booking Id :".localized) \(BookingId)"
                        }
                        
                        if let pickupAddress = currentData["PickupLocation"] as? String {
                            cell.lblPickupAddress.text = ": " + pickupAddress
                        }
                        
                        if let dropOffAddress = currentData["DropoffLocation"] as? String {
                            cell.lblDropoffAddress.text = ": " +  dropOffAddress
                        }
                        
                        if let dateAndTime = currentData["CreatedDate"] as? String {
                            cell.lblDateAndTime.text =  ": " + dateAndTime
                        }
                        
                        if let pickupTime = currentData["PickupTime"] as? String {
                            cell.lblPickupTime.text = ": " + ((pickupTime != "") ? setTimeStampToDateForPickup(timeStamp: pickupTime) : "")
                        }
                        
                        if let dropOffTime = currentData["DropTime"] as? String {
                            cell.lblDropoffTime.text = ": " + ((dropOffTime != "") ? setTimeStampToDateForPickup(timeStamp: dropOffTime) : "")
                        }
                        
                        if let VehicleType = currentData[ "Model"] as? String {
                            cell.lblVehicleType.text = ": " + VehicleType
                            
                            //                        if VehicleType == ""{
                            //                            cell.StackVehicleType.isHidden  = true
                            //                        } else {
                            //                            cell.StackVehicleType.isHidden = false
                            //                        }
                        }

                        
                   
                        
//                        if let nightFare = currentData["NightFare"] as? String {
//                            cell.lblNightFare.text = ": \(currencySign)" + nightFare
//                        }
                        
                        cell.btnTips.addTarget(self, action: #selector(self.Tips(sender:)), for: .touchUpInside)
                        cell.btnTips.tag = indexPath.row
                        cell.btnTips.layer.cornerRadius = 5
                        cell.btnTips.layer.masksToBounds = true
                        
//                        if let tollFee = currentData["TollFee"] as? String {
//                            if tollFee == "" || tollFee == "0" {
//                                cell.btnTips.isHidden = false
//                                cell.lblTollFee.text = tollFee
//                            } else {
//                                cell.lblTollFee.text = tollFee
//                                cell.btnTips.isHidden = true
//                            }
//                        }
                        
                        
                        if let strParcelImage = currentData["ParcelImage"] as? String {
                            cell.imgParcelImage.sd_setShowActivityIndicatorView(true)
                            cell.imgParcelImage.sd_setIndicatorStyle(.gray)
                            cell.imgParcelImage?.sd_setImage(with: URL(string: strParcelImage), completed: { (image, error, cacheType, url) in
                                cell.imgParcelImage.sd_removeActivityIndicator()
                                cell.imgParcelImage.contentMode = .scaleAspectFit
                            })
                        }
                        
                        cell.ViewDeliveredParcelImage.isHidden = false
                        if let strDeliveredParcelImage = currentData["DeliveredParcelImage"] as? String {
                            cell.imgDeliveredParcelImage.sd_setShowActivityIndicatorView(true)
                            cell.imgDeliveredParcelImage.sd_setIndicatorStyle(.gray)
                            cell.imgDeliveredParcelImage?.sd_setImage(with: URL(string: strDeliveredParcelImage)) { (image, error, cacheType, url) in
                                cell.imgDeliveredParcelImage.sd_removeActivityIndicator()
                                cell.imgDeliveredParcelImage.contentMode = .scaleAspectFit
                            }
                            
                        }
                        
                        if let ParcelArray = currentData["parcel_info"] as? [[String:Any]] {
                            cell.arrParcel = ParcelArray
                            cell.setParcelDetail()
                        }
                        /*
                        if let waitingTime = currentData["WaitingTime"] as? String
                        {
                            
                            var strWaitingTime: String = "00:00:00"
                            
                            if waitingTime != "" {
                                let intWaitingTime = Int(waitingTime)
                                let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                                if WaitingTimeIs.0 == 0 {
                                    if WaitingTimeIs.1 == 0 {
                                        strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                                    } else {
                                        strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                    }
                                } else {
                                    strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                }
                            }
                            else {
                                strWaitingTime = waitingTime
                            }
                            cell.lblWaitingTime.text = ": " + strWaitingTime
                            
                            //                        if strWaitingTime  == "" || strWaitingTime == "00:00:00" {
                            //                            cell.StackWaitingTime.isHidden = true
                            //                        } else {
                            //                            cell.StackWaitingTime.isHidden = false
                            //                        }
                        }
                        */
                        
                        
                        if let bookingCharge = currentData["BookingCharge"] as? String {
                            cell.lblBookingCharge.text = ": \(currencySign)" + String(format: "%.2f", Double((bookingCharge != "") ? bookingCharge : "0.0")!)
                            
                            //                        if bookingCharge == "" || bookingCharge == "0" {
                            //                            cell.StackBookingCharge.isHidden = true
                            //                        } else {
                            //                            cell.StackBookingCharge.isHidden = false
                            //                        }
                        }
                        
                        if let Tax = currentData["Tax"] as? String {
                            cell.lblTax.text = ": \(currencySign)\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!))"
                            //                        if Tax == "" || Tax == "0" {
                            //                            cell.StackTax.isHidden = true
                            //                        } else {
                            //                            cell.StackTax.isHidden = false
                            //                        }
                        }
                        
                        if let Discount = currentData["Discount"] as? String {
                            cell.lblDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                            //                        if Discount == "" || Discount == "0" {
                            //                            cell.StackDiscount.isHidden = true
                            //                        } else {
                            //                            cell.StackDiscount.isHidden = false
                            //                        }
                        }
                        
                        
                        
                        if let GrandTotal = currentData["GrandTotal"] as? String {
                            cell.lblTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((GrandTotal != "") ? GrandTotal : "0.0")!))"
                            
                            //                        if GrandTotal == "" || GrandTotal == "0" {
                            //                            cell.StackGrandTotal.isHidden = true
                            //                        } else {
                            //                            cell.StackGrandTotal.isHidden = false
                            //                        }
                        }
                        
                        if let PaymentType = currentData[ "PaymentType"] as? String {
                            cell.lblPaymentType.text = ": " + PaymentType
                            //                        if PaymentType == "" {
                            //                            cell.StackPaymentType.isHidden = true
                            //                        } else {
                            //                            cell.StackPaymentType.isHidden = false
                            //                        }
                        }
                        
//                        if let TripStatus = currentData[ "Status"] as? String {
//                            cell.lblTripStatus.text = ": " + TripStatus
//                            //                        if TripStatus == "" {
//                            //                            cell.StackTripStatus.isHidden = true
//                            //                        } else {
//                            //                            cell.StackTripStatus.isHidden = false
//                            //                        }
//                        }
//
                        cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                        CustomCell = cell
                    }
                    
                    
                }
                
            }
            
            return CustomCell
        
        /*
        var CustomCell = UITableViewCell()
        
        if aryData.count > 0 {
            let currentData = (aryData.object(at: indexPath.row) as! NSDictionary)
            
            if let TripStatus = currentData.object(forKey: "Status") as? String {
                if TripStatus == "canceled" {
                    
                    let CancelledCell = tableView.dequeueReusableCell(withIdentifier: "CanceledBookingTableViewCell") as! CanceledBookingTableViewCell


                    CancelledCell.imgStatus.image = UIImage.init(named: "cancelled")
                    CancelledCell.lblStatus.text = "Cancelled"
                    
                    CancelledCell.lblPickupAddressTitle.text = "Pickup Location".localized
                    CancelledCell.lblDropoffAddressTitle.text = "Dropoff Location".localized
                    CancelledCell.lblPickupAddressTitle.text = "PICKUP TIME".localized
                    
                    CancelledCell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                    CancelledCell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                    CancelledCell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    if let DriverName = currentData.object(forKey: "DriverName") as? String {
                        CancelledCell.lblDriverName.text = DriverName
                    } else {
                        CancelledCell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData.object(forKey: "Id") as? String {
                        CancelledCell.lblBookingId.text = "\("Booking Id :".localized) : \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData.object(forKey: "PickupLocation") as? String {
                        CancelledCell.lblPickupAddress.text = pickupAddress
                    }
                    
                    if let dropOffAddress = currentData.object(forKey: "DropoffLocation") as? String {
                        CancelledCell.lblDropoffAddress.text = dropOffAddress
                    }
                    
                    if let dateAndTime = currentData.object(forKey: "CreatedDate") as? String {
                        CancelledCell.lblDateAndTime.text = dateAndTime
                    }
                    
                    if let VehicleType = currentData.object(forKey: "Model") as? String {
                        CancelledCell.lblVehicleType.text = VehicleType
                    }
                    
                    if let PaymentType = currentData.object(forKey: "PaymentType") as? String {
                        CancelledCell.lblPaymentType.text = PaymentType
                    }
                    
                    CancelledCell.lblTripStatus.text = TripStatus
                    
                    CancelledCell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                    CancelledCell.selectionStyle = .none
                    CustomCell = CancelledCell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell

                    cell.imgStatus.image = UIImage.init(named: "verified")
                    cell.lblStatus.text = "Completed"
                    
                    cell.lblPickupAddressTitle.text = "Pickup Location".localized
                    cell.lblDropoffAddressTitle.text = "Dropoff Location".localized
                    cell.lblPickupTimeTitle.text = "PICKUP TIME".localized
                    cell.lblDropoffTimeTitle.text = "DROPOFF TIME".localized
                    cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                    cell.lblDistanceTravelledTitle.text = "DISTANCE TRAVELLED".localized
                    cell.lblTripFareTitle.text = "TRIP FARE".localized
                    cell.lblNightFareTitle.text = "NIGHT FARE".localized
                    cell.lblTollFeeTitle.text = "TIPS".localized
                    cell.lblWaitingCostTitle.text = "WAITING COST".localized
                    cell.lblWaitingTimeTitle.text = "WAITING TIME".localized
                    cell.lblBookingCharge.text = "BOOKING CHARGE".localized
                    cell.lblTaxTitle.text = "TAX".localized
                    cell.lblDiscountTitle.text = "DISCOUNT".localized
                    cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                    cell.lblTotalTitle.text = "TOTAL".localized
                    cell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    cell.btnTips.setTitle("TIPS".localized, for: .normal)
                    cell.btnTips.titleLabel?.font = UIFont.bold(ofSize: 11.0)
                    
                    cell.selectionStyle = .none
                    //            cell.viewCell.layer.cornerRadius = 10
                    //            cell.viewCell.clipsToBounds = true
                    //        cell.viewCell.layer.shadowRadius = 3.0
                    //        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                    //        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
                    //        cell.viewCell.layer.shadowOpacity = 1.0
                    
                    
                    //            cell.lblDriverName.text = ""
                    
                    if let DriverName = currentData.object(forKey: "DriverName") as? String {
                        cell.lblDriverName.text = DriverName
                    } else {
                        cell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData.object(forKey: "Id") as? String {
                        cell.lblBookingID.text = "\("Booking Id :".localized) : \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData.object(forKey: "PickupLocation") as? String {
                        cell.lblPickupAddress.text = pickupAddress
                    }
                    
                    if let dropOffAddress = currentData.object(forKey: "DropoffLocation") as? String {
                        cell.lblDropoffAddress.text = dropOffAddress
                    }
                    
                    if let dateAndTime = currentData.object(forKey: "CreatedDate") as? String {
                        cell.lblDateAndTime.text = dateAndTime
                    }
                    
                    if let pickupTime = currentData.object(forKey: "PickupTime") as? String {
                        cell.lblPickupTime.text = (pickupTime != "") ? setTimeStampToDate(timeStamp: pickupTime) : ""
                    }
                    
                    if let dropOffTime = currentData.object(forKey: "DropTime") as? String {
                        cell.lblDropoffTime.text = (dropOffTime != "") ? setTimeStampToDate(timeStamp: dropOffTime) : ""
                    }
                    
                    if let VehicleType = currentData.object(forKey: "Model") as? String {
                        cell.lblVehicleType.text = VehicleType
                    }
                    
                    if let DistanceTravelled = currentData.object(forKey: "TripDistance") as? String {
                        cell.lblDistanceTravelled.text = "\(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) km"
                        //                DistanceTravelled
                    }
                    
                    if let TripFare = currentData.object(forKey: "TripFare") as? String {
                        cell.lblTripFare.text = TripFare
                    }
                    
                    if let nightFare = currentData.object(forKey: "NightFare") as? String {
                        cell.lblNightFare.text = nightFare
                    }
                    
                    cell.btnTips.addTarget(self, action: #selector(self.Tips(sender:)), for: .touchUpInside)
                    cell.btnTips.tag = indexPath.row
                    cell.btnTips.layer.cornerRadius = 5
                    cell.btnTips.layer.masksToBounds = true
                    
//                    if let tollFee = currentData.object(forKey: "TollFee") as? String {
//                        if tollFee == "" || tollFee == "0" {
//                            cell.btnTips.isHidden = false
//                            cell.lblTollFee.text = tollFee
//                        } else {
//                            cell.lblTollFee.text = tollFee
//                            cell.btnTips.isHidden = true
//                        }
//                    }
                    
                    
                    
                    if let waitingCost = currentData.object(forKey: "WaitingTimeCost") as? String {
                        cell.lblWaitingCost.text = waitingCost
                    }
                    
                    if let waitingTime = currentData.object(forKey: "WaitingTime") as? String {
                        
                        var strWaitingTime: String = "00:00:00"
                        
                        if waitingTime != "" {
                            let intWaitingTime = Int(waitingTime)
                            let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                            if WaitingTimeIs.0 == 0 {
                                if WaitingTimeIs.1 == 0 {
                                    strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                                } else {
                                    strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                                }
                            } else {
                                strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                            }
                        }
                        else {
                            strWaitingTime = waitingTime
                        }
                        cell.lblWaitingTime.text = strWaitingTime
                    }
                    
                    if let bookingCharge = currentData.object(forKey: "BookingCharge") as? String {
                        cell.lblBookingCharge.text = bookingCharge
                    }
                    
                    if let Tax = currentData.object(forKey: "Tax") as? String {
                        cell.lblTax.text = "\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!))"
                    }
                    
                    if let Discount = currentData.object(forKey: "Discount") as? String {
                        cell.lblDiscount.text = "\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                    }
                    
                    if let PaymentType = currentData.object(forKey: "PaymentType") as? String {
                        cell.lblPaymentType.text = PaymentType
                    }
                    
                    if let Total = currentData.object(forKey: "GrandTotal") as? String {
                        cell.lblTotal.text = Total
                        //                "\(String(format: "%.2f", Double((Total != "") ? Total : "0.0")!))"
                    }
                    
                    if let TripStatus = currentData.object(forKey: "Status") as? String {
                        cell.lblTripStatus.text = TripStatus
                    }
                    
                    cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                    CustomCell = cell
                }
                
                
            }
            
        }
        
        return CustomCell
        */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let cell = tableView.cellForRow(at: indexPath) as? PastBooingTableViewCell {
//            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
//            if cell.viewDetails.isHidden {
//                expandedCellPaths.remove(indexPath)
//            } else {
//                expandedCellPaths.insert(indexPath)
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            
//        } else if let cell = tableView.cellForRow(at: indexPath) as? CanceledBookingTableViewCell {
//            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
//            if cell.viewDetails.isHidden {
//                expandedCellPaths.remove(indexPath)
//            } else {
//                expandedCellPaths.insert(indexPath)
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            
//        }
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? PastBooingTableViewCell
        {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden
            {
                expandedCellPaths.remove(indexPath)
            }
            else
            {
                expandedCellPaths.insert(indexPath)
                let dictData = self.aryData[indexPath.row]
                if let ParcelArray = dictData["parcel_info"] as? [[String:Any]]
                {
                    cell.arrParcel = ParcelArray
                    cell.setParcelDetail()
                }
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        } else if let cell = tableView.cellForRow(at: indexPath) as? CanceledBookingTableViewCell {
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
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func Tips(sender: UIButton)
    {
//        let Index = sender.tag
//        let currentData = (aryData.object(at:Index) as! NSDictionary)
//        //            cell.lblDriverName.text = ""
//
//        if let BookingId = currentData.object(forKey: "Id") as? String, let BookingType = currentData.object(forKey: "BookingType") as? String  {
//           self.DelegateForTip.didOpenTipViewController(BookingId: BookingId, BookingType: BookingType)
//        }
        
    }
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    func setTimeStampToDateForPickup(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func webserviceOfPastbookingpagination(index: Int)
    {
        /*
        let driverId = SingletonClass.sharedInstance.strPassengerID //+ "/" + "\(index)"

        webserviceForPastBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
            if (status) {
                DispatchQueue.main.async {
                    
                    let tempPastData = (result as! [String:Any])["history"] as! [[String:Any]]

                    
                    for i in 0..<tempPastData.count {
                        
                        let dataOfAry = tempPastData[i]
                        
                        let strHistoryType = dataOfAry["HistoryType"] as? String
                        
                        if strHistoryType == "Past" {
                            self.aryData.append(dataOfAry)
                        }
                    }
                    if self.aryData.count > 0 {
                        self.lblNoDataFound.isHidden = true
                    } else {
                        self.lblNoDataFound.isHidden = false
                    }
                    
//                    if(self.aryData.count == 0) {
////                        self.labelNoData.text = "No data found."
////                        self.tableView.isHidden = true
//                    }
//                    else {
////                        self.labelNoData.removeFromSuperview()
//                        self.tableView.isHidden = false
//                    }
                    
                    //                    self.getPostJobs()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                    UtilityClass.hideACProgressHUD()
                }
            }
            else {
//                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
            }

        }
        */
    }
    
    @objc func getPastBookingHistory(){
        
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        
        webserviceForPastBookingList(SingletonClass.sharedInstance.strPassengerID as AnyObject , PageNumber: self.PageNumber as AnyObject, completion: { (result, status) in
            if (status) {
                
                let arrHistory = (result as! [String:Any])["history"] as! [[String:Any]]
                if arrHistory.count == 10 {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.aryData.count == 0 {
                    self.aryData = arrHistory
                } else {
                    self.aryData.append(contentsOf: arrHistory)
                }
             
                self.reloadTableView()
                
                //                if self.LoaderBackView.isHidden == false {
                //                    self.ActivityIndicator.stopAnimating()
                //                    self.LoaderBackView.isHidden = true
                //                }
                
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
            }
        })
    }
    
    var isDataLoading:Bool=false
    var pageNo:Int = 1
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.NeedToReload == true && indexPath.row == self.aryData.count - 1  {
            self.reloadMoreHistory()
        }
//        if indexPath.row == (self.aryData.count - 5) {
//            if !isDataLoading{
//                isDataLoading = true
//                self.pageNo = self.pageNo + 1
//                webserviceOfPastbookingpagination(index: self.pageNo)
//            }
//        }
    }
    

}


extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: fontSize)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

//
//  PastBooingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit



class PastBooingTableViewCell: UITableViewCell
{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    //Title
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblBookingDate: UILabel!
    
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupTimeTitle: UILabel!
    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblDistanceTravelledTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
//    @IBOutlet weak var lblNightFareTitle: UILabel!
      @IBOutlet weak var lblParcelTypeTitle: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
//    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblWeightCostTitle: UILabel!
//    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
//    @IBOutlet weak var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblParcelWeightTitle: UILabel!
    @IBOutlet weak var lblParcelWeight: UILabel!

    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    
    @IBOutlet weak var btnTips: ThemeButton!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    
    //    @IBOutlet weak var lblPromoApplied: UILabel!
    //    @IBOutlet weak var lblLessTitle: UILabel!
    
    @IBOutlet weak var lblPickupAddress: UILabel! // Pickup Address is PickupAddress
    @IBOutlet weak var lblDropoffAddress: UILabel!  // DropOff Address is PickupAddress
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    
    //    @IBOutlet weak var stackViewPickupTime: UIStackView!
    //    @IBOutlet weak var stackViewDropoffTime: UIStackView!
    //    @IBOutlet weak var stackViewVehicleType: UIStackView!
    
    
    // Value
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropoffTime: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblDeliveryDurationTitle: UILabel!
    @IBOutlet weak var lblDeliveryDuration: UILabel!

    @IBOutlet weak var lblTripFare: UILabel!
//    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblParcelType: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblWeightCharge: UILabel!

//    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!

    @IBOutlet var lblBookingCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    
    
    
    ///
    
    
    
    
    
    
    
    //    @IBOutlet var lblTip: UILabel!
    //    @IBOutlet weak var lblPromoCode: UILabel!
    //    @IBOutlet weak var lblTax: UILabel!
    //    @IBOutlet weak var lblDiscount: UILabel!
    
    //    @IBOutlet weak var stackViewDistanceTravelled: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewTripFare: UIStackView!
    ////    @IBOutlet weak var lblTripFare: UILabel!
    //
    //    @IBOutlet weak var stackViewNightFare: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewTollFee: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewWaitingCost: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewBookingCharge: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewTax: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewDiscount: UIStackView!
    //
    //
    //    @IBOutlet weak var stackViewPaymentType: UIStackView!
    //
    //    @IBOutlet weak var stackViewTotalCost: UIStackView!
    
    @IBOutlet var imgParcelImage: UIImageView!
    @IBOutlet var imgDeliveredParcelImage: UIImageView!
    
    @IBOutlet var ViewParcelImage: UIView!
    @IBOutlet var ViewDeliveredParcelImage: UIView!
    
    @IBOutlet var ParcelTableView: UITableView!
    
    @IBOutlet var lblParcelPriceTitle: UILabel!
    @IBOutlet var lblParcelPriceValue: UILabel!
    
    @IBOutlet var tblHeightConstraint: NSLayoutConstraint!
    
    var arrParcel:[[String:Any]] = []
    
    func setParcelDetail() {
        ParcelTableView.dataSource = self
        ParcelTableView.delegate = self
        ParcelTableView.reloadData()
        ParcelTableView.layoutIfNeeded()
        DispatchQueue.main.async {
            self.tblHeightConstraint.constant = self.ParcelTableView.contentSize.height
        }
    }
}
//MARK:- UITableView Datasource & Delegate Methods

extension PastBooingTableViewCell : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrParcel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ParcelCell = self.ParcelTableView.dequeueReusableCell(withIdentifier: "ParcelTblCell", for: indexPath) as! ParcelTblCell
        let parcelData = self.arrParcel[indexPath.row]
        ParcelCell.lblParcelSizeTitle.text = "PARCEL SIZE"
        if let ParcelSize = parcelData["ParcelSize"] as? String {
            if(ParcelSize.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
            {
                ParcelCell.lblParcelSizeValue.text = "-"
            }
            else
            {
                ParcelCell.lblParcelSizeValue.text = ParcelSize
            }
        }
        
        ParcelCell.lblParcelWeightTitle.text = "PARCEL WEIGHT"
        if let ParcelWeight = parcelData["ParcelWeight"] as? String {
            if(ParcelWeight.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
            {
                ParcelCell.lblParcelWeightValue.text = "-"
            }
            else
            {
                ParcelCell.lblParcelWeightValue.text = ParcelWeight
            }
        }
        
        ParcelCell.lblParcelPriceTitle.text = "PARCEL PRICE"
        if let ParcelPrice = parcelData["ParcelPrice"] as? String {
            ParcelCell.lblParcelPriceValue.text = ParcelPrice
        }
        
        ParcelCell.lblParcelTypeTitle.text = "PARCEL TYPE"
        if let ParcelType = parcelData["ParcelType"] as? String {
            ParcelCell.lblParcelTypeValue.text = ParcelType
        }
        
        return ParcelCell
    }
}
    /*
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    //Title
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupTimeTitle: UILabel!
    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblDistanceTravelledTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
 
    @IBOutlet weak var btnTips: ThemeButton!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    
//    @IBOutlet weak var lblPromoApplied: UILabel!
//    @IBOutlet weak var lblLessTitle: UILabel!

    @IBOutlet weak var lblPickupAddress: UILabel! // Pickup Address is PickupAddress
    @IBOutlet weak var lblDropoffAddress: UILabel!  // DropOff Address is PickupAddress
    @IBOutlet weak var lblDateAndTime: UILabel!


//    @IBOutlet weak var stackViewPickupTime: UIStackView!
//    @IBOutlet weak var stackViewDropoffTime: UIStackView!
//    @IBOutlet weak var stackViewVehicleType: UIStackView!
    
    
    // Value
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropoffTime: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet var lblBookingCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!


//    @IBOutlet var lblTip: UILabel!
//    @IBOutlet weak var lblPromoCode: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
//    @IBOutlet weak var lblDiscount: UILabel!
   
//    @IBOutlet weak var stackViewDistanceTravelled: UIStackView!
//
//
//    @IBOutlet weak var stackViewTripFare: UIStackView!
////    @IBOutlet weak var lblTripFare: UILabel!
//
//    @IBOutlet weak var stackViewNightFare: UIStackView!
//
//
//    @IBOutlet weak var stackViewTollFee: UIStackView!
//
//
//    @IBOutlet weak var stackViewWaitingCost: UIStackView!
//
//
//    @IBOutlet weak var stackViewBookingCharge: UIStackView!
//
//
//    @IBOutlet weak var stackViewTax: UIStackView!
//
//
//    @IBOutlet weak var stackViewDiscount: UIStackView!
//
//
//    @IBOutlet weak var stackViewPaymentType: UIStackView!
//
//    @IBOutlet weak var stackViewTotalCost: UIStackView!
  
    */

class ParcelTblCell: UITableViewCell {
    
    @IBOutlet var lblParcelSizeTitle: UILabel!
    @IBOutlet var lblParcelSizeValue: UILabel!
    
    @IBOutlet var lblParcelWeightTitle: UILabel!
    @IBOutlet var lblParcelWeightValue: UILabel!
    
    @IBOutlet var lblParcelPriceTitle: UILabel!
    @IBOutlet var lblParcelPriceValue: UILabel!
    
    @IBOutlet var lblParcelTypeTitle: UILabel!
    @IBOutlet var lblParcelTypeValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

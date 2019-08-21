//
//  UpCommingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var btnCancelRequest: ThemeButton!
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    @IBOutlet var imgParcelImage: UIImageView!
    @IBOutlet var imgDeliveredParcelImage: UIImageView!
    
    @IBOutlet var ViewParcelImage: UIView!
    @IBOutlet var ViewDeliveredParcelImage: UIView!
    
    @IBOutlet var ParcelTableView: UITableView!
    
    @IBOutlet var lblParcelPriceTitle: UILabel!
    @IBOutlet var lblParcelPriceValue: UILabel!
    
    @IBOutlet var tblHeightConstraint: NSLayoutConstraint!
    
    ////
    
    @IBOutlet weak var lblParcelTypeTitle: UILabel!
    @IBOutlet weak var lblParcelWeightTitle: UILabel!
    
    @IBOutlet weak var lblParcelType: UILabel!
    @IBOutlet weak var lblParcelWeight: UILabel!
    
    
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
    
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!

    @IBOutlet weak var vwDeliveryFare: UIStackView!
    @IBOutlet weak var vwTax: UIStackView!
    @IBOutlet weak var vwTotal: UIStackView!
    
    ////
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

extension UpCommingTableViewCell : UITableViewDataSource, UITableViewDelegate  {
    
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

//
//  CanceledBookingTableViewCell.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 13/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class CanceledBookingTableViewCell: UITableViewCell {

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
//    =============
    @IBOutlet weak var lblParcelTypeTitle: UILabel!
    @IBOutlet weak var lblParcelWeightTitle: UILabel!
    @IBOutlet weak var lblDeliveryDistanceTitle: UILabel!
    @IBOutlet weak var lblDeliveryDurationTitle: UILabel!
    
    @IBOutlet weak var lblParcelType: UILabel!
    @IBOutlet weak var lblParcelWeight: UILabel!
    @IBOutlet weak var lblDeliveryDistance: UILabel!
    @IBOutlet weak var lblDeliveryDuration: UILabel!
    @IBOutlet weak var imgvwParcelImage: UIImageView!
/////////////
    
    
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!

    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

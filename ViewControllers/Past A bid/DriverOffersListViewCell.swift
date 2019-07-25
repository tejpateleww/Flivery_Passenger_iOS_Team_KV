//
//  DriverOffersListViewCell.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import Cosmos

class DriverOffersListViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var vwChat: UIView!
    @IBOutlet weak var vwAccept: UIView!
       @IBOutlet weak var lblAccepted: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
                imgProfile.layer.cornerRadius = imgProfile.frame.height/2
                imgProfile.clipsToBounds = true
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

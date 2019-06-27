//
//  PostABidViewController.swift
//  Flivery User
//
//  Created by Mayur iMac on 26/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class PostABidViewController: BaseViewController {

    @IBOutlet weak var txtShippersName: ACFloatingTextfield?
    @IBOutlet weak var txtPickUpLocation: UITextField?
    @IBOutlet weak var txtDropLocation: UITextField?
    @IBOutlet weak var txtBudget: ACFloatingTextfield?
    @IBOutlet weak var TxtDateAndTime: ACFloatingTextfield?
    @IBOutlet weak var txtWeight: ACFloatingTextfield?
    @IBOutlet weak var txtQuantity: ACFloatingTextfield?
    @IBOutlet weak var txtNotes: ACFloatingTextfield?
    @IBOutlet weak var txtVehicleType: ACFloatingTextfield?
    @IBOutlet weak var txtPayment: ACFloatingTextfield?

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSelectLuggage: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithMenuORBack(Title: "Post a Bid".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        setupButtonAndTextfield()

        // Do any additional setup after loading the view.
    }

    func setupButtonAndTextfield()
    {

        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height / 2
        btnSubmit.clipsToBounds = true
        btnSubmit.setTitle("Post a Bid".localized, for: .normal)

        let imageView = UIImageView(image: UIImage(named: "Title_logo"))
        imageView.frame = CGRect(x: 0, y: 5, width: 20 , height: 20)
        imageView.contentMode = .scaleAspectFit
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        paddingView.addSubview(imageView)
        txtVehicleType?.rightViewMode = .always
        txtVehicleType?.rightView = paddingView


    }


    @IBAction func selectImageForLuggage(_ sender: Any) {
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

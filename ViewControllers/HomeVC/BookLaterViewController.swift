//
//  BookLaterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces
import SDWebImage
import FormTextField
import ACFloatingTextfield_Swift
import IQKeyboardManagerSwift
import IQDropDownTextField
import MultiSlider
import SideMenuController

class CustomUITextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        return false
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
//    override func selectionRects(for range: UITextRange) -> [Any] {
//        return []
//    }
}

protocol isHaveCardFromBookLaterDelegate {
    
    func didHaveCards()
}

extension UIApplication {
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
}


class BookLaterViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, isHaveCardFromBookLaterDelegate, UITextFieldDelegate,GMSMapViewDelegate,IQDropDownTextFieldDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,didSelectPlace
{



    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    @IBOutlet weak var selectWeight: MultiSlider!
    var delegateBookLater : deleagateForBookTaxiLater!
    var mapView : GMSMapView?
    var pickerView = UIPickerView()
    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var boolIsSelectedNotes = Bool()
    var strCarName = String()
    @IBOutlet weak var lblWeight: UILabel!

    var strFullname = String()
    var strMobileNumber = String()
    var strEstimatedFare = String()
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    
    var strSelectedParcelID = String()
    var aryParcelTransport = [[String : AnyObject]]()
    
    var CardID = String()
    var paymentType = String()
    var NearByRegion:GMSCoordinateBounds!   //this nearByRegion Detail to get near by locations in suggestions
    var selector = WWCalendarTimeSelector.instantiate()
    var isOpenPlacePickerController:Bool = false
    
    var isRequestIsBookNow = Bool()
    var strSpecialRequest = String()
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var lblEstimatedFare: UILabel!
    @IBOutlet weak var txtTransportSesrvice: IQDropDownTextField!
    @IBOutlet weak var lblSelectTransportService: UILabel!
    @IBOutlet weak var viewSelectTransportService: UIView!
    @IBOutlet var lblapplyPromoTitle: UILabel!
    @IBOutlet var lblFlightnum: UILabel!
    @IBOutlet var btnhavePromoCode: UIButton!
    @IBOutlet var lblYouhaveToNotified: UILabel!
    @IBOutlet var lblSelectPaymentMethod: UILabel!
    @IBOutlet var lblNotes: UILabel!
    @IBOutlet weak var viewCalendar: UIView!
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()


        
        txtTransportSesrvice.delegate = self
        mapView = GMSMapView()
        mapView?.delegate = self
        txtSelectPaymentMethod.delegate = self
        txtDropOffLocation.delegate = self
        txtPickupLocation.delegate = self
        //        txtSelectPaymentMethod.text = "Cash"
        //        txtSelectPaymentMethod.isUserInteractionEnabled = false
        if isRequestIsBookNow {
            viewCalendar.isHidden = true
            self.setNavBarWithMenuORBack(Title: "Book Now".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
            //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
            self.navigationItem.title = "Book Now".localized
        } else {
            self.setNavBarWithMenuORBack(Title: "Book Later".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
            //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
            self.navigationItem.title = "Book Later".localized
        }


        let bounds = GMSCoordinateBounds()
        let latitude = SingletonClass.sharedInstance.currentLatitude
        let longitude =  SingletonClass.sharedInstance.currentLongitude
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:Double(latitude) ?? 00.00, longitude:Double(longitude) ?? 0.00)
        NearByRegion = bounds.includingCoordinate(marker.position)



        selectWeight.minimumValue = 1
        selectWeight.maximumValue = 1000
        selectWeight.value = [0.0]
        selectWeight.orientation = .horizontal // default is .vertical
        selectWeight.thumbCount = 1
        selectWeight.snapStepSize = 1 // default is 0.0, i.e. don't snap
        selectWeight.addTarget(self, action : #selector(sliderChanged(_:)), for: .valueChanged)

        selectWeight.tintColor = UIColor.red
        selectWeight.outerTrackColor = UIColor.black // outside of first and last thumbs
        lblWeight.text = "1Kgs"

        txtDropOffLocation.text = strDropoffLocation

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        txtFullName.leftView = paddingView
        txtFullName.leftViewMode = .always
        
        
        selector.delegate = self
        //        alertView.removeFromSuperview()
        
        //        btnForMySelfAction.addTarget(self, action: #selector(self.ActionForViewMySelf), for: .touchUpInside)
        //
        //        btnForOthersAction.addTarget(self, action: #selector(self.ActionForViewOther), for: .touchUpInside)
        
        viewProocode.isHidden = true
        btnRemovePromoCode.isHidden = true


        
        webserviceOfCardList()
        
        pickerView.delegate = self
        
        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        setViewDidLoad()
        
        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        let strCardLoca = "Car Model".localized
        lblCareModelClass.text = "\(strCardLoca): \(strCarName)"
        
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber
        self.lblEstimatedFare.text = "\(self.strEstimatedFare)"
        self.btnApply.backgroundColor = ThemeNaviBlueColor
        self.btnCancel.backgroundColor = UIColor.black
        
        checkMobileNumber()
        
        
        self.aryParcelTransport = SingletonClass.sharedInstance.aryParcelTransport
        let arrNameTransport = self.aryParcelTransport.map({$0["Name"] as! String})
        self.txtTransportSesrvice.itemList = arrNameTransport
        
        //        self.strSelectedParcelID = self.aryParcelTransport.first?["Id"] as? String ?? ""
        //        self.txtTransportSesrvice.selectedRow = 1

        
        webserviceOfGetEstimateFareForDeliveryService()
        btnUploadParcelPhoto.setTitle("Upload your parcel photo here".localized, for: .normal)
        #if targetEnvironment(simulator)
        //        btnUploadParcelPhoto.setImage(UIImage(named: "HeaderLogo"), for: .normal)
        //        btnUploadParcelPhoto.setTitle("", for: .normal)
        //        btnUploadParcelPhoto.imageView?.contentMode = .scaleAspectFit
        //            txtParcelWeight.text = "10"
        #endif


        
        
        //        (self.parent as! UINavigationController).childViewControllers.first as! HomeViewController
        
    }



    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isOpenPlacePickerController == false {


            gaveCornerRadius()

            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
                pickerView.reloadAllComponents()
                txtSelectPaymentMethod.text = ""
                paymentType = ""
                imgPaymentOption.image = UIImage(named: "iconDummyCard")
                //            paymentType = "Cash"
                pickerView.selectedRow(inComponent: 0)
                txtSelectPaymentMethod.becomeFirstResponder()
                txtSelectPaymentMethod.resignFirstResponder()

            }
            //
            //       txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
            //
            fillTextFields()
        }
        SideMenuController.preferences.interaction.panningEnabled = false
        SideMenuController.preferences.interaction.swipingEnabled = false
        self.isOpenPlacePickerController = false
        //        getPlaceFromLatLong()
    }


    func setLocalization()
    {
        self.lblMySelftitle.text = "Myself"
        self.lblOthersTitle.text = "Others"
        
        lblCareModelClass.text = "Car Model:".localized
        txtPickupLocation.placeholder = "Pickup Location".localized
        txtDropOffLocation.placeholder = "Dropoff Location".localized
        txtFullName.placeholder = "Full Name".localized
        txtMobileNumber.placeholder = "Phone Number".localized
        txtDataAndTimeFromCalendar.placeholder = "Click calendar icon to select pickup time".localized
        txtFlightNumber.placeholder = "Flight Number".localized
        lblFlightnum.text = "Flight Number (If applicable)".localized
        lblNotes.text = "Notes (Optional)".localized
        txtDescription.placeholder = "Notes".localized
        btnhavePromoCode.setTitle("Have a Promocode?".localized, for: .normal)
        lblSelectPaymentMethod.text = "Select Payment Type".localized
        txtSelectPaymentMethod.placeholder = "Select Payment Type".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        lblYouhaveToNotified.text =   ""
        
        btnhavePromoCode.setTitle("Have a Promocode?".localized, for: .normal)
        
        lblapplyPromoTitle.text = "Apply Promocode".localized
        txtPromoCode.placeholder = "Enter promocode here".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        btnUploadParcelPhoto.layer.cornerRadius = 3
        //        btnUploadParcelPhoto.layer.borderWidth = 1
        //        btnUploadParcelPhoto.layer.borderColor = UIColor.lightGray.cgColor
        //        btnUploadParcelPhoto.layer.masksToBounds = true
        
        cornerRadiusToView(tempView: btnUploadParcelPhoto, isRounded: false, corner: 3, border: 1, borderColor: UIColor.lightGray)
        
        if let img = UtilityClass.changeImageColor(imageView: btnCalendar.imageView!, imageName: "iconCalendar", color: ThemeYellowColor).image {
            btnCalendar.setImage(img, for: .normal)
        }
        //        btnRemovePromoCode.setImage(UIImage(named: "iconCloseAlert"), for: .normal)

        cornerRadiusToView(tempView: btnRemovePromoCode, isRounded: true ,corner: 0, border: 1, borderColor: UIColor.lightGray)
    }
    
    func cornerRadiusToView(tempView: UIView, isRounded: Bool ,corner: CGFloat, border: CGFloat, borderColor: UIColor) {
        
        if isRounded {
            tempView.layer.cornerRadius = tempView.frame.width / 2
        } else {
            tempView.layer.cornerRadius = corner
        }
        tempView.layer.borderWidth = border
        tempView.layer.borderColor = borderColor.cgColor
        tempView.layer.masksToBounds = true
    }
    
    func fillTextFields() {
        txtPickupLocation.text = strPickupLocation
        txtDropOffLocation.text = strDropoffLocation
    }
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
        if textField == self.txtTransportSesrvice {
            //            (result["percel"] as! [[String : AnyObject]]).filter({$0["Name"] as! String == "Junk removal"})
            
            let dictData = self.aryParcelTransport.filter({$0["Name"] as! String == item!})
            
            print(dictData)
            if dictData.count != 0 {
                if let selectID = dictData[0]["Id"] as? String {
                    self.strSelectedParcelID = selectID
                }
                print(self.strSelectedParcelID)
            }
        }
    }
    
    func gaveCornerRadius() {
        
        viewCurrentLocation.layer.cornerRadius = 5
        viewDestinationLocation.layer.cornerRadius = 5
        
        viewCurrentLocation.layer.borderWidth = 1
        viewDestinationLocation.layer.borderWidth = 1
        
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        
        viewCurrentLocation.layer.masksToBounds = true
        viewDestinationLocation.layer.masksToBounds = true
    }

    func setViewDidLoad() {
        
        //        let themeColor: UIColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
        
        viewMySelf.tintColor = ThemeNaviBlueColor
        viewOthers.tintColor = ThemeNaviBlueColor
        viewFlightNumber.tintColor = ThemeNaviBlueColor
        btnNotes.tintColor = ThemeNaviBlueColor
        
        
        viewMySelf.stateChangeAnimation = .fill
        viewOthers.stateChangeAnimation = .fill
        viewFlightNumber.stateChangeAnimation = .fill
        btnNotes.stateChangeAnimation = .fill
        
        viewMySelf.boxType = .square
        viewMySelf.checkState = .checked
        viewOthers.boxType = .square

        btnNotes.boxType = .square
        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        
        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
        constaintsOfTxtFlightNumber?.constant = 0
        imgViewLineForFlightNumberHeight.constant = 0
        
        constantHavePromoCodeTop?.constant = 0
        constantNoteHeight.constant = 0
        imgViewLineForFlightNumberHeight.constant = 0
        imgViewLineForNotesHeight.constant = 0
        
        txtFlightNumber.isHidden = true
        txtFlightNumber.isEnabled = false
        txtDescription.isEnabled = false
        //        alertView.layer.cornerRadius = 10
        //        alertView.layer.masksToBounds = true
        
        txtDataAndTimeFromCalendar.layer.borderWidth = 1
        txtDataAndTimeFromCalendar.layer.cornerRadius = 5
        txtDataAndTimeFromCalendar.layer.borderColor = UIColor.black.cgColor
        txtDataAndTimeFromCalendar.layer.masksToBounds = true
        
        viewPaymentMethod.layer.borderWidth = 1
        viewPaymentMethod.layer.cornerRadius = 5
        viewPaymentMethod.layer.borderColor = UIColor.black.cgColor
        viewPaymentMethod.layer.masksToBounds = true
        
        viewSelectTransportService.layer.borderWidth = 1
        viewSelectTransportService.layer.cornerRadius = 5
        viewSelectTransportService.layer.borderColor = UIColor.black.cgColor
        viewSelectTransportService.layer.masksToBounds = true
        
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
        
        //        viewCurrentLocation.layer.shadowOpacity = 0.3
        //        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //        viewDestinationLocation.layer.shadowOpacity = 0.3
        //        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewProocode: UIView!
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    @IBOutlet weak var viewMySelf: M13Checkbox!
    @IBOutlet weak var viewOthers: M13Checkbox!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblMySelf: UILabel?
    @IBOutlet weak var lblOthers: UILabel?
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!

    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    @IBOutlet weak var constaintsOfTxtFlightNumber: NSLayoutConstraint? // 10
    
    @IBOutlet weak var txtSelectPaymentMethod: CustomUITextField!
    @IBOutlet weak var imgPaymentOption: UIImageView!
    
    @IBOutlet weak var btnNotes: M13Checkbox!
    
    @IBOutlet weak var constantNoteHeight: NSLayoutConstraint!  // 40
    
    @IBOutlet weak var constantHavePromoCodeTop: NSLayoutConstraint?  // 10
    
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    var BackView = UIView()
    
    @IBOutlet weak var btnForMySelfAction: UIButton!
    @IBOutlet weak var btnForOthersAction: UIButton!
    @IBOutlet weak var lblMySelftitle: UILabel!
    @IBOutlet weak var lblOthersTitle: UILabel!
    
    
    @IBOutlet weak var imgViewLineForFlightNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewLineForNotesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUploadParcelPhoto: UIButton!
    //    @IBOutlet weak var txtParcelWeight: UITextField!
    @IBOutlet weak var btnRemovePromoCode: UIButton!
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnApply(_ sender: UIButton) {
        
        UIView.transition(with: self.viewProocode, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewProocode.isHidden = true
        }) { _ in
            self.lblPromoCode.text = self.txtPromoCode.text
            
            self.btnRemovePromoCode.isHidden = false
            if (self.lblPromoCode.text?.isEmpty)! {
                self.btnRemovePromoCode.isHidden = true
            }
        }
        

        //
        //        let strPromo = txtPromoCode.text
        //        //        let strFinalPromo = "\(strPromo!)/\(SingletonClass.sharedInstance.strEstimatedFare)"
        //        //        self.strAppliedPromoCode = strPromo!
        //
        //        var dictData = [String : AnyObject]()
        //        dictData["PromoCode"] = strPromo as AnyObject
        //        if !(UtilityClass.isEmpty(str: strPromo))
        //        {
        //            webserviceForValidPromocode(dictData as AnyObject, showHUD: true) { (result, status) in
        //
        //                if status
        //                {
        //                    print(result)
        //
        //                    UIView.transition(with: self.viewProocode, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
        //                        self.viewProocode.isHidden = true
        //                    }) { _ in
        //                         self.lblPromoCode.text = self.txtPromoCode.text
        //                    }
        //
        ////                    self.viewProocode.isHidden = true
        //
        ////                    let strNewAmount = result["new_estimate_fare"] as! String
        ////                    let text = "Estimated Fare is $\(SingletonClass.sharedInstance.strEstimatedFare)   $\(strNewAmount)"
        ////                    let range = (text as NSString).range(of: "$\(SingletonClass.sharedInstance.strEstimatedFare)")
        ////                    let attributedString1 = NSMutableAttributedString(string:text)
        ////                    attributedString1.addAttributes([NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue], range: range)
        ////                    self.lblEstimatedFare.attributedText = attributedString1
        ////
        ////                    let dict =  result["promocode"] as! NSDictionary
        ////
        ////                    self.strPromoCodeDiscountType = dict.object(forKey: "DiscountType") as! String
        ////                    self.strPromoCodeDiscountValue = "\((dict.object(forKey: "DiscountValue")!))"
        //
        //
        //
        //                }
        //                else
        //                {
        //                    print(result)
        //
        //                    if let res = result as? String
        //                    {
        //                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                            if SelectedLanguage == "en"
        //                            {
        //                                UtilityClass.showAlert("Error", message: res, vc: self)
        //
        //                            }
        //                            else if SelectedLanguage == secondLanguage // "sw"
        //                            {
        //                                UtilityClass.showAlert("Error", message: res, vc: self)
        //                            }
        //                        }
        //                    }
        //                    else if let resDict = result as? NSDictionary
        //                    {
        //
        //
        //                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                            if SelectedLanguage == "en"
        //                            {
        //                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "message") as! String, vc: self)
        //
        //                            }
        //                            else if SelectedLanguage == secondLanguage // "sw"
        //                            {
        //                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "swahili_message") as! String, vc: self)
        //                            }
        //                        }
        //                    }
        //                    else if let resAry = result as? NSArray
        //                    {
        //
        //                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                            if SelectedLanguage == "en"
        //                            {
        //                               UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
        //
        //                            }
        //                            else if SelectedLanguage == secondLanguage // "sw"
        //                            {
        //                                UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
    }
    
    @IBAction func btnRemovePromocode(_ sender: UIButton) {
        
        self.lblPromoCode.text = ""
        self.txtPromoCode.text = ""
        btnRemovePromoCode.isHidden = true
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        UIView.transition(with: self.viewProocode, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewProocode.isHidden = true
        }) { _ in }
        
        txtPromoCode.text = ""
        //        self.view.alpha = 1.0
        //        BackView.removeFromSuperview()
        //        alertView.removeFromSuperview()
    }
    
    @IBAction func btnHavePromoCode(_ sender: UIButton) {
        
        UIView.transition(with: self.viewProocode, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewProocode.isHidden = false
        }) { _ in
            self.txtPromoCode.becomeFirstResponder()
        }

        //        viewProocode.isHidden = false
        
        //        UIApplication.shared.keyWindow!.bringSubview(toFront: alertView)
    }

    @IBAction func weightChanged(_ sender: MultiSlider) {

    }

    @objc func sliderChanged(_ slider: MultiSlider) {

        self.lblWeight.text = "\(slider.value.first ?? 0.00) Kgs"

        print("\(slider.value)")
    }

    @IBAction func btnNotes(_ sender: M13Checkbox) {
        
        boolIsSelectedNotes = !boolIsSelectedNotes
        
        if (boolIsSelectedNotes) {
            
            constantNoteHeight.constant = 40
            constantHavePromoCodeTop?.constant = 10
            imgViewLineForNotesHeight.constant = 1
            //            txtSelectPaymentMethod.isHidden = false
            txtDescription.isEnabled = true
        }
        else {
            
            constantNoteHeight.constant = 0
            constantHavePromoCodeTop?.constant = 0
            imgViewLineForNotesHeight.constant = 0
            //            txtSelectPaymentMethod.isHidden = true
            txtDescription.isEnabled = false
        }
    }
    @IBOutlet weak var btnTypeSignature : UIButton!
    @IBOutlet weak var btnTypeImage : UIButton!
    
    var confirmationType = "signature"{
        didSet{
            btnTypeSignature.isSelected = confirmationType == "signature"
            btnTypeImage.isSelected = confirmationType == "image"
        }
    }
    @IBAction func btnSignature(_ sender: UIButton) {
        confirmationType = "signature"
    }
    
    @IBAction func btnImage(_ sender: UIButton) {
        confirmationType = "image"
    }
    
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //    @IBAction func viewMySelf(_ sender: M13Checkbox) {
    //
    //        ActionForViewMySelf()
    //
    //    }
    
    @IBAction func btnMySelfAction(_ sender: Any) {
        ActionForViewMySelf()
    }
    
    @IBAction func btnOtherAction(_ sender: Any) {
        ActionForViewOther()
    }
    
    @objc func ActionForViewMySelf() {
        
        viewMySelf.checkState = .checked
        viewOthers.checkState = .unchecked
        viewMySelf.stateChangeAnimation = .fill

        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber

        strPassengerType = "myself"
    }

    
    @objc func ActionForViewOther() {
        viewMySelf.checkState = .unchecked
        viewOthers.checkState = .checked
        viewOthers.stateChangeAnimation = .fill

        txtFullName.text = ""
        txtMobileNumber.text = ""

        strPassengerType = "other"
    }
    
    //    @IBAction func viewOthers(_ sender: M13Checkbox) {
    //        ActionForViewOther()
    //
    //    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            
            constraintsHeightOFtxtFlightNumber.constant = 40
            constaintsOfTxtFlightNumber?.constant = 10
            imgViewLineForFlightNumberHeight.constant = 1
            txtFlightNumber.isHidden = false
            txtFlightNumber.isEnabled = true
        }
        else {
            
            constraintsHeightOFtxtFlightNumber.constant = 0
            constaintsOfTxtFlightNumber?.constant = 0
            imgViewLineForFlightNumberHeight.constant = 0
            txtFlightNumber.isHidden = true
            txtFlightNumber.isEnabled = false
        }
    }
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {
        
        //        let visibleRegion = mapView?.projection.visibleRegion()
        //        var location = CLLocationCoordinate2D()
        //        if SingletonClass.sharedInstance.currentLatitude != nil
        //        {
        //            location = CLLocationCoordinate2DMake(Double(SingletonClass.sharedInstance.currentLatitude)!, Double(SingletonClass.sharedInstance.currentLongitude)!)
        //        }
        
        //        //        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        //        self.isOpenPlacePickerController = true
        //        let acController = GMSAutocompleteViewController()
        //        acController.delegate = self
        //        acController.autocompleteBounds = NearByRegion
        self.isOpenPlacePickerController = true
        BoolCurrentLocation = true
        //        present(acController, animated: true, completion: nil)
        self.performSegue(withIdentifier: "presentPlacePicker", sender: nil)

    }
    
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        

        //        let visibleRegion = mapView?.projection.visibleRegion()
        //        var location = CLLocationCoordinate2D()
        //        if SingletonClass.sharedInstance.currentLatitude != nil
        //        {
        //            location = CLLocationCoordinate2DMake(Double(SingletonClass.sharedInstance.currentLatitude)!, Double(SingletonClass.sharedInstance.currentLongitude)!)
        //        }
        //
        //        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        self.isOpenPlacePickerController = true
        //        let acController = GMSAutocompleteViewController()
        //        acController.delegate = self
        //        acController.autocompleteBounds = NearByRegion
        BoolCurrentLocation = false
        self.performSegue(withIdentifier: "presentPlacePicker", sender: nil)
        //        present(acController, animated: true, completion: nil)

    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        
        selector.optionCalendarFontColorPastDates = UIColor.gray

        selector.optionButtonFontColorDone = ThemeNaviBlueColor
        selector.optionSelectorPanelBackgroundColor = ThemeNaviBlueColor
        selector.optionCalendarBackgroundColorTodayHighlight = ThemeNaviBlueColor
        selector.optionTopPanelBackgroundColor = ThemeNaviBlueColor
        selector.optionClockBackgroundColorMinuteHighlightNeedle = ThemeNaviBlueColor
        selector.optionClockBackgroundColorHourHighlight = ThemeNaviBlueColor
        selector.optionClockBackgroundColorAMPMHighlight = ThemeNaviBlueColor
        selector.optionCalendarBackgroundColorPastDatesHighlight = ThemeNaviBlueColor
        selector.optionCalendarBackgroundColorFutureDatesHighlight = ThemeNaviBlueColor
        selector.optionClockBackgroundColorMinuteHighlight = ThemeNaviBlueColor
        
        
        
        //        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showYear(false)
        //        selector.optionStyles.showMonth(true)
        
        selector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options

        selector.optionTopPanelTitle = "Please choose date"
        
        selector.optionIdentifier = "Time" as AnyObject

        let dateCurrent = Date()


        selector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)

        // 3. Then you simply present it from your view controller when necessary!
        //        self.present(selector, animated: true, completion: nil)
        //        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(selector, animated: true, completion: nil)

        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(selector, animated: true, completion: nil)
        
    }
    
    @IBAction func btnUploadParcelPhoto(_ sender: UIButton) {
        
        let alert = UIAlertController(title: appName, message: "Choose image from", preferredStyle: .actionSheet)
        
        let Camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.PickingImageFromCamera()
        }
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.PickingImageFromGallery()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func PickingImageFromGallery() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        // picker.stopVideoCapture()
        picker.mediaTypes = [kUTTypeImage as String]
        shouldLocalize = false
        //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        shouldLocalize = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.isOpenPlacePickerController = true
        shouldLocalize = true
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            btnUploadParcelPhoto.imageView?.contentMode = .scaleAspectFill
            btnUploadParcelPhoto.imageView?.clipsToBounds = true
            //            imgProfile.image = pickedImage
            //            self.imgUpdatedProfilePic = pickedImage
            btnUploadParcelPhoto.setImage(pickedImage, for: .normal)
            btnUploadParcelPhoto.setTitle("", for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isOpenPlacePickerController = true
        shouldLocalize = true
        dismiss(animated: true, completion: nil)
    }
    
    func validation() -> Bool {
        
        if txtFullName.text == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please enter full name") { (index, title) in }
            return false
        } else if txtMobileNumber.text == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please enter mobile number") { (index, title) in }
            return false
        } else if txtPickupLocation.text == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please enter pick up location") { (index, title) in }
            return false
        } else if txtDropOffLocation.text == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please enter drop off location") { (index, title) in }
            return false
        } else if strSelectedParcelID == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please select parcel") { (index, title) in }
            return false
        }
            //        else if txtParcelWeight.text == "" {
            //            UtilityClass.setCustomAlert(title: "", message: "Please enter parcel weight") { (index, title) in }
            //            return false
            //        }
        else if btnUploadParcelPhoto.imageView?.image == nil {
            UtilityClass.setCustomAlert(title: "", message: "Please insert parcel image") { (index, title) in }
            return false
        }
        else if !isRequestIsBookNow {
            if (txtDataAndTimeFromCalendar.text?.isEmpty)! {
                UtilityClass.setCustomAlert(title: "", message: "Please select date and time") { (index, title) in }
                return false
            }
        }
        else if paymentType == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please select payment type") { (index, title) in }
            return false
        }
        
        return true
    }



    func validationForBooklater() -> Bool {

        if txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            UtilityClass.setCustomAlert(title: "", message: "Please enter full name") { (index, title) in }
            return false
        } else if txtMobileNumber.text == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please enter mobile number") { (index, title) in }
            return false
        } else if txtPickupLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            UtilityClass.setCustomAlert(title: "", message: "Please enter pick up location") { (index, title) in }
            return false
        } else if txtDropOffLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            UtilityClass.setCustomAlert(title: "", message: "Please enter drop off location") { (index, title) in }
            return false
        } else if strSelectedParcelID.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            UtilityClass.setCustomAlert(title: "", message: "Please select parcel") { (index, title) in }
            return false
        }
            //        else if txtParcelWeight.text == "" {
            //            UtilityClass.setCustomAlert(title: "", message: "Please enter parcel weight") { (index, title) in }
            //            return false
            //        }
        else if btnUploadParcelPhoto.imageView?.image == nil {
            UtilityClass.setCustomAlert(title: "", message: "Please insert parcel image") { (index, title) in }
            return false
        }
        else if !isRequestIsBookNow {
            if (txtDataAndTimeFromCalendar.text?.isEmpty)! {
                UtilityClass.setCustomAlert(title: "", message: "Please select date and time") { (index, title) in }
                return false
            }
        }
        else if paymentType == "" {
            UtilityClass.setCustomAlert(title: "", message: "Please select payment type") { (index, title) in }
            return false
        }

        return true
    }
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
        
        if isRequestIsBookNow {
            
            if validation() {
                webserviceForBookNow()
            }
        } else {


            if validationForBooklater() == false{
                
//                UtilityClass.setCustomAlert(title: "", message: "All fields are required...".localized) { (index, title) in
//                }
            }
                //        else if viewMySelf.checkState == .unchecked && viewOthers.checkState == .unchecked {
                //
                //
                //            UtilityClass.setCustomAlert(title: "", message: "Please Checked Myself or Other") { (index, title) in
                //            }
                //        }
            else {
                webserviceOFBookLater()
            }
        }
        
    }
    
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    
    func checkMobileNumber() {
        
        txtMobileNumber.inputType = .integer
        
        //        var validation = Validation()
        validationsMobileNumber.maximumLength = 10
        validationsMobileNumber.minimumLength = 10
        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validationsMobileNumber)
        txtMobileNumber.inputValidator = inputValidator
        
        print("txtMobileNumber : \(txtMobileNumber.text!)")
    }
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    func didSelectPlaceFromPlacePicker(place: GMSPlace) {
        if BoolCurrentLocation {
            txtPickupLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude

        }
        else {
            txtDropOffLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }

        if !(txtPickupLocation.text?.isEmpty)! && !(txtDropOffLocation.text?.isEmpty)! {
            webserviceOfGetEstimateFareForDeliveryService()
        }
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if BoolCurrentLocation {
            txtPickupLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else {
            txtDropOffLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        
        if !(txtPickupLocation.text?.isEmpty)! && !(txtDropOffLocation.text?.isEmpty)! {
            webserviceOfGetEstimateFareForDeliveryService()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtDropOffLocation {
            
            self.txtDropOffLocation(txtDropOffLocation)
            return false
        } else if textField == txtPickupLocation {
            
            self.txtPickupLocation(txtPickupLocation)
            return false
        }
        return true
    }
    
    func getPlaceFromLatLong() {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.txtPickupLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.strPickupLocation = place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtPickupLocation.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    func setCardIcon(str: String) -> String {
        //        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
    }
    
    func didHaveCards() {
        
        aryCards.removeAll()
        webserviceOfCardList()
    }
    
    @objc func IQKeyboardmanagerDoneMethod() {
        
        if (isAddCardSelected) {
            self.addNewCard()
        }
        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCards[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let centerOfmyView = myView.frame.size.height / 4

        
        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
        myImageView.contentMode = .scaleAspectFit
        
        var rowString = String()
        
        switch row {
            
        case 0:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data = aryCards[row]
        
        imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        txtSelectPaymentMethod.text = data["CardNum2"] as? String
        
        if data["CardNum"] as! String == "Add a Card" {
            
            isAddCardSelected = true
            //            self.addNewCard()
        }
        
        let type = data["CardNum"] as! String
        
        if type  == "wallet" {
            paymentType = "wallet"
        }
        else if type == "Cash" {
            paymentType = "Cash"
        }
        else {
            paymentType = "card"
        }
        
        if paymentType == "card" {
            
            if data["Id"] as? String != "" {
                CardID = data["Id"] as! String
            }
        }
    }
    
    func addNewCard() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Calendar Method
    //-------------------------------------------------------------
    
    var currentDate = Date()
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {

        if currentDate < date {
            
            //            let calendarDate = Calendar.current
            //            let hour = calendarDate.component(.hour, from: date)
            //            let minutes = calendarDate.component(.minute, from: date)

            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
                
                let myDateFormatter: DateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                
                let dateOfPostToApi: DateFormatter = DateFormatter()
                dateOfPostToApi.dateFormat = "yyyy-MM-dd HH:mm:ss"

                convertDateToString = dateOfPostToApi.string(from: date)
                
                let finalDate = myDateFormatter.string(from: date)
                
                // get the date string applied date format
                let mySelectedDate = String(describing: finalDate)
                
                txtDataAndTimeFromCalendar.text = mySelectedDate
            }
            else {
                
                txtDataAndTimeFromCalendar.text = ""
                
                UtilityClass.setCustomAlert(title: "Time should be", message: "Please select 30 minutes greater time from current time!") { (index, title) in
                }
            }
        }
    }
    
    func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector) {
    }
    
    func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector) {        
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        
        if currentDate < date {

            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
                return true
            }
            return false
        }
        return false
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber,
    //PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    func webserviceOFBookLater() {
        
        var dictData = [String:AnyObject]()
        dictData["DeliveredParcelImageType"] = confirmationType as AnyObject
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        dictData["ParcelId"] = self.strSelectedParcelID as AnyObject
        dictData["RequestFor"] = "delivery" as AnyObject

        let strWeight = lblWeight.text?.replacingOccurrences(of: "Kgs", with: "", options: NSString.CompareOptions.literal, range: nil)
        dictData["Weight"] = strWeight?.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject

        if lblPromoCode.text != "" {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        
        dictData["Notes"] = txtDescription.text as AnyObject

        if paymentType == "" {
            UtilityClass.setCustomAlert(title: "", message: "Select Payment Type") { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID != "" {
            dictData["CardId"] = CardID as AnyObject
        }

        if txtFlightNumber.text!.count == 0 {
            dictData["FlightNumber"] = "" as AnyObject
        } else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        let parcelImage = btnUploadParcelPhoto.imageView?.image
        
        webserviceForBookLater(dictData as AnyObject, image: parcelImage ?? UIImage()) { (result, status) in
            
            if (status) {
                print(result)

                //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your ride has been booked.".localized, completionHandler: { (index, title) in
                //                    self.delegateBookLater.btnRequestLater()
                //                    self.navigationController?.popViewController(animated: true)
                //                })
                
                let alert = UIAlertController(title: "\(appName)", message: "Your ride has been booked.".localized, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.delegateBookLater.btnRequestLater()
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(ok)
                UtilityClass.presentPopupOverScreen(alert)
                
                
                /*
                 {
                 info =     {
                 BookingFee = "2.2";
                 Duration = 27;
                 EstimatedFare = "43.28";
                 GrandTotal = "45.48";
                 Id = 1;
                 KM = "9.6";
                 SubTotal = "43.28";
                 Tax = "4.548";
                 };
                 status = 1;
                 }
                 */
            } else {
                print(result)

                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "Cash" as AnyObject
                dict["CardNum2"] = "Cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                //                var dict2 = [String:AnyObject]()
                //                dict2["CardNum"] = "wallet" as AnyObject
                //                dict2["CardNum2"] = "wallet" as AnyObject
                //                dict2["Type"] = "iconWalletBlack" as AnyObject
                //
                //
                self.aryCards.append(dict)
                //                self.aryCards.append(dict2)
                //
                //                if self.aryCards.count == 2 {
                //                    var dict3 = [String:AnyObject]()
                //                    dict3["Id"] = "000" as AnyObject
                //                    dict3["CardNum"] = "Add a Card" as AnyObject
                //                    dict3["CardNum2"] = "Add a Card" as AnyObject
                //                    dict3["Type"] = "iconPlusBlack" as AnyObject
                //                    self.aryCards.append(dict3)
                //
                //                }
                //
                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]

                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String

                let type = data["CardNum"] as! String
                //
                //                if type  == "wallet" {
                //                    self.paymentType = "wallet"
                //                }
                //                else
                
                if type == "Cash" {
                    self.paymentType = "Cash"
                } else {
                    self.paymentType = "card"
                }
                
                if self.paymentType == "card" {

                    if data["Id"] as? String != "" {
                        self.CardID = data["Id"] as! String
                    }
                }
                //                 self.paymentType = "Cash"
                self.pickerView.reloadAllComponents()

                /*
                 {
                 cards =     (
                 {
                 Alias = visa;
                 CardNum = 4639251002213023;
                 CardNum2 = "xxxx xxxx xxxx 3023";
                 Id = 59;
                 Type = visa;
                 }
                 );
                 status = 1;
                 }
                 */


            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnClearCurrentLocation(_ sender: UIButton) {
        txtPickupLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDropOffLocation.text = ""
    }
    
    func webserviceForTransportserviceList()
    {
        webserviceForTransportService("" as AnyObject) { (result, status) in
            if status
            {
                print(result)
                //                self.aryParcelTransport = (result["percel"] as? [[String : AnyObject]])!
                //                guard (result["percel"] as? [[String : AnyObject]]) != nil else {
                //                    return
                //                }

                guard let arrTemp = result["percel"] as? [[String : AnyObject]] else {
                    return
                }
                
                self.aryParcelTransport = arrTemp
                let arrNameTransport = self.aryParcelTransport.map({$0["Name"] as! String})
                
                self.txtTransportSesrvice.itemList = arrNameTransport
                
                //                self.strSelectedParcelID = self.aryParcelTransport.first?["Id"] as? String ?? ""
                //                self.txtTransportSesrvice.selectedRow = 2
                
                //(result["percel"] as! [[String : AnyObject]]).map({$0["Name"] as! String}) get all name
                //(result["percel"] as! [[String : AnyObject]]).filter({$0["Name"] as! String == "Junk removal"}) //
                //                CreatedDate = "2019-03-26 00:00:00";
                //                Height = 5;
                //                Id = 7;
                //                Image = "http://34.73.215.81/web/images/model/other.png";
                //                Name = Others;
                //                Status = 1;
                //                Weight = 10;
                //                Width = 3;
            }
            else
            {
                print(result)
            }
        }
    }
    
    func webserviceOfGetEstimateFareForDeliveryService() {
        
        var param = [String:Any]()
        param["PickupLocation"] = strPickupLocation
        param["DropoffLocation"] = strDropoffLocation
        param["ModelId"] = strModelId
        //        param["Labour"] = strLabourId
        
        webserviceForGetEstimateFareForDeliveryService(param as AnyObject) { (result, status) in
            
            if (status) {
                
                if let res = result as? [String:Any] {
                    if let estimateFare = res["estimate_fare"] as? [String:Any] {
                        
                        self.lblEstimatedFare.text = currencySign + " " + "\(estimateFare["total"] ?? "")"
                        
                        //                        if let totalInt = estimateFare["total"] as? Int {
                        //                            self.lblEstimatedFare.text = "\(currencySign) \(totalInt)"
                        //                        }
                        //                        else if let totalString = estimateFare["total"] as? String {
                        //                            self.lblEstimatedFare.text = currencySign + " " + totalString
                        //                        }
                    }
                }
            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func webserviceForBookNow() {
        
        var dictData = [String:AnyObject]()
        
        //        {, , , , , , , Special=, , , , , , , , }
        dictData["DeliveredParcelImageType"] = confirmationType as AnyObject
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        //        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        dictData["ParcelId"] = self.strSelectedParcelID as AnyObject
        dictData["RequestFor"] = "delivery" as AnyObject
        dictData["Weight"] = selectWeight.value.first as AnyObject

        dictData["PickupLat"] = "\(doublePickupLat)" as AnyObject
        dictData["PickupLng"] = "\(doublePickupLng)" as AnyObject
        dictData["DropOffLat"] = "\(doubleDropOffLat)" as AnyObject
        dictData["DropOffLon"] = "\(doubleDropOffLng)" as AnyObject
        dictData["Special"] = strSpecialRequest as AnyObject
        
        if lblPromoCode.text != "" {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        
        dictData["Notes"] = txtDescription.text as AnyObject
        
        if paymentType == "" {
            UtilityClass.setCustomAlert(title: "", message: "Select Payment Type") { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID != "" {
            dictData["CardId"] = CardID as AnyObject
        }
        
        let parcelImage = btnUploadParcelPhoto.imageView?.image
        
        guard let homeVC = (self.parent as! UINavigationController).childViewControllers.first as? HomeViewController else {
            UtilityClass.setCustomAlert(title: "", message: "Sothing went wrong...") { (index, title) in
            }
            return
        }
        //        (self.parent as! UINavigationController).childViewControllers.first as! HomeViewController
        
        homeVC.view.bringSubview(toFront: homeVC.viewMainActivityIndicator)
        homeVC.viewMainActivityIndicator.isHidden = false
        webserviceForTaxiRequest(dictData as AnyObject, image: parcelImage ?? UIImage()) { (result, status) in
            
            if (status) {
                //      print(result)
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                if let bookingId = ((result as! NSDictionary).object(forKey: "details") as! NSDictionary).object(forKey: "BookingId") as? Int {
                    SingletonClass.sharedInstance.bookingId = "\(bookingId)"
                }
                
                homeVC.strBookingType = "BookNow"
                homeVC.viewBookNow.isHidden = true
                homeVC.viewActivity.startAnimating()
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                //    print(result)
                
                homeVC.viewBookNow.isHidden = true
                homeVC.viewMainActivityIndicator.isHidden = true
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    if((resDict.object(forKey: "message") as? NSArray) != nil)
                    {
                        UtilityClass.setCustomAlert(title: "Error", message: (resDict.object(forKey: GetResponseMessageKey()) as! NSArray).object(at: 0) as! String) { (index, title) in
                        }
                    }
                    else
                    {
                        UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                        }
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String) { (index, title) in
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "presentPlacePicker")
        {
            let deiverInfo = segue.destination as! UINavigationController
            let targetController = deiverInfo.topViewController as! PlacePickerViewController
            targetController.delegate = self
            targetController.bounds = NearByRegion
        }
    }
    
}

// Delegates to handle events for the location manager.
extension BookLaterViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        //        self.getPlaceFromLatLong()

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("Error: \(error)")
    }
    
    
}

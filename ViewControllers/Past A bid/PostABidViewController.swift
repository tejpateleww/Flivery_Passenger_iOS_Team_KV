//
//  PostABidViewController.swift
//  Flivery User
//
//  Created by Mayur iMac on 26/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import GoogleMaps
import GooglePlaces

protocol RefreshData {
    func dataRefresh()
}

var shouldLocalize = true


class PostABidViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

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
    @IBOutlet weak var btnSelectLuggage: UIButton?
    var CardID = String()
    var arrNumberOfOnlineCars : [[String:AnyObject]]!
    var selectedIndexPath: IndexPath?
    var strCarModelClass = String()
    var strCarModelID = String()
    var strNavigateCarModel = String()
    var strModelId = String()
    var imagePicker: ImagePicker!
    var strCarModelIDIfZero = String()
    var imageView : UIImageView!
    var datePickerView  : UIDatePicker = UIDatePicker()
    var isPickupLocation = Bool()
    var Delegate : RefreshData!
    var pickUpCoordinate : CLLocationCoordinate2D!
    var dropOffCoordinate : CLLocationCoordinate2D!
    var pickerView = UIPickerView()
    var aryCards = [[String:AnyObject]]()
    var NearByRegion:GMSCoordinateBounds!
    @IBOutlet weak var collectionviewCars: UICollectionView!
    @IBOutlet var viewSelectVehicle: UIView!

    @IBOutlet weak var imgPaymentOption: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        txtDropLocation?.delegate = self
        txtPickUpLocation?.delegate = self
        let profileData = SingletonClass.sharedInstance.dictProfile

        txtShippersName!.text = profileData.object(forKey: "Fullname") as? String ?? ""
        self.setNavBarWithMenuORBack(Title: "Post a Bid".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        setupButtonAndTextfield()

        arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]

        txtVehicleType?.inputView = viewSelectVehicle

        TxtDateAndTime?.inputView = datePickerView
        TxtDateAndTime?.delegate = self

        strModelId = "0"

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        txtPayment?.inputView = pickerView
        pickerView.delegate = self

        webserviceOfCardList()


        let bounds = GMSCoordinateBounds()
        let latitude = SingletonClass.sharedInstance.currentLatitude
        let longitude =  SingletonClass.sharedInstance.currentLongitude
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:Double(latitude) ?? 00.00, longitude:Double(longitude) ?? 0.00)
        NearByRegion = bounds.includingCoordinate(marker.position)
        btnSelectLuggage?.imageView?.contentMode = .scaleAspectFit
        btnSelectLuggage?.setTitle("Upload your parcel photo here".localized, for: .normal)


    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cornerRadiusToView(tempView: btnSelectLuggage!, isRounded: false, corner: 3, border: 1, borderColor: UIColor.lightGray)
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

    func setupButtonAndTextfield()
    {

        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height / 2
        btnSubmit.clipsToBounds = true
        btnSubmit.setTitle("Post a Bid".localized, for: .normal)

        imageView = UIImageView(image: UIImage(named: "Title_logo"))
        imageView.frame = CGRect(x: 0, y: 5, width: 50 , height: 30)
        imageView.contentMode = .scaleAspectFit
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        paddingView.addSubview(imageView)
        txtVehicleType?.rightViewMode = .always
        txtVehicleType?.rightView = paddingView

    }


    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == TxtDateAndTime)
        {
            let dateFormaterView = DateFormatter()
            dateFormaterView.dateFormat = "yyyy-MM-dd HH:mm:ss"
            TxtDateAndTime?.text = dateFormaterView.string(from: datePickerView.date)
        }
    }


    @IBAction func selectImageForLuggage(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        self.imagePicker.present(from: sender)
    }
    @IBAction func selectVehicleClick(_ sender: UIButton) {
        txtVehicleType!.resignFirstResponder()
    }
    func PickingImageFromCamera(_ sender: UIButton)
    {
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            UtilityClass.showAlert("", message: "Camera is not working!", vc: self)
            return
        }
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
         self.imagePicker.present(from: sender)
    }

    func PickingImageFromGallery(_ sender: UIButton)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
         self.imagePicker.present(from: sender)
    }


    //MARK:- Collectionview Delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.arrNumberOfOnlineCars.count == 0 {
            return 5
        }

        return self.arrNumberOfOnlineCars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell

        cell.CarUnderline.backgroundColor = ThemeNaviBlueColor
        cell.lblCarType.textColor = ThemeNaviBlueColor

        if selectedIndexPath == indexPath
        {
            cell.viewOfImage.layer.cornerRadius = 25.0
            cell.viewOfImage.layer.masksToBounds = true
            cell.viewOfImage.layer.borderColor = ThemeNaviBlueLightColor
                .cgColor
            cell.viewOfImage.layer.borderWidth = 3.0
            cell.viewOfImage.layer.masksToBounds = true
        }
        else
        {

            cell.viewOfImage.layer.cornerRadius = 25.0
            cell.viewOfImage.layer.masksToBounds = true
            cell.viewOfImage.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewOfImage.layer.borderWidth = 3.0
            cell.viewOfImage.layer.masksToBounds = true
        }

        if self.arrNumberOfOnlineCars.count == 0 {
            cell.imgCars.sd_setIndicatorStyle(.gray)
            cell.imgCars.sd_setShowActivityIndicatorView(true)

        }
        else if (self.arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {
            let dictOnlineCarData = arrNumberOfOnlineCars[indexPath.row]
            let imageURL = dictOnlineCarData["Image"] as! String

            cell.imgCars.sd_setIndicatorStyle(.gray)
            cell.imgCars.sd_setShowActivityIndicatorView(true)

            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })

            cell.lblCarType.text = (dictOnlineCarData["Name"] as? String)?.uppercased()

            /*
             if dictOnlineCarData["carCount"] as! Int != 0 {

             if self.aryEstimateFareData.count != 0 {

             if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? NSNull) != nil {
             cell.lblMinutes.text = "No cabs" //"Loading..."
             }
             else if let minute = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? Int
             {
             cell.lblMinutes.text =  (minute > 0) ? "\(minute) min" : "No cabs"  //"Loading"
             }
             var EstimateFare:String = ""
             if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? NSNull) != nil {

             cell.lblPrices.text = "\(currency) \(0)"
             }
             else if let price = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? Double {
             EstimateFare = String(format : "%.2f", price)
             cell.lblPrices.text = "\(currency) \(EstimateFare)"
             }
             }
             }
             }

             */



            // Maybe for future testing ///////


        }
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        if self.arrNumberOfOnlineCars.count == 0 {
            // do nothing here
        }
        else if (arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {

            let dictOnlineCarData = arrNumberOfOnlineCars[indexPath.row]
            //
            //            if dictOnlineCarData["carCount"] as! Int != 0 {
            //
            //                //                    if (self.aryEstimateFareData.count != 0 )
            //                //                    {
            //                //                        if let tempDictEstimateFare = self.aryEstimateFareData[indexPath.row] as?   [String:AnyObject]
            //                //                        {
            //                //                            self.strSelectedCarTotalFare = tempDictEstimateFare["total"] == nil ? "0" : "\(tempDictEstimateFare["total"]!)"
            //                //                        }
            //                //                    }
            //
            //
            //                //                    for i in 0..<self.aryMarkerOnlineCars.count {
            //                //
            //                //                        self.aryMarkerOnlineCars[i].map = nil
            //                //                    }
            //
            //                //                    self.aryMarkerOnlineCars.removeAll()
            //
            //                //                    let available = dictOnlineCarData.object(forKey: "carCount") as? Int ?? 0
            //                //                    let checkAvailabla = String(available)
            //
            //
            //                //                    var lati = dictOnlineCarData.object(forKey: "Lat") as? Double ?? 0.0
            //                //                    var longi = dictOnlineCarData.object(forKey: "Lng") as? Double ?? 0.0
            //
            //
            //                //                    let locationsArray = (dictOnlineCarData.object(forKey: "locations") as! [[String:AnyObject]])
            //
            //                //                    for i in 0..<locationsArray.count
            //                //                    {
            //                //                        if( (locationsArray[i]["CarType"] as! String) == (dictOnlineCarData.object(forKey: "Id") as! String))
            //                //                        {
            //                //                            lati = (locationsArray[i]["Location"] as! [AnyObject])[0] as? Double ?? 0.0
            //                //                            longi = (locationsArray[i]["Location"] as! [AnyObject])[1] as? Double ?? 0.0
            //                //                            let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
            //                //                            self.markerOnlineCars = GMSMarker(position: position)
            //                //                            //                        self.markerOnlineCars.tracksViewChanges = false
            //                //                            //                        self.strSelectedCarMarkerIcon = self.markertIcon(index: indexPath.row)
            //                //                            self.strSelectedCarMarkerIcon = "dummyCar"//self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String)
            //                //                            //                        self.markerOnlineCars.icon = UIImage(named: self.markertIcon(index: indexPath.row)) // iconCurrentLocation
            //                //
            //                //                            self.aryMarkerOnlineCars.append(self.markerOnlineCars)
            //                //
            //                //                            //                        self.markerOnlineCars.map = nil
            //                //                            //                    self.markerOnlineCars.map = self.mapView
            //                //
            //                //                        }
            //                //                    }
            //
            //                // Show Nearest Driver from Passenger
            //                //                    if self.aryMarkerOnlineCars.count != 0 {
            //                //                        if self.aryMarkerOnlineCars.first != nil {
            //                //                            if let nearestDriver = self.aryMarkerOnlineCars.first {
            //                //
            //                //                                let camera = GMSCameraPosition.camera(withLatitude: nearestDriver.position.latitude, longitude: nearestDriver.position.longitude, zoom: 17)
            //                //                                self.mapView.camera = camera
            //                //                            }
            //                //                        }
            //                //                    }
            //
            //                //                    for i in 0..<self.aryMarkerOnlineCars.count {
            //                //
            //                //                        self.aryMarkerOnlineCars[i].position = self.aryMarkerOnlineCars[i].position
            //                //                        self.aryMarkerOnlineCars[i].icon = UIImage(named: self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String))
            //                //                        self.aryMarkerOnlineCars[i].map = self.mapView
            //                //                    }
            //
            //                let carModelID = dictOnlineCarData["Id"] as? String ?? ""
            //                let carModelIDConverString: String = carModelID
            //
            //                let strCarName: String = dictOnlineCarData["Name"] as? String ?? ""
            //
            //                strCarModelClass = strCarName
            //                strCarModelID = carModelIDConverString
            //                //                    var EstimateFare:String = ""
            //                //                    if ((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? NSNull) != nil {
            //                //
            //                //                        strEstimatedTotal = "\(currency) \(0)"
            //                //                    }
            //                //                    else if let price = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? Double {
            //                //                        //                    EstimateFare = "\(price)"
            //                //                        EstimateFare = "\(String(format : "%.2f", price))"
            //                //                        strEstimatedTotal = "\(currency) \(EstimateFare)"
            //                //                    }
            //
            //                //                strEstimatedTotal =
            //                selectedIndexPath = indexPath
            //
            //                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
            //                cell.viewOfImage.layer.borderColor = ThemeNaviBlueColor.cgColor
            //
            //                let imageURL = dictOnlineCarData["Image"] as? String ?? ""
            //                strNavigateCarModel = imageURL
            //                strCarModelIDIfZero = ""
            //                strModelId = dictOnlineCarData["Id"] as? String ?? ""
            //
            //            }
            //            else {

            //                    for i in 0..<self.aryMarkerOnlineCars.count {
            //
            //                        self.aryMarkerOnlineCars[i].map = nil
            //                    }
            //
            //                    self.aryMarkerOnlineCars.removeAll()


            let carModelID = dictOnlineCarData["Id"] as? String ?? ""
            let carModelIDConverString: String = carModelID

            let strCarName: String = dictOnlineCarData["Name"] as? String ?? ""

            strCarModelClass = strCarName
            strCarModelID = carModelIDConverString

            let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
            cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor

            selectedIndexPath = indexPath

            let imageURL = dictOnlineCarData["Image"] as? String ?? ""

            strNavigateCarModel = imageURL
            //                strCarModelID = ""
            strCarModelIDIfZero = carModelIDConverString

//            let available = dictOnlineCarData["carCount"] as? Int ?? 0
//            let checkAvailabla = String(available)

//            if checkAvailabla != "0" {
                strModelId = dictOnlineCarData["Id"] as? String ?? ""
//            }
//            else {
//                strModelId = ""
//            }
            imageView.image = cell.imgCars.image
            txtVehicleType?.text = strCarName

            //            }
            collectionviewCars.reloadData()
        }
        //        else
        //        {
        //
        //            let PackageVC = self.storyboard?.instantiateViewController(withIdentifier: "PackageViewController")as! PackageViewController
        //            let navController = UINavigationController(rootViewController: PackageVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        //
        //            PackageVC.strPickupLocation = strPickupLocation
        //            PackageVC.doublePickupLat = doublePickupLat
        //            PackageVC.doublePickupLng = doublePickupLng
        //
        //            self.present(navController, animated:true, completion: nil)
        //
        //        }
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let CellWidth = ( UIScreen.main.bounds.width - 30 ) / 6
        return CGSize(width: CellWidth , height: self.collectionviewCars.frame.size.height)
        //        self.viewCarLists.frame.size.height
    }

    //PassengerId, ModelId, PickupLocation, DropoffLocation, PickupLat,PickupLng, DropOffLat, DropOffLon, PickupDateTime,ShipperName,Budget,CardId,Notes, Image



    func validations() -> Bool
    {
        if(txtShippersName?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Shipper Name", vc: self)
            return false
        }
        else if(txtPickUpLocation?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Pickup Location", vc: self)
            return false
        }
        else if(txtDropLocation?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Drop Location", vc: self)
            return false
        }
        else if(txtBudget?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Budget", vc: self)
            return false
        }
        else if(TxtDateAndTime?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Select Date and time", vc: self)
            return false
        }
        else if(txtWeight?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Weight", vc: self)
            return false
        }
        else if(txtQuantity?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Quantity", vc: self)
            return false
        }
        else if self.btnSelectLuggage?.imageView?.image == nil {
            UtilityClass.showAlert("Error", message: "Please Select Document", vc: self)
            return false
        }
        else if(strModelId == "0")
        {
            UtilityClass.showAlert("Error", message: "Please select car!", vc: self)
            return false
            
        }
        else if(CardID.isBlank==true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Card Number", vc: self)
            return false
        }
        else if(pickUpCoordinate == nil)
        {
            return false
        }
        else if(dropOffCoordinate == nil)
        {
            return false
        }
        return true
//        ========================================
        /*
        if(strModelId == "0")
        {
            UtilityClass.showAlert("Error", message: "Please Select Car Type", vc: self)
            return false
           
        }
        else if(txtPickUpLocation?.text?.isBlank == true)
        {
          UtilityClass.showAlert("Error", message: "Please Enter PickUP Location", vc: self)
            return false
        }
        else if(txtDropLocation?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Drop Location", vc: self)
            return false
        }
        else if(TxtDateAndTime?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Select Date and time", vc: self)
            return false
        }
        else if(txtShippersName?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Shipper Name", vc: self)
            return false
        }
        else if(txtBudget?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Budget", vc: self)
            return false
        }
        else if(txtWeight?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Weight", vc: self)
            return false
        }
        else if(txtQuantity?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Quantity", vc: self)
            return false
        }
        else if(txtNotes?.text?.isBlank == true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Notes", vc: self)
            return false
        }
        else if(pickUpCoordinate == nil)
        {
            return false
        }
        else if(dropOffCoordinate == nil)
        {
            return false
        }
        else if(CardID.isBlank==true)
        {
            UtilityClass.showAlert("Error", message: "Please Enter Card Number", vc: self)
            return false
        }


        return true
         */
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtPickUpLocation {
            
            placepickerMethodForLocation()
            isPickupLocation = true
          return false
        } else if textField == txtDropLocation {
            
            placepickerMethodForLocation()
            isPickupLocation = false
            return false
        }else if textField == txtPayment {
            guard self.aryCards.count != 0 else {
                 UtilityClass.showAlert("Error", message: "Please Add card first", vc: self)
                return false
            }
        }
        
        return true
    }
   
    /*@IBAction func txtLocation(_ sender: UITextField)
    {
        if(sender.tag == 1)
        {
            placepickerMethodForLocation()
            isPickupLocation = true
        }
        else
        {
            placepickerMethodForLocation()
            isPickupLocation = false
        }
    }
 */

    //MARK:- Setup Pickup and Destination Location

    func placepickerMethodForLocation()
    {
//        let visibleRegion = mapView.projection.visibleRegion()
//        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        acController.autocompleteBounds = bounds
         self.performSegue(withIdentifier: "presentPlacePicker", sender: nil)
//        present(acController, animated: true, completion: nil)
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
        txtPayment?.text = data["CardNum2"] as? String

        if data["CardNum"] as! String == "Add a Card" {

            isAddCardSelected = true
            //            self.addNewCard()
        }

        if data["Id"] as? String != "" {
            CardID = data["Id"] as! String
        }

    }

    func addNewCard() {

        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.present(next, animated: true, completion: nil)
    }


    @IBAction func btnSubmitABid(_ sender: Any) {
        
        webserviceCallForPostABid()
    }



    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------



    func webserviceOfCardList() {

        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in

            if (status) {
                print(result)

                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                    }
                }
                guard self.aryCards.count != 0 else {
                    return
                }
                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]

                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                self.txtPayment?.text = data["CardNum2"] as? String

//                let type = data["CardNum"] as! String
                //
                //                if type  == "wallet" {
                //                    self.paymentType = "wallet"
                //                }
                //                else



                if data["Id"] as? String != "" {
                    self.CardID = data["Id"] as! String
                }

                //                 self.paymentType = "cash"
                self.pickerView.reloadAllComponents()

            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }

    func webserviceCallForPostABid()
    {

        if(self.validations() == true)
        {
            var dictParams = [String:Any]()
            dictParams["PassengerId"] = SingletonClass.sharedInstance.strPassengerID
            dictParams["ModelId"] = strModelId
            dictParams["PickupLocation"] = txtPickUpLocation?.text ?? ""
            dictParams["DropoffLocation"] = txtDropLocation?.text ?? ""
            dictParams["PickupLat"] = pickUpCoordinate.latitude
            dictParams["PickupLng"] = pickUpCoordinate.longitude
            dictParams["DropOffLat"] = dropOffCoordinate.latitude
            dictParams["DropOffLon"] = dropOffCoordinate.longitude
            dictParams["PickupDateTime"] = TxtDateAndTime?.text ?? ""
            dictParams["ShipperName"] = txtShippersName?.text ?? ""
            dictParams["Budget"] = txtBudget?.text ?? ""
            dictParams["CardId"] = CardID
            dictParams["Weight"] = txtWeight?.text ?? "0"
            dictParams["Quantity"] = txtQuantity?.text ?? "0"
            dictParams["Notes"] = txtNotes?.text ?? ""

            print(dictParams)
            webserviceForPostABid(dictParams as AnyObject, image1: self.btnSelectLuggage?.imageView?.image ?? UIImage()) { (result, status) in
                if(status == true)
                {
                    print(result)
                    UtilityClass.showAlertWithCompletion("", message: "Your bid has been placed", vc: self, completionHandler: { (status) in
                        self.Delegate.dataRefresh()
                        self.navigationController?.popViewController(animated: true)
                    })
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

  

}


extension PostABidViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {

        self.btnSelectLuggage?.setImage(image, for: .normal)
//        self.btnSelectLuggage?.imageView?.image = image
    }
}

extension PostABidViewController : didSelectPlace
{
    func didSelectPlaceFromPlacePicker(place: GMSPlace)
    {
        if(isPickupLocation)
        {
            txtPickUpLocation?.text = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
            pickUpCoordinate = place.coordinate
        }
        else
        {
            txtDropLocation?.text = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
            dropOffCoordinate = place.coordinate
        }
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true

        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            shouldLocalize = false
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shouldLocalize = true
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        shouldLocalize = true
        self.pickerController(picker, didSelect: chosenImage)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}


// MARK: - GMSAutocompleteViewControllerDelegate
extension PostABidViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        if(isPickupLocation)
        {
            txtPickUpLocation?.text = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
            pickUpCoordinate = place.coordinate
        }
        else
        {
            txtDropLocation?.text = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
            dropOffCoordinate = place.coordinate
        }

        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}


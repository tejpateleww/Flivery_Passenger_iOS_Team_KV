//
//  PostABidViewController.swift
//  Flivery User
//
//  Created by Mayur iMac on 26/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class PostABidViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

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
    @IBOutlet weak var imgDocument : UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSelectLuggage: UIButton!
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

    @IBOutlet weak var collectionviewCars: UICollectionView!
    @IBOutlet var viewSelectVehicle: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarWithMenuORBack(Title: "Post a Bid".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        setupButtonAndTextfield()

        arrNumberOfOnlineCars = SingletonClass.sharedInstance.arrCarLists as? [[String : AnyObject]]

        txtVehicleType?.inputView = viewSelectVehicle

        TxtDateAndTime?.inputView = datePickerView
        TxtDateAndTime?.delegate = self

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        // Do any additional setup after loading the view.
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
            dateFormaterView.dateFormat = "yyyy-MM-dd HH:mm:ss a"
            TxtDateAndTime?.text = dateFormaterView.string(from: datePickerView.date)
        }
    }


    @IBAction func selectImageForLuggage(_ sender: UIButton) {

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .camera

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


        //        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
        //        cell.viewOfImage.layer.borderWidth = 3.0


        cell.CarUnderline.backgroundColor = ThemeNaviBlueColor
        cell.lblCarType.textColor = ThemeNaviBlueColor
        //        cell.lblPrices.textColor = ThemeNaviBlueColor
        //        cell.lblMinutes.textColor = ThemeNaviBlueColor
        //        cell.lblAvailableCars.textColor = ThemeNaviBlueColor


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
            //            cell.CarUnderline.backgroundColor = UIColor.black
            //            cell.lblCarType.textColor = UIColor.black
            //            cell.lblPrices.textColor = UIColor.black
            //            cell.lblMinutes.textColor = UIColor.black
            //            cell.lblAvailableCars.textColor = UIColor.black
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

            //            cell.lblMinutes.isHidden = true
            //            cell.lblPrices.isHidden = true
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

            let available = dictOnlineCarData["carCount"] as? Int ?? 0
            let checkAvailabla = String(available)

            if checkAvailabla != "0" {
                strModelId = dictOnlineCarData["Id"] as? String ?? ""
            }
            else {
                strModelId = ""
            }
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


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}


extension PostABidViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imgDocument.image = image
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
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        self.pickerController(picker, didSelect: chosenImage)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}

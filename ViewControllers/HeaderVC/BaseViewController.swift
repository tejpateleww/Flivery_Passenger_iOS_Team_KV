//
//  BaseViewController.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 05/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    func setNavBarWithBackWithAdd(Title:String)
    {
        self.navigationItem.title = Title
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ThemeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: kIconBack), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton

        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navigateToPostBidVC))
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }

    func setDefaultBackButton() {
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: kIconBack), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton

    }
    func setNavBarWithMenuORBack(Title:String,LetfBtn : String, IsNeedRightButton:Bool ,isTranslucent : Bool)
    {
        //        self.navigationController?.navigationBar.isTranslucent = false
        
        //        if Title == "Home"
        //        {
        //            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
        //            titleImage.contentMode = .scaleAspectFit
        //            titleImage.image = UIImage(named: "Title_logo")
        //            //            titleImage.backgroundColor  = themeYellowColor
        //            self.navigationItem.titleView = titleImage
        //        }
        //        else
        //        {
        self.navigationItem.title = Title//.uppercased()
        //        }
        self.navigationController?.isNavigationBarHidden = false
        //        self.navigationController?.navigationBar.isOpaque = false
        self.navigationController?.navigationBar.barTintColor = ThemeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if LetfBtn == kIconMenu
        {
            let leftNavBarButton = UIBarButtonItem(image: UIImage(named: LetfBtn), style: .plain, target: self, action: #selector(self.OpenMenuAction))
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            
        }
        else
        {
            let leftNavBarButton = UIBarButtonItem(image: UIImage(named: LetfBtn), style: .plain, target: self, action: #selector(self.btnBackAction))
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        }
        
        if IsNeedRightButton == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if UserDefaults.standard.value(forKey: "i18n_language") != nil
        {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == secondLanguage { // "sw" {
                    //                    btnLeft.semanticContentAttribute = .forceLeftToRight
                    
                    //                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
    }
//    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool){
////        self.navigationController?.navigationBar.isTranslucent = false
//        
//        if Title == "Home" {
//            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
//            titleImage.contentMode = .scaleAspectFit
//            titleImage.image = UIImage(named: "Title_logo")
////            titleImage.backgroundColor  = themeYellowColor
//             self.navigationItem.titleView = titleImage
//        } else {
//            self.navigationItem.title = Title.uppercased()
//        }
//       
//        self.navigationController?.navigationBar.barTintColor = ThemeNaviBlueColor;
//        self.navigationController?.navigationBar.tintColor = UIColor.white;
//        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        
//        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        
//        if IsNeedRightButton == true {
//            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
//            self.navigationItem.rightBarButtonItem = nil
//            self.navigationItem.rightBarButtonItem = rightNavBarButton
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
//    }
//    
//    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool) {
////        self.navigationController?.navigationBar.isTranslucent = false
//        
//        if Title == "Home" {
//            let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//            titleImage.contentMode = .scaleAspectFit
//            titleImage.image = UIImage(named: "Title_logo")
//            self.navigationItem.titleView = titleImage
//        } else {
//            self.navigationItem.title = Title.uppercased().localizedUppercase
//        }
//        self.navigationController?.navigationBar.barTintColor = ThemeNaviBlueColor;
//        self.navigationController?.navigationBar.tintColor = UIColor.white;
//        
//        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_BackWhite"), style: .plain, target: self, action: #selector(self.btnBackAction))
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        
//        
//        if IsNeedRightButton == true {
//            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
//            self.navigationItem.rightBarButtonItem = nil
//            self.navigationItem.rightBarButtonItem = rightNavBarButton
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
//        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
//            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
    //                if language == secondLanguage { // "sw" {
////                    btnLeft.semanticContentAttribute = .forceLeftToRight
//                    
////                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
//                }
//            }
//        }
//    }
    
    
    // MARK:- Navigation Bar Button Action Methods
    
    @objc func OpenMenuAction(){
         sideMenuController?.toggle()
    }
    
    @objc func btnBackAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCallAction() {
        
        let contactNumber = helpLineNumber
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    @objc func navigateToPostBidVC(){
        guard let bidListContainer = self as? BidListContainerViewController else {
            return
        }
        let bidPostVC = self.storyboard?.instantiateViewController(withIdentifier: "PostABidViewController") as! PostABidViewController
        bidPostVC.Delegate = bidListContainer
        self.navigationController?.pushViewController(bidPostVC, animated: true)
    }
    
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

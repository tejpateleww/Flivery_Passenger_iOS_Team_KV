//
//  File.swift
//  SwiftDEMO_Palak
//
//  Created by MAYUR on 17/01/18.
//  Copyright © 2018 MAYUR. All rights reserved.
//

import Foundation
import UIKit
//import BFKit

let App_Delegate = UIApplication.shared.delegate as! AppDelegate
let ThemeYellowColor : UIColor = UIColor.init(hex: "ce2c31")
let ThemeGrayColor : UIColor = UIColor.init(hex:  "8e8c80")

let ThemeGreenColor : UIColor = UIColor(red: 46.0/255.0, green: 156.0/255.0, blue: 97.0/255.0, alpha: 1.0)
let ThemeStatusBarColor : UIColor = UIColor.init(hex:  "cccccc")
let themeGrayBGColor : UIColor = UIColor.init(hex: "DDDDDD")
let themeGrayTextColor : UIColor = UIColor.init(hex: "7A7A7C")
let Appdelegate = UIApplication.shared.delegate as! AppDelegate
let AppNAME : String = "Flivery Shipper".localized

let navigationBarHeightIphoneX = 84
//var utility = Utilities()

let kHtmlReplaceString   :   String  =   "<[^>]+>"
//let currency : String = "$"
let dictanceType : String = "km"

///Chat//
let NotificationgetResponseOfChatting = NSNotification.Name("NotificationgetResponseOfChatting")
let NotificationgetResponseOfChattingOfSpecificDriver = NSNotification.Name("NotificationgetResponseOfChattingOfSpecificDriver")

///
let kIconMenu : String = "iconMenu"
let kIconBack : String = "iconBack"

let kIsSocketEmited : String = "IsEmited"
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let kAcceptTripStatus : String = "accepted"
let kPendingTripStatus : String = "pending"
let kTravellingTripStatus : String = "traveling"
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6_7 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0
let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0


let RingToneSound : String = "PickNGo"
let kBackIcon : String = "iconArrow"
let kMenuIcon : String = "menu"
let kRighticon : String = "right_start_icon"
let kNavIcon : String = "nav_icon"

let iconCheck : String = "check_icon"
let iconUncheck : String = "uncheck_icon"

let iconRadioSelect : String = "radio_select_icon"
let iconRadioUnselect : String = "radio_unselect_icon"


let iconMailSelect : String = "iconSegMailSelected"
let iconDriverSelect : String = "iconSegUserProfileSelected"
let iconBankSelect : String = "iconSegBankSelected"
let iconCarSelect : String = "iconSegVehicleSelected"
let iconAttachmentSelect : String = "iconSegAttachmentSelected"

let iconMailUnselect : String = "iconSegMailUnSelected"
let iconDriverUnselect : String = "iconSegUserProfileUnSelected"
let iconBankUnselect : String = "iconSegBankUnSelected"
let iconCarUnselect : String = "iconSegVehicleUnSelected"
let iconAttachmentUnselect : String = "iconSegAttachmentUnSelected"

let CustomeFontProximaNovaBold : String = "ProximaNovaA-Bold"
let CustomeFontProximaNovaRegular : String = "ProximaNovaA-Regular"
let CustomeFontProximaNovaBlack : String = "ProximaNovaA-Black"
let CustomeFontProximaNovaCondSemibold : String = "ProximaNovaACond-Semibold"
let CustomeFontProximaNovaSemibold : String = "ProximaNova-Semibold"
let CustomeFontProximaNovaSThin : String = "ProximaNovaS-Thin"
let CustomeFontProximaNovaTThin : String = "ProximaNovaT-Thin"

let kGooglePlaceClientAPIKey : String = "AIzaSyCSwJSvFn2je-EXNxjUEUrU06_L7flz4qw" //"AIzaSyAW9o_4ULlYZ9AF_Cxuqn2mPav4XKJJwGI"
let kGoogleServiceAPIKey : String = "AIzaSyClUkKxzVBjw1wb4h9AfbsHGenepqcYwUA"




let kGoogleClientID : String = "47834603870-2q7f5911uemff0t4rfv4mvl8g22jc1ef.apps.googleusercontent.com"
let kGoogleReversedClientID : String = "com.googleusercontent.apps.47834603870-2q7f5911uemff0t4rfv4mvl8g22jc1ef"

let kTwitterConsumerAPIKey : String = "hP1bMN8z87nRv7JQpMdluArGy"
let kTwitterConsumerSecretKey : String = "hhSbpPG8pC80B0F3ocsJ5YAZLKrEHweemsY1WHPmidbaBnULny"
let CustomeFontUbuntuLight : String = "Ubuntu-Light"
let CustomeFontUbuntuMediumItalic : String = "Ubuntu-MediumItalic"
let CustomeFontUbuntuLightItalic : String = "Ubuntu-LightItalic"
let CustomeFontUbuntuMedium : String = "Ubuntu-Medium"
let CustomeFontUbuntuBold : String = "Ubuntu-Bold"
let CustomeFontUbuntuItalic : String = "Ubuntu-Italic"
let CustomeFontUbuntu : String = "Ubuntu"

let kMyBooking : String = "My Booking"
let kPay : String = "Pay"
let kFavourite : String = "Favourite"
let kMyReceipts : String = "My Receipts"
let kBarsandClubs : String = "Bars and Clubs"
let kHotelReservation : String = "Hotel Reservation"
let kBookaTable : String = "Book a Table"
let kShopping : String = "Shopping"



//SideMenu Option
let kMyJobs : String = "My Jobs"
let kPaymentOption : String = "Payment Option"
let kPassword : String = "Change Password"
let kWallet : String = "Wallet"
let kTripToDestination : String = "Trip to Destination"
let kMyRating : String = "My Rating"
let kInviteFriend : String = "Invite Driver"
let kSettings : String = "Settings"
let kLegal : String = "Legal"
let kSupport : String = "Support"
let kLogout : String = "Logout"

//let kMeter : String = "Meter"
//let kTripToDstination : String = "Trip To Destination"
//let kShareRide: String = "Share Ride"

//SideMenu Option Icon
let kiconMyJobs : String = "iconMyjobInactive"
let kiconPaymentOption : String = "iconPaymentOptions"
let kiconWallet : String = "iconWalletInactive"
let kiconPassword : String = "iconLock"
let kiconTripToDestination : String = "iconTriptoDestination"

let kiconMyRating : String = "iconRatingInactive"
let kiconInviteFriend : String = "iconInviteFriend"
let kiconSettings : String = "iconSettingUnSelect"
//let klegalicon : String = "iconlegall"
let klegal : String = "iconlegall"
let kiconSupport : String = "iconSupportInactive"
let kIconLogout : String = "iconLogoutInactive"
//let kiconLogout : String = "iconAddress"
let NotificationTrackRunningTrip = NSNotification.Name("NotificationTrackRunningTrip")
let NotificationChangeLanguage = NSNotification.Name("ChangeLanguageNotification")


let UpdateProPic = NSNotification.Name("UpdateProPic")



func GetPaymentTypeKey() -> String {
    var PaymentKey:String = ""
    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        PaymentKey = (SelectedLanguage == "en") ? "PaymentType" : "french_PaymentType"
    }
    return PaymentKey
}

func GetTripStatusKey() -> String {
    var StatusKey:String = ""
    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        StatusKey = (SelectedLanguage == "en") ? "Status" : "french_BookingStatus"
    }
    return StatusKey
}

func GetResponseMessageKey() -> String {
    var MessageKey:String = ""
    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        MessageKey = (SelectedLanguage == "en") ? "message" : "french_message"
    }
    return MessageKey
}

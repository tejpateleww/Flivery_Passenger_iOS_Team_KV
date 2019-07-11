//
//  PlacePickerViewController.swift
//  Flivery User
//
//  Created by Mayur iMac on 11/07/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol didSelectPlace {
    func didSelectPlaceFromPlacePicker(place: GMSPlace)
}


class PlacePickerViewController: UIViewController,UISearchBarDelegate,UISearchControllerDelegate {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var visibleRegion : GMSVisibleRegion!
    var bounds : GMSCoordinateBounds!
     var delegate : didSelectPlace!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        resultsViewController = GMSAutocompleteResultsViewController()
//        let visibleRegion = mapView.projection.visibleRegion()
//        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        resultsViewController?.autocompleteBounds = bounds
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".localized

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.delegate = self
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true


        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
             self.searchController?.searchBar.becomeFirstResponder()
         }

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.dismiss(animated: true, completion: nil)
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
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


// Handle the user's selection.
extension PlacePickerViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
//        print("Place name: \(place.name ?? "")")
//        print("Place address: \(place.formattedAddress ?? "")")
        delegate?.didSelectPlaceFromPlacePicker(place: place)
        self.dismiss(animated: true, completion: nil)
//        print("Place attributions: \(place.attributions ?? "")")
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.dismiss(animated: true, completion: nil)
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.dismiss(animated: true, completion: nil)
    }
}

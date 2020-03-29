
//
//  MapVC.swift
//  SmartAds
//
//  Created by Pham Diep on 5/26/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapVCDelegate: NSObjectProtocol {
    func didSelectLocation(_ newLocation: CLLocationCoordinate2D)
}

class MapVC: UIViewController, GMSMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    var locationMarker: GMSMarker?
    weak var delegate: MapVCDelegate?
    @IBOutlet weak var lbl_map: UILabel!
    @IBOutlet weak var save: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleMap()
        // Do any additional setup after loading the view from its nib.
        textcustom()
    }

    func setupGoogleMap() {
        mapView.isMyLocationEnabled = true
        mapView.camera = GMSCameraPosition.camera(withLatitude: (LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0)!, longitude: (LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0)!, zoom: 16)
        if locationMarker != nil {
            mapView.animate(toLocation: (locationMarker?.position)!)
            locationMarker?.map = mapView
        } else {
            mapView.animate(toLocation: (LocationManager.shared().anotherLocationManager.location?.coordinate)!)
        }
        mapView.delegate = self
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        locationMarker?.map = nil
        locationMarker = GMSMarker(position: coordinate)
        locationMarker?.map = self.mapView
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onSave(_ sender: Any) {
        if locationMarker != nil {
            navigationController?.popViewController(animated: true)
            if let aPosition = locationMarker?.position {
                delegate?.didSelectLocation(aPosition)
            }
        } else {
            Util.showMessage(Util.localized("mess_please_select_the_location_first"), withTitle: APP_NAME)
        }
    }

    func textcustom() {
//        lbl_map.text = Util.localized("lbl_map")
//        save.setTitle(Util.localized("lbl_save"), for: .normal)
    }
}

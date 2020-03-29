
//
//  DetailAdsInfoCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit
import GoogleMaps


class DetailAdsInfoCell: UITableViewCell {
    @IBOutlet weak var detailLabel1: UILabel!
//    @IBOutlet weak var detailLabel2: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbl_detail: UILabel!

    @IBOutlet weak var tf_Description: UITextView!
    
    func setupMapview(with marker: GMSMarker) {
        if marker.position.latitude == 0 && marker.position.longitude == 0 {
            mapView.isHidden = true
        } else {
//            mapView.isHidden = false
//            mapView.isMyLocationEnabled = true
//
//            mapView.camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0, longitude: LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0, zoom: 16 )
//
//            mapView.animate(toLocation: (marker.position))
//            marker.map = mapView
            
            //
            self.mapView.isHidden = false
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0, longitude: LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0, zoom: 16.0)
            mapView.animate(toLocation: (marker.position))
            marker.map = mapView
            //
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_detail.text = "dt_lbl_detail".localized
    }
}

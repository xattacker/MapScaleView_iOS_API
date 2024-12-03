//
//  GMSMapViewController.swift
//  MapScaleView_iOS_API
//
//  Created by xattacker on 2021/4/14.
//  Copyright © 2021 xattacker. All rights reserved.
//

import UIKit
import MapScaleView
import GoogleMaps


// ScaleView setup with GMSMapView
class GMSMapViewController: UIViewController, GMSMapViewDelegate
{
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var scaleView: UIMapScaleView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set positon to the center of Taiwan
        let position = GMSCameraPosition(latitude: 23.80030512974474, longitude: 120.96817418343652, zoom: 8)
        self.mapView.camera = position
        
        self.mapView.delegate = self
        self.scaleView.scaleCalculator = self.mapView
    }
    
    // MARK: implement from GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        self.scaleView.setNeedsLayout()
    }
}


// make GMSMapView could support ScaleView
extension GMSMapView: MapScaleCalculator
{
    public var metersPerPixel: CGFloat
    {
        let topLeft = self.projection.visibleRegion().farLeft
        let bottomLeft = self.projection.visibleRegion().nearLeft
        let lat = CGFloat(abs(Float(topLeft.latitude - bottomLeft.latitude)))
        let metersPerPixel = CGFloat((cos(lat * .pi / 180) * 2 * .pi) * 6378137 / CGFloat((256 * pow(2, self.camera.zoom))))
        return metersPerPixel
    }
}

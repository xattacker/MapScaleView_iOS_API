//
//  GoogleMapViewController.swift
//  MapScaleView_iOS_API
//
//  Created by xattacker on 2021/4/14.
//  Copyright © 2021 xattacker. All rights reserved.
//

import UIKit
import GoogleMaps


// ScaleView setup with
class GoogleMapViewController: UIViewController, GMSMapViewDelegate
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var scaleView: UIMapScaleView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: implement from GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        self.scaleView.setNeedsLayout()
    }
}

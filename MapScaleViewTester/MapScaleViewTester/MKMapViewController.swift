//
//  MKMapViewController.swift
//  MapScaleView_iOS_API
//
//  Created by xattacker on 2019/3/20.
//  Copyright © 2019 xattacker. All rights reserved.
//

import UIKit
import MapKit
import MapScaleView


// ScaleView setup with MKMapView
class MKMapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var scaleView: UIMapScaleView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        self.scaleView.scaleCalculator = self.mapView
        //self.scaleView.unit = .imperial
    }
    
    // MARK: implement from MKMapViewDelegate
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.scaleView.setNeedsLayout()
    }
}

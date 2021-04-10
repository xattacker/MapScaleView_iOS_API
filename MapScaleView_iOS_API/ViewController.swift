//
//  ViewController.swift
//  MapScaleView_iOS_API
//
//  Created by xattacker on 2019/3/20.
//  Copyright © 2019 xattacker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scaleView: UIMapScaleView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        self.scaleView.setupMap(self.mapView)
        //self.scaleView.unit = .imperial
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.scaleView.setNeedsLayout()
    }
}


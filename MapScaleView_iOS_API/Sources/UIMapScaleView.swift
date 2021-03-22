//
//  UIMapScaleView.swift
//  Mapa turystyczna
//
//  Created by xattacker on 2019/03/20.
//  Copyright © 2019年 xattacker. All rights reserved.
//

import UIKit
import MapKit
import Darwin


public enum MapScaleExpandDirection
{
    case leftToRight // left to right
    case rightToLeft // right to right
}


@IBDesignable
public final class UIMapScaleView: UIView
{
    private let SCALE_BAR_HEIGHT = CGFloat(4.5)
    private let PADDING = CGFloat(1)
    
    public var direction: MapScaleExpandDirection = .leftToRight
    
    @IBInspectable public var bodyColor: UIColor = UIColor.darkGray
    {
        didSet
        {
            self.distanceLabel?.textColor = self.bodyColor
        }
    }
    
    @IBInspectable public var outlineColor: UIColor = UIColor.white
    {
        didSet
        {
            self.distanceLabel?.shadowColor = self.outlineColor
        }
    }
   
    private weak var mapView: MKMapView?
    private weak var distanceLabel: UILabel?
    private var scaledWidth = CGFloat(0)

    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.initView()
    }

    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        guard let mapView = self.mapView else
        {
            return
        }
        

        let horizontalDistance = MKMetersPerMapPointAtLatitude(mapView.centerCoordinate.latitude)
        let metersPerPixel = CGFloat(mapView.visibleMapRect.size.width * horizontalDistance) / mapView.bounds.size.width
        
        let value = calculateDistance(metersPerPixel)
        self.scaledWidth = value.width
        self.setNeedsDisplay()
        
        
        guard let label = self.distanceLabel else
        {
            return
        }
//            let attributes: [NSAttributedString.Key : Any] = [
//                            NSAttributedString.Key.strokeColor : self.outlineColor,
//                            NSAttributedString.Key.foregroundColor : self.bodyColor,
//                            NSAttributedString.Key.strokeWidth : -PADDING*2,
//                            NSAttributedString.Key.font : label.font]
//
//            label.attributedText = NSAttributedString(
//                                    string: String(format: "%d %@", value.value, value.unit),
//                                    attributes: attributes)
            
        label.text = String(format: "%d %@", value.value, value.unit)
        label.sizeToFit()

        label.frame = CGRect(x: PADDING,
                          y: self.bounds.size.height - label.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING*2),
                          width: self.bounds.width - (PADDING*2),
                          height: label.bounds.size.height)

        switch self.direction
        {
            case .leftToRight:
                self.distanceLabel?.textAlignment = .left
                break

            case .rightToLeft:
                self.distanceLabel?.textAlignment = .right
                break
        }
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        
        context.setFillColor(UIColor.darkText.cgColor)

        switch self.direction
        {
            case MapScaleExpandDirection.leftToRight:
                // draw outline
                context.setFillColor(self.outlineColor.cgColor)

                context.fill(CGRect(x: PADDING,
                                    y: self.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING*2),
                                    width: self.scaledWidth,
                                    height: SCALE_BAR_HEIGHT))

                context.fill(CGRect(x: self.scaledWidth - SCALE_BAR_HEIGHT + PADDING,
                                    y: self.bounds.size.height - (SCALE_BAR_HEIGHT*2) - (PADDING*2),
                                    width: SCALE_BAR_HEIGHT,
                                    height: SCALE_BAR_HEIGHT*2))


                context.setFillColor(self.bodyColor.cgColor)

                context.fill(CGRect(x: PADDING + PADDING,
                                    y: self.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING),
                                    width: self.scaledWidth - (PADDING*2),
                                    height: SCALE_BAR_HEIGHT - (PADDING*2)))

                context.fill(CGRect(x: self.scaledWidth - SCALE_BAR_HEIGHT + (PADDING*2),
                                    y: self.bounds.size.height - (SCALE_BAR_HEIGHT*2) - (PADDING),
                                    width: SCALE_BAR_HEIGHT - (PADDING*2),
                                    height: (SCALE_BAR_HEIGHT*2) - (PADDING*2)))
                break

            case MapScaleExpandDirection.rightToLeft:
                // draw outline
                context.setFillColor(self.outlineColor.cgColor)

                context.fill(CGRect(x: self.bounds.size.width - self.scaledWidth,
                                    y: self.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING*2),
                                    width: self.scaledWidth,
                                    height: SCALE_BAR_HEIGHT))

                context.fill(CGRect(x: self.bounds.size.width - self.scaledWidth,
                                    y: self.bounds.size.height - (SCALE_BAR_HEIGHT*2) - (PADDING*2),
                                    width: SCALE_BAR_HEIGHT,
                                    height: SCALE_BAR_HEIGHT*2))


                context.setFillColor(self.bodyColor.cgColor)

                context.fill(CGRect(x: self.bounds.size.width - self.scaledWidth + PADDING,
                                    y: self.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING),
                                    width: self.scaledWidth - (PADDING*2),
                                    height: SCALE_BAR_HEIGHT - (PADDING*2)))

                context.fill(CGRect(x: self.bounds.size.width - self.scaledWidth + PADDING,
                                    y: self.bounds.size.height - (SCALE_BAR_HEIGHT*2) - (PADDING),
                                    width: SCALE_BAR_HEIGHT - (PADDING*2),
                                    height: (SCALE_BAR_HEIGHT*2) - (PADDING*2)))
                break
        }
    }
    
    public func setupMap(_ mapView: MKMapView)
    {
        self.mapView = mapView
    }
    
    private func initView()
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        label.textColor = self.bodyColor
        label.shadowColor = self.outlineColor
        label.shadowOffset = CGSize(width: PADDING, height: PADDING)
        self.addSubview(label)
        self.distanceLabel = label
    }
    
    private func calculateDistance(_ metersPerPixel: CGFloat) -> (width: CGFloat, value: Int, unit: String)
    {
        var scaleWidth = CGFloat(0)
        var maxValue = Int(0)
        var unit = ""
        let maxScaleWidth = self.bounds.size.width - (PADDING * 2)
        let meters = maxScaleWidth * metersPerPixel

        maxValue = meters.roundDistance()
        scaleWidth = maxScaleWidth * CGFloat(maxValue) / meters
        
        if maxValue >= 1000
        {
            maxValue = maxValue / 1000
            unit = "km"
        }
        else
        {
            unit = "m"
        }

        return (scaleWidth, maxValue, unit)
    }
}


extension CGFloat
{
    func roundDistance() -> Int
    {
        var roundedDistance = 1
        var i = 0
        
        while (1 + pow(CGFloat(i % 3), 2)) * pow(10, floor(CGFloat(i / 3))) < self
        {
            roundedDistance =  Int(((1 + pow(CGFloat(i % 3), 2)) * pow(10, floor(CGFloat(i / 3)))))
            i+=1
        }
        
        return roundedDistance
    }
}

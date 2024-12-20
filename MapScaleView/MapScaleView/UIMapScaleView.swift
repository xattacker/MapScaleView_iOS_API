//
//  UIMapScaleView.swift
//  MapScaleView
//
//  Created by xattacker on 2019/03/20.
//  Copyright © 2019年 xattacker. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import Darwin


public enum MapScaleExpandDirection
{
    case leftToRight // left to right
    case rightToLeft // right to right
}

public enum MapScaleDistanceUnit
{
    case metric
    case imperial // UK
}

public protocol MapScaleCalculator: AnyObject
{
    var metersPerPixel: CGFloat { get }
}


extension MKMapView: MapScaleCalculator
{
    public var metersPerPixel: CGFloat
    {
        let horizontalDistance = MKMetersPerMapPointAtLatitude(self.centerCoordinate.latitude)
        let metersPerPixel = CGFloat(self.visibleMapRect.size.width * horizontalDistance) / self.bounds.size.width
        return metersPerPixel
    }
}


@IBDesignable
public final class UIMapScaleView: UIView
{
    private let SCALE_BAR_HEIGHT = CGFloat(4.5)
    private let PADDING = CGFloat(1)

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
    
    public var direction: MapScaleExpandDirection = .leftToRight
    {
        didSet
        {
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
    }
    
    public var unit: MapScaleDistanceUnit = .metric
    {
        didSet
        {
            self.setNeedsLayout()
        }
    }
    
    public weak var scaleCalculator: MapScaleCalculator?
    
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
        
        guard let calculator = self.scaleCalculator else
        {
            return
        }
        

        let distance = self.calculateDistance(calculator.metersPerPixel)
        self.scaledWidth = distance.width
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
            
        label.text = String(format: "%d %@", distance.value, distance.unit)
        label.sizeToFit()

        label.frame = CGRect(
                      x: PADDING,
                      y: self.bounds.size.height - label.bounds.size.height - SCALE_BAR_HEIGHT - (PADDING*2),
                      width: self.bounds.width - (PADDING*2),
                      height: label.bounds.size.height)
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        
        switch self.direction
        {
            case .leftToRight:
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

                // draw body
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

            case .rightToLeft:
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

                // draw body
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
}


extension UIMapScaleView
{
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

        switch self.unit
        {
            case .metric:
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
                break
                
            case .imperial:
                var distance = (meters * 3.28)
                if distance >= 5280
                {
                    distance /= 5280
                    unit = "mi"
                }
                else
                {
                    unit = "ft"
                }
                
                maxValue = distance.roundDistance()
                scaleWidth = maxScaleWidth * CGFloat(maxValue) / distance
                break
        }
        
        return (scaleWidth, maxValue, unit)
    }
}


public struct MapScaleView: UIViewRepresentable
{
    public typealias UIViewType = UIMapScaleView
    
    private let scaleView = UIMapScaleView(frame: CGRect.zero)
    
    public init()
    {
    }
    
    @discardableResult
    public func bodyColor(_ color: Color) -> MapScaleView
    {
        self.scaleView.bodyColor = UIColor(color)
        return self
    }
    
    @discardableResult
    public func outlineColor(_ color: Color) -> MapScaleView
    {
        self.scaleView.outlineColor = UIColor(color)
        return self
    }
    
    @discardableResult
    public func direction(_ direction: MapScaleExpandDirection) -> MapScaleView
    {
        self.scaleView.direction = direction
        return self
    }
    
    @discardableResult
    public func unit(_ unit: MapScaleDistanceUnit) -> MapScaleView
    {
        self.scaleView.unit = unit
        return self
    }
    
    @discardableResult
    public func scaleCalculator(_ calculator: MapScaleCalculator) -> MapScaleView
    {
        self.scaleView.scaleCalculator = calculator
        return self
    }
    
    @discardableResult
    public func setNeedLayout() -> MapScaleView
    {
        self.scaleView.setNeedsLayout()
        return self
    }
    
    public func makeUIView(context: Context) -> UIMapScaleView
    {
        return self.scaleView
    }
    
    public func updateUIView(_ uiView: UIMapScaleView, context: Context)
    {
        uiView.backgroundColor = .clear
        uiView.setNeedsLayout()
    }
}


extension CGFloat
{
    fileprivate func roundDistance() -> Int
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

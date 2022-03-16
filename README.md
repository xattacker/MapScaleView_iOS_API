# MapScaleView_iOS_API

an iOS swift Map ScaleView UI View component 
<br><br>
Development Target: iOS 10
<br><br>
Provide a scale view with iOS MKMapView:<br>
<img src="/rm_res/cut1.png" alt="图片替换文本" width="50%" height="50%" align="bottom" /><br><br>


# Installation

### Cocoapods
MapScaleView can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'MapScaleView'
```

### Swift Package Manager
To add MapScaleView to a [Swift Package Manager](https://swift.org/package-manager/) based project, add:

```swift
.package(url: "https://github.com/xattacker/MapScaleView_iOS_API.git", .upToNextMajor(from: "1.2.0")),
```
to your `Package.swift` files `dependencies` array.
<br><br>

### How to use:

```
import MapScaleView

let scale_view: UIMapScaleView

scale_view.mapScaleCalculator = mapView //  setup with MKMapView
scale_view.outlineColor = UIColor.white
scale_view.bodyColor = UIColor.black
scale_view.direction = .leftToRight // set the bar start direction in leftToRight / rightToRight, default is leftToRight
scale_view.unit = .metric // you could set distance unit in metric / imperial, default is metric mode


// implement from MKMapViewDelegate
func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
{
   // udpate with mapView
   scaleView.setNeedsLayout()
}
```

### How to support Google Map API:

```
import MapScaleView
import GoogleMaps

let scale_view: UIMapScaleView

scale_view.mapScaleCalculator = mapView //  setup with GMSMapView

// implement from GMSMapViewDelegate
func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
{
   // update with mapView
   scaleView.setNeedsLayout()
}

// let GMSMapView implement protocol MapScaleCalculator that make it could support ScaleView
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
```

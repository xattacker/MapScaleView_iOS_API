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
.package(url: "https://github.com/xattacker/MapScaleView_iOS_API.git", .upToNextMajor(from: "1.1.0")),
```
to your `Package.swift` files `dependencies` array.
<br><br>

### How to use:

```
import MapScaleView

let scale_view: UIMapScaleView

scale_view.setup(mapView) // initial 
scale_view.unit = .metric // you could set distance unit by metric / imperial, default is metric


// implement from MKMapViewDelegate
func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
{
   // udpate with mapView
   scaleView.setNeedsLayout()
}
```

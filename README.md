# MapScaleView_iOS_API

a iOS swift Map ScaleView UI View component 

Provide a scale view with iOS MKMapView:<br>
![avatar](/rm_res/cut1.png)<br><br>


# Installation

### Cocoapods
MapScaleView can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'MapScaleView'
```


### How to use:

```
import MapScaleView

let scale_view: UIMapScaleView

scale_view.setup(mapView) // initial 


// implement from MKMapViewDelegate
func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
{
   scaleView.setNeedsLayout()
}
```

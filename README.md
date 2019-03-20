# MapScaleView_iOS_API

a iOS swift Map ScaleView UI View component 

Provide a scale view with iOS MKMapView:<br>
![avatar](/rm_res/cut1.png)<br><br>

### How to use:

```
let scale_view: UIMapScaleView


scale_view.setup(mapView) // initial 


// implement from MKMapViewDelegate
func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
{
   scaleView.setNeedsLayout()
}

```
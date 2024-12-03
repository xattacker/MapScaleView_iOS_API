//
//  ContentView.swift
//  MapScaleViewTester_SwiftUI
//
//  Created by xattacker.tao on 2024/12/3.
//  
//

import SwiftUI
import MapKit
import MapScaleView


struct ContentView: View {
    private let scaleCalculator = MyMapScaleCalculator()
    private let scaleView = MapScaleView()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.048105551746932, longitude: 121.51726423859233), // 台北車站
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03) // zoom lv
    )
    
    var body: some View {
        GeometryReader {
            geometry in
            ZStack(alignment: .topTrailing) {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .onChange(of: region) {
                        newRegion in
                        updateMetersPerPixel(newRegion, screenWidth: geometry.size.width)
                    }
                self.scaleView
                    .bodyColor(.black)
                    .outlineColor(.gray)
                    .direction(.rightToLeft)
                    .scaleCalculator(self.scaleCalculator)
                    .frame(minWidth: 0, maxWidth: 140, minHeight: 0, maxHeight: 30)
                    .padding([.trailing, .top], 10) // 偏移到右上角位置
            }
        }
    }
    
    private func updateMetersPerPixel(_ region: MKCoordinateRegion, screenWidth: CGFloat) {
        let latitude = region.center.latitude
        let latitudeDelta = region.span.latitudeDelta
        // 地圖可見區域的寬度（經度跨度轉換為公尺）
        let mapWidthInMeters = latitudeDelta * 111_320.0 * cos(latitude * .pi / 180) / 1000.0
        print("metersPerPixel: \(mapWidthInMeters)")
        
        self.scaleCalculator.metersPerPixel = mapWidthInMeters
        
        self.scaleView.setNeedLayout()
    }
}


fileprivate class MyMapScaleCalculator: MapScaleCalculator
{
    public var metersPerPixel: CGFloat = 0
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

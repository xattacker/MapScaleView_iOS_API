# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

use_frameworks!

workspace 'MapScaleView_iOS_API'
project 'MapScaleView/MapScaleView.xcodeproj'
project 'MapScaleViewTester/MapScaleViewTester.xcodeproj'

def tester_pods
   pod 'GoogleMaps', '8.4.0'
end

target 'MapScaleViewTester' do
   project 'MapScaleViewTester/MapScaleViewTester.xcodeproj'
   tester_pods
end




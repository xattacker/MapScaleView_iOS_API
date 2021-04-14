Pod::Spec.new do |s|
  s.name = 'MapScaleView'
  s.version = '1.2.0'
  s.license = 'BSD'
  s.summary = 'MapScaleView iOS Swift API'
  s.homepage = 'https://github.com/xattacker/MapScaleView_iOS_API'
  s.authors = { 'Xattacker' => 'amigo.xattacker@gmail.com' }
  s.source = { :git => 'https://github.com/xattacker/MapScaleView_iOS_API.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.requires_arc = true
  s.source_files = 'MapScaleView_iOS_API/Sources/*.swift'
end

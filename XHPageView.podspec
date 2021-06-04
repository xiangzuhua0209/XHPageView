Pod::Spec.new do |s|
  s.name         = 'XHPageView'
  s.version      = '1.0.0'
  s.swift_version = '5.0'
  s.summary      = 'Simple Tabs'
  s.description  = <<-DESC
			News Categories, Slide toggle, Tabs, Title Options，ViewControllers
			DESC
  s.homepage     = 'https://github.com/xiangzuhua0209/XHPageView'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'xiangzuhua' => 'xiangzhuhua0209@126.com' }
  s.ios.deployment_target = "13.0"
  s.source       = { :git => 'https://github.com/xiangzuhua0209/XHPageView.git', :tag => s.version }
  s.source_files = 'XHPageView/*.swift'
  s.requires_arc = true	
end

Pod::Spec.new do |s|
  s.name         = "CollectionViewIndex"
  s.version      = "3.0.0"
  s.summary      = "View that replicates the built in UITableView section index, but for use in UICollectionView."
  s.author       = 'Hilton Campbell'
  s.homepage     = "https://github.com/CrossWaterBridge/CollectionViewIndex"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/CrossWaterBridge/CollectionViewIndex.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'CollectionViewIndex/*.swift'
  s.requires_arc = true
end

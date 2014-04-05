Pod::Spec.new do |s|
  s.name         = "KLCollectionLayouts"
  s.version      = "0.0.1"
  s.summary      = "A collection of different UICollectionViewLayout subclasses"

  s.description  = <<-DESC
                   A library of UICollectionViewLayout subclasses for various purposes.
                   Presently contains an anchored header/footer flow layout that allows for sticky headers and footers.
                   DESC
  s.homepage     = "http://github.com/klundberg/KLCollectionLayouts"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Kevin Lundberg" => "kevinrlundberg@gmail.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/klundberg/KLCollectionLayouts.git", :tag => "0.0.1" }
  s.source_files = "KLCollectionLayouts/*.{h,m}"
  s.requires_arc = true
end

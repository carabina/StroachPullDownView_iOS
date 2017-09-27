Pod::Spec.new do |spec|
  spec.name = "StroachPullDownView_iOS"
  spec.version = "1.0.1"

  spec.homepage = "https://github.com/lukastruemper/StroachPullDownView_iOS"
  spec.summary = "Pulldown-based controls written in Swift."

  spec.author = { "Lukas Trümper" => "lukas.truemper@outlook.de" }
  spec.license = { :type => "MIT", :file => "LICENSE" }

  spec.platform = :ios, '10.3'
  spec.ios.deployment_target = '10.3'

  spec.source = { :git => "https://github.com/lukastruemper/StroachPullDownView_iOS.git", :tag => 'v1.0.1' }

  spec.source_files = "StroachPullDownView_iOS/*.swift"
end

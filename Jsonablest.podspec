Pod::Spec.new do |s|
  s.name = "Jsonablest"
  s.version = "2.0.2"
  s.license = 'MIT'
  s.summary = "JSON encoding/decoding library for Swift 3"
  s.homepage     = "https://github.com/jeden/jsonablest"
  s.authors = { "Antonio Bello" => "jeden@elapsus.com" }
  s.social_media_url   = "http://twitter.com/ant_bello"
  s.source = { :git => "https://github.com/jeden/jsonablest.git", :tag => '2.0.2' }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  #s.watchos.deployment_target = "2.0"

  s.source_files  = "source/**/*.swift"
end

Pod::Spec.new do |spec|
  spec.name         = "NetworkLibsCombine"
  spec.version      = "1.0.0"
  spec.summary      = "A small framework to monitor network changes in Swift."
  spec.description  = <<-DESC
                    Network utiliser using Combine and URLSession. Really fit with Reactive Programming architecture.
                   DESC
  spec.homepage     = "https://github.com/mazmik25/NetworkLibsCombine"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Azmi M" => "azmimuh25@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/mazmik25/NetworkLibsCombine.git", :tag => "#{spec.version}" }
  spec.source_files = "NetworkLibsCombine/Source/*.{swift}"
  spec.swift_version = "5.0"
end
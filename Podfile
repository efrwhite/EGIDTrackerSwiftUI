# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

use_frameworks!

def shared_pods
  pod 'DGCharts', '>= 5.1.0'
end

target 'Testing_Ground' do
  shared_pods

  target 'Testing_GroundTests' do
    inherit! :search_paths
  end

  target 'Testing_GroundUITests' do
    inherit! :search_paths
  end
end

target 'EGIDTrackerSwiftUI' do
  shared_pods

  target 'EGIDTrackerSwiftUITests' do
    inherit! :search_paths
  end

  target 'EGIDTrackerSwiftUIUITests' do
    inherit! :search_paths
  end
end

# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'beacon_test'
  app.api_version = '19'
  # app.vendor_project :jar => "vendor/android-support-v4.jar"
  app.vendor_project :jar => "vendor/android-support-v7-appcompat.jar"
  app.vendor_project :jar => "vendor/android-support-v13.jar"
  app.vendor_project :jar => "vendor/android-beacon-library-2.1-beta4.jar"
  app.permissions << :bluetooth
  app.permissions << :bluetooth_admin
  app.services += ["org.altbeacon.beacon.service.BeaconService"]
  app.services += ["org.altbeacon.beacon.BeaconIntentProcessor"]
end

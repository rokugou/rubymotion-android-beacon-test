class MainActivity < Android::App::Activity
  TAG = "RangingActivity"
  attr_accessor :beacon_manager

  def onCreate(savedInstanceState)
    super
    @beacon_manager = Org::Altbeacon::Beacon::BeaconManager.getInstanceForApplication(self)
    # for kontakt beacon
    @beacon_manager.getBeaconParsers().add(Org::Altbeacon::Beacon::BeaconParser.new.setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25"))
    @beacon_manager.bind(self)

    linear_layout = Android::Widget::LinearLayout.new(self)
    linear_layout.setBackgroundColor(Android::Graphics::Color::BLACK)
    linear_layout.setOrientation(Android::Widget::LinearLayout::VERTICAL)
    setContentView(linear_layout)

    @beacon_text_view = Android::Widget::TextView.new(self)
    @beacon_text_view.setText("Beacon: not found")
    @beacon_text_view.setTextSize(30.0)
    @beacon_text_view.setTextColor(Android::Graphics::Color::CYAN)

    @closest_beacon_text_view = Android::Widget::TextView.new(self)
    @closest_beacon_text_view.setText("Beacon: not found")
    @closest_beacon_text_view.setTextSize(30.0)
    @closest_beacon_text_view.setTextColor(Android::Graphics::Color::CYAN)

    linear_layout.addView(@closest_beacon_text_view)
    linear_layout.addView(@beacon_text_view)
  end

  def onDestroy
    super
    @beacon_manager.unbind(self)
  end

  def onBeaconServiceConnect
    p "onBeaconServiceConnect"
    notifier = RubyRangeNotifier.new({
                                         closest_beacon: lambda{|beacon|
                                           runOnUiThread(RubyRunnable.new(
                                                             {
                                                                 run: lambda {
                                                                   if beacon.nil?
                                                                     @closest_beacon_text_view.setText("Beacon: not found")
                                                                   else
                                                                     @closest_beacon_text_view.setText("Beacon: #{beacon.getId2().toString()} - #{beacon.getId3().toString()}")
                                                                   end
                                                                 }
                                                             }
                                                         ))
                                         },
                                         beacon_change: lambda{|beacon|
                                           runOnUiThread(RubyRunnable.new(
                                                             {
                                                                 run: lambda {
                                                                   if beacon.nil?
                                                                     @beacon_text_view.setText("Beacon: not found")
                                                                   else
                                                                     @beacon_text_view.setText("Beacon: #{beacon.getId2().toString()} - #{beacon.getId3().toString()}")
                                                                   end
                                                                 }
                                                             }
                                                         ))
                                         }
                                     })
    @beacon_manager.setRangeNotifier(notifier)
    region = Org::Altbeacon::Beacon::Region.new("myRangingUniqueId", nil, nil, nil)
    @beacon_manager.startRangingBeaconsInRegion(region)
  end

  # for interface
  def bindService(intent, connection, mode)
    super
  end

  # for interface
  def unbindService(connection)
    super
  end

  # for interface
  def getApplicationContext
    super
  end
end

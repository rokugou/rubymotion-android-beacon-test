class RubyRangeNotifier
  CHANGE_NUM = 3
  attr_accessor :change_count, :stay_beacon, :last_beacon
  def initialize(events = {})
    @change_count = 0
    @events = events

    self
  end

  def didRangeBeaconsInRegion(beacons, region)
    p "didRangeBeaconsInRegion(beacons, region)"
    if beacons.size == 0
      p "no beacon"
      @change_count = 0
      @events[:closest_beacon].call(nil) unless @events[:closest_beacon].nil?
      update_stay_beacon(nil)
    else
      closest_beacon = beacons.first
      if beacons.size > 1
        beacons.each_with_index do |beacon, index|
          closest_beacon = beacon if Java::Lang::Double.compare(closest_beacon.getDistance(), beacon.getDistance()) > 0
        end
      end
      @events[:closest_beacon].call(closest_beacon) unless @events[:closest_beacon].nil?
      unless @last_beacon.nil?
        p @last_beacon.getId3().toString()
        p @last_beacon.getDistance().toString()
      else
        p "no last beacon"
      end
      p closest_beacon.getId3().toString()
      p closest_beacon.getDistance().toString()
      if @stay_beacon.nil?
        @last_beacon = closest_beacon
        update_stay_beacon(closest_beacon)
      elsif !compare_beacon(@stay_beacon, closest_beacon)
        if compare_beacon(@last_beacon, closest_beacon)
          @change_count += 1
          if @change_count == CHANGE_NUM
            @change_count = 0
            update_stay_beacon(closest_beacon)
          end
        else
          @change_count = 1
        end
        @last_beacon = closest_beacon
      end
    end
    #
    # p beacons.size
    # beacons.each do |beacon|
    #   p "uuid: #{beacon.getId1().toString()}"
    #   p "major: #{beacon.getId2().toString()}"
    #   p "minor: #{beacon.getId3().toString()}"
    #   p "distance: #{beacon.getDistance().toString()}"
    # end
    # @events[:beacon_found].call(beacons, region) unless @events[:beacon_found].nil?
  end

  def compare_beacon(beacon_1, beacon_2)
    beacon_1.getBluetoothAddress() == beacon_2.getBluetoothAddress()
  end

  def update_stay_beacon(beacon)
    p "update_stay_beacon(beacon)"
    @stay_beacon = beacon
    @events[:beacon_change].call(beacon) unless @events[:beacon_change].nil?
  end
end
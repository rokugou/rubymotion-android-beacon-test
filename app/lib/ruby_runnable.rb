class RubyRunnable
  def initialize(events = {})
    @events = events

    self
  end

  def run
    @events[:run].call unless @events[:run].nil?
  end
end
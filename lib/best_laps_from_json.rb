require 'json'

class BestLapsFromJson
  def initialize(json)
    @json = json
  end

  def call
    laps = JSON.parse(json)
    grouped_by_track = laps.group_by { |lap| lap["trackid"] }
    best_laps(grouped_by_track)
  end

  private 

  def best_lap_on_track(laps_data)
    {
      track_name: track_name(laps_data),
      best_lap: best_lap(laps_data)
    }
  end

  def best_laps(grouped_by_track)
    grouped_by_track.map { |_trackid, laps_data| best_lap_on_track(laps_data) }
  end

  def track_name(laps_data)
    laps_data.first["trackname"].gsub("+", ' ')
  end

  def best_lap(laps_data)
    laps_data.map { |lap_data| lap_data["bestlaptimeformatted"].gsub("%3A", '.') }.min
  end

  attr_reader :json
end
# frozen_string_literal: true

class IrDataAdapter
  Track = Struct.new(:id, :name)

  def call
    # sort by most tracks played
    sorted = data.sort_by do |driver_data|
      driver_data[:user_bests].uniq { |el| el["trackid"] }.count
    end

    # select tracks to display
    tracks = sorted.last[:user_bests].map do |track_info|
      Track.new(track_info['trackid'], track_info['trackname'].gsub("+", ' '))
    end.uniq

    if options[:filter] == :current
      tracks.select! { |track| season_tracks_ids.include?(track.id)  }
    end

    tracks.map do |track| 
      {
        track_name: track.name,
        best_laps: best_laps_for(track.id)
      }
    end
  end

  private

  def best_laps_for(track_id)
    best_laps = data.map do |driver_data|
      laps = driver_data[:user_bests].select { |driver_data| driver_data['trackid'] == track_id }

      {
        username: driver_data[:user_name],
        best_lap: find_best_lap(laps)
      }
    end

    best_laps.delete_if { |lap| lap[:best_lap].nil? }.sort_by { |lap| lap[:best_lap] }
  end

  def find_best_lap(laps)
    return if laps.empty?

    laps.map do |lap|
      lap_time = lap['bestlaptimeformatted']
      lap_time.match(/\A00/) ? nil : lap_time.gsub("%3A", '.') 
    end.min
  end

  def season_tracks_ids
    [352, 212, 144, 109, 5, 324, 319, 249, 199, 163, 233, 219]
  end

  attr_reader :data, :options

  def initialize(data, options = {})
    @data = data
    @options = options
  end
end
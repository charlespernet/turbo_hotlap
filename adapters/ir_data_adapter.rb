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
      if laps.any?
        best_lap = laps.map { |lap| lap['bestlaptimeformatted'].gsub("%3A", '.') }.min
      else
        best_lap = nil
      end
      
      {
        username: driver_data[:user_name],
        best_lap: best_lap
      }
    end

    best_laps.delete_if { |lap| lap[:best_lap].nil? }.sort_by { |lap| lap[:best_lap] }
    # laps.delete_if { |lap| lap['bestlaptimeformatted'] }
  end


  def season_tracks_ids
    [166, 346, 152, 350, 2, 249, 163, 145, 149, 319, 180, 218]
  end

  attr_reader :data, :options

  def initialize(data, options = {})
    @data = data
    @options = options
  end
end
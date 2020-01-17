require 'dotenv/load'
require_relative 'lib/ir_data_for_users'

class Application
  def self.run
    data = IrDataForUsers.new(default_users).call
    # Push Data to discord Bot
    temp_display(data)
  end

  private

  def self.default_users
    [
      OpenStruct.new({ name: "Anthony", id: "406148" }), 
      OpenStruct.new({ name: "Charles", id: "404308" })
    ]
  end

  def self.temp_display(data)
    puts 'Les meilleurs de Turbo'
    data.each do |user|
      puts "=" * 10
      puts "#{user[:user_name]}"
      user[:best_laps].each do |lap| 
        puts "#{lap[:track_name]} - #{lap[:best_lap]}"
      end
      puts "=" * 10
    end
  end
end

Application.run
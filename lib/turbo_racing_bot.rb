# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'

class TurboRacingBot
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def self.run
    bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']

    bot.message(content: 'TurboLaps') do |event|
      data = IrDataForUsers.new(default_users).call
      event.respond discord_message(data)
    end

    bot.run
  end

  private

  def self.default_users
    YAML.load(File.read("data/users.yml")).map { |user_data| User.new(user_data) }
  end

  def self.discord_message(data)
    <<~DISCORD_MESSAGE
      Les temps du championnat Skip Barber
      #{'=' * 10}
      #{build_message(data)}
    DISCORD_MESSAGE
  end

  def self.build_message(data)
    data.each do |user|
      <<~USER_LAPS
        "#{user[:user_name].upcase}"
        '-' * 10
        user[:best_laps].each do |lap| 
          "#{lap[:track_name]} - #{lap[:best_lap]}"
        end
        #{'=' * 10}
      USER_LAPS
    end
  end
end
# frozen_string_literal: true
require 'discordrb'
require 'dotenv/load'
require 'yaml'
require_relative 'ir_data_for_users'

class TurboRacingBot
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def self.start
    bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']

    bot.message(content: 'Who is faster ?') do |event|
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
      **Fastest Turbos**

      #{build_message(data)}
    DISCORD_MESSAGE
  end

  def self.build_message(data)
    data.map do |user|
      <<~USER_LAPS
        #{user[:user_name].upcase}
        #{build_user_laps(user[:best_laps])}
      USER_LAPS
    end
  end

  def self.build_user_laps(laps)
    laps.map do |lap|
      "#{lap[:track_name]} - #{lap[:best_lap]}"
    end
  end
end
# frozen_string_literal: true

require 'discordrb'
require 'yaml'
require_relative 'ir_data_for_users'

class TurboRacingBot
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def self.start
    bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], prefix: '!'

    bot.command :turbolaps do |event|
      data = IrDataForUsers.new(default_users).call
      build_message(event, data)
    end

    bot.run
  end

  private

  def self.default_users
    YAML.load(File.read("data/users.yml")).map { |user_data| User.new(user_data) }
  end

  def self.build_message(event, data)
    event << '**Fastest  Turbos**'

    data.each do |user|
      event << ''
      event << "__#{user[:user_name].upcase}__"
      user[:best_laps].each do |user_lap|
        event << "*#{user_lap[:track_name]}* - **#{user_lap[:best_lap]}**"
      end
    end
    nil
  end
end
# frozen_string_literal: true

require 'yaml'
require_relative '../adapters/ir_data_adapter'

class TurboRacingBot
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def start
    ir_bot.login

    discord_bot.command :turbolaps do |event|
      data = ir_bot.fetch_data_for(default_users)
      formatted_data = IrDataAdapter.new(data).call

      build_message(event, formatted_data)
    end

    discord_bot.run
  end

  private

  attr_reader :discord_bot, :ir_bot

  def initialize(discord_bot, ir_bot)
    @discord_bot = discord_bot
    @ir_bot = ir_bot
  end

  def default_users
    YAML.load(File.read("data/users.yml")).map { |user_data| User.new(user_data) }
  end

  def build_message(event, data)
    event << '**Fastest Turbos by Track**'

    data.each do |track|
      event << ''
      event << "__#{track[:track_name].upcase}__"
      track[:best_laps].each do |user_lap|
        event << "*#{user_lap[:username]}* - **#{user_lap[:best_lap]}**"
      end
    end
    nil
  end
end
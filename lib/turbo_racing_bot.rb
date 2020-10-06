# frozen_string_literal: true

require 'yaml'
require_relative '../adapters/ir_data_adapter'

class TurboRacingBot
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def start
    ir_client.login

    discord_bot.command :turbolaps, description: 'List best laps' do |event, options|
      data = ir_client.fetch_data_for(default_users)
      if options == 'all'
        formatted_data = IrDataAdapter.new(data).call
      else
        formatted_data = IrDataAdapter.new(data, filter: :current).call
      end

      build_message(event, formatted_data)
    end

    discord_bot.run
  end

  private

  attr_reader :discord_bot, :ir_client

  def initialize(discord_bot, ir_client)
    @discord_bot = discord_bot
    @ir_client = ir_client
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
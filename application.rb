# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require_relative 'lib/ir_bot'
require_relative 'lib/turbo_racing_bot'

discord_bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], prefix: '!'
ir_bot = IrBot.new

TurboRacingBot.new(discord_bot, ir_bot).start
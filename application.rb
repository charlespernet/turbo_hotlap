# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require_relative 'lib/ir_client'
require_relative 'lib/turbo_racing_bot'

discord_bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'], prefix: '!'
ir_client = IrClient.new

TurboRacingBot.new(discord_bot, ir_client).start
# frozen_string_literal: true

require 'dotenv/load'
require 'yaml'
require_relative 'lib/ir_data_for_users'

class Application
  User = Struct.new(:name, :ir_id, keyword_init: true)

  def self.run
    data = IrDataForUsers.new(default_users).call
    # Push Data to discord Bot
    temp_display(data)
  end

  private

  def self.default_users
    YAML.load(File.read("data/users.yml")).map { |user_data| User.new(user_data) }
  end

  def self.temp_display(data)
    puts 'Les meilleurs de Turbo'
    puts "=" * 10
    data.each do |user|
      puts "#{user[:user_name].upcase}"
      puts '-' * 10
      user[:best_laps].each do |lap| 
        puts "#{lap[:track_name]} - #{lap[:best_lap]}"
      end
      puts "=" * 10
    end
  end
end

Application.run
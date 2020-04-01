# frozen_string_literal: true

require 'mechanize'
require_relative '../adapters/best_laps_adapter'

class IrDataForUsers
  def call
    login

    build_data_for_users
  end

  private

  SKIP_BARBER_ID = 1
  BASE_URL = "https://members.iracing.com/memberstats/member/GetPersonalBests?carid=#{SKIP_BARBER_ID}&custid="

  attr_reader :users, :agent

  def initialize(users)
    @users = users
    @agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Mozilla' }
  end

  def login
    agent.get('https://members.iracing.com/membersite/login.jsp') do |page|
      page.form_with(:action => '/membersite/Login') do |f|
        f.username = ENV['IR_EMAIL']
        f.password = ENV['IR_PASSWORD']
      end.click_button
    end
  end

  def build_data_for_users
    users.map do |user|
      url = "#{BASE_URL}#{user.ir_id}"
      ir_json = agent.get(url).body

      {
        user_id: user.ir_id,
        user_name: user.name,
        best_laps: BestLapsAdapter.new(ir_json).call
      }
    end
  end
end
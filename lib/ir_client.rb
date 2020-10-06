# frozen_string_literal: true

require 'mechanize'
require 'json'

class IrClient
  def login
    agent.get('https://members.iracing.com/membersite/login.jsp') do |page|
      page.form_with(:action => '/membersite/Login') do |f|
        f.username = ENV['IR_EMAIL']
        f.password = ENV['IR_PASSWORD']
      end.click_button
    end
  end

  def fetch_data_for(users)
    users.map do |user|
      url = "#{BASE_URL}#{user.ir_id}"
      ir_json = agent.get(url).body

      {
        user_name: user.name,
        user_bests: JSON.parse(ir_json)
      }
    end
  end

  private

  SKIP_BARBER_ID = 1
  BASE_URL = "https://members.iracing.com/memberstats/member/GetPersonalBests?carid=#{SKIP_BARBER_ID}&custid="

  attr_reader :agent

  def initialize
    @agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Mozilla' }
  end
end
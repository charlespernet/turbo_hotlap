# frozen_string_literal: true

require 'rest-client'
require_relative '../adapters/best_laps_adapter'

class IrDataForUsers
  def call
    users.map do |user|
      url = "#{BASE_URL}#{user.ir_id}"
      ir_json = RestClient.get(url, headers)
      
      {
        user_id: user.ir_id,
        user_name: user.name,
        best_laps: BestLapsAdapter.new(ir_json).call
      }
    end
  end

  private

  attr_reader :users

  SKIP_BARBER_ID = 1
  BASE_URL = "https://members.iracing.com/memberstats/member/GetPersonalBests?carid=#{SKIP_BARBER_ID}&custid="

  def initialize(users)
    @users = users
  end

  def headers
    {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2)",
      "accept" => "*/*",
      "cookie" => ENV['IRCOOKIE']
    }
  end
end
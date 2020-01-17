require 'rest-client'
require_relative 'best_laps_from_json'

class IrDataForUsers
  def call
    users.map do |user|
      url = "#{BASE_URL}#{user.id}"
      {
        user_id: user.id,
        user_name: user.name,
        best_laps: BestLapsFromJson.new(RestClient.get(url, headers)).call
      }
    end
  end

  private

  attr_reader :users

  BASE_URL = "https://members.iracing.com/memberstats/member/GetPersonalBests?carid=1&custid="

  def initialize(users)
    @users = users
  end

  def headers
    {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2)",
      "accept" => "*/*",
      "cookie" => ENV['cookie']
    }
  end
end
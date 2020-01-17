require 'rest-client'
require_relative 'adapter'

class IRacingDataForUser
  BASE_URL = "https://members.iracing.com/memberstats/member/GetPersonalBests?carid=1&custid="

  def initialize(cust_id)
    @cust_id = cust_id
  end

  def call
    {
      user_id: cust_id,
      user_name: 
      best_laps: Adapter.new(RestClient.get(url, headers)).call
    }
  end

  private

  attr_reader :cust_id

  def url
    "#{BASE_URL}#{cust_id}"
  end

  def cookie
    "JSESS_members-memberstats-bosdkr05=E762001FF9DA8E1E3C4A8E569AB4CCE0;; JSESS_members-memberstats-bosdkr03=16CF59E139D1E18D45DEF848267C47E1; JSESS_members-memberstats-bosdkr05=42322C36538B1B65CB1C486EAC0D34CD; XROUTE_UID=AAAAAV4hxgIVyWnNBpFyAg==; AWSALB=/HRYMdRutI+aXn9ROye3QgcMBWlA6J/+2U/E4esJNofDhAFA5iOVyQKOZvTHPwRs/DQDWFd1wa8ipovFKBCKU3+abtKDNJENsvu+mXb/PtIKrCzBN5dSswf6QUls; irsso_membersv2=D93269D4CB86B45CC1E73444A7EE033A26ECDDB845C7CD0D55575A360D5BF61EFA42E8748B4A580A930D091112665DBD488A19A41D8963C4C60D6CD9661C0B7E427DCFC42C03A1EE0852C067A73436EC334AC59B90A9B219DABE6AA03FCB83039A2B12B80B7593DFF1728E6A5795C773E480D5C61889F8C7D8EB99A032A5D369; XSESSIONID=BTC05ms|XiHUo|XiHUY"
  end

  def headers
    {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2)",
      "accept" => "*/*",
      "cookie" => cookie
    }
  end
end
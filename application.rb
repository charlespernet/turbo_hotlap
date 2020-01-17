require_relative 'i_racing_data_for_user'

class Application
  def self.run
    data = default_users.map { |user| IRacingDataForUser.new(user).call }
    # Push Data to discord Bot
  end

  private

  def self.default_users
    [
      OpenStruct.new({ name: "Anthony", id: "406148" }), 
      OpenStruct.new({name: "Charles", id: "404308"})
    ]
  end
end

p Application.run
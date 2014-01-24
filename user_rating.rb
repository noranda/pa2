# user_rating.rb
# Written by: Noranda Brown
# Version: 2014.1.23

class UserRating

  attr_reader :user_id, :rating, :timestamp

  def initialize(user_id, rating, timestamp)
    @user_id = user_id
    @rating = rating
    @timestamp = timestamp
  end
end
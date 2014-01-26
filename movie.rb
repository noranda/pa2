# movie.rb
# Written by: Noranda Brown
# Version: 2014.1.25

class Movie

  attr_reader :movie_id

  def initialize(movie_id)
    @movie_id = movie_id
    @user_ratings = []
    @sum_ratings = nil
  end

  # adds a user_id, rating and timestamp to a movie
  def add_rating(user_id, rating, timestamp)
    @user_ratings << UserRating.new(user_id, rating, timestamp)
    @sum_ratings = nil
  end

  # returns the sum of all ratings for a movie
  def sum_ratings
    @sum_ratings ||= @user_ratings.map(&:rating).inject(&:+).to_f
  end

  # returns true if user_id has rated a movie and false otherwise
  def user_rated?(user_id)
    @user_ratings.map(&:user_id).include?(user_id)
  end

  # returns the user rating from user_id for a movie if the movie was rated by the user, else returns 0
  def user_rating(user_id)
    if user_rated?(user_id)
      @user_ratings.select { |user_rating| user_rating.user_id == user_id }.first.rating
    else
      0
    end
  end

  # returns a sorted list of users that reviewed the movie
  def user_list
    @user_ratings.map(&:user_id).sort
  end
end
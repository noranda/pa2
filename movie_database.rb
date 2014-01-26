# movie_database.rb
# Written by: Noranda Brown
# Version: 2014.1.26

class MovieDatabase
  def initialize
    @movies = {}
    @users = []
  end

  ##
  # returns the movie instance that belongs to the +movie_id+
  def [](movie_id)
    @movies[movie_id]
  end

  ##
  # list of all users that have rated at least one movie; accepts an optional parameter +except_for+ which removes a
  # specific user ID from the returned list
  def users(except_for = nil)
    return @users if except_for.nil?
    @users - [except_for]
  end

  ##
  # adds movie rating to movie, creating the movie if it does not already exist
  def add_movie_rating(movie_id, user_id, rating, timestamp)
    @movies[movie_id] ||= Movie.new(movie_id)
    @movies[movie_id].add_rating(user_id, rating, timestamp)
    @users << user_id unless @users.include?(user_id)
  end

  ##
  # returns true if all +user_ids+ passed in are in the movie database
  def users_include?(*user_ids)
    user_ids.map { |user_id| @users.include?(user_id) }.all?
  end

  ##
  # returns true if all +movie_ids+ passed in are in the movie database
  def movies_include?(*movie_ids)
    keys = @movies.keys
    movie_ids.map { |movie_id| keys.include?(movie_id) }.all?
  end

  ##
  # returns an array of movies rated by the +user_id+
  def movies_user_rated(user_id)
    @movies.select { |_, movie| movie.user_rated?(user_id) }.values
  end

  ##
  # returns and array of movies in common between +user1_id+ and +user2_id+
  def movies_in_common(user1_id, user2_id)
    @movies.select { |_, movie| movie.user_rated?(user1_id, user2_id) }.values
  end

  ##
  # returns the maximum sum of all ratings across all movies in the movie database
  def max_sum_ratings
    @movies.map { |_, movie| movie.sum_ratings }.max
  end

  ##
  # returns a number +0.0+ - +100.0+ that indicates the popularity (higher numbers are more popular) of +movie_id+
  def popularity(movie_id)
    raise 'Movie does not exist.' unless movies_include?(movie_id)
    result = @movies[movie_id].sum_ratings * 100.0 / max_sum_ratings.to_f # calculates popularity and normalizes
    result.round(1)
  end

  ##
  # generates a list of all movie ids ordered by decreasing popularity
  def popularity_list
    @movies.values.sort { |movie1, movie2| popularity(movie2.movie_id) <=> popularity(movie1.movie_id) }.map(&:movie_id)
  end
end
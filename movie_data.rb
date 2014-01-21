# movie_data.rb
# Written by: Noranda Brown
# Version: 2014.1.18

class MovieData

  def initialize
    @movies = {}
  end

  # reads in data from the original ml-100k files and stores movie objects in a hash
  def load_data
    File.open("ml-100k/u.data", "r") do |file|
      file.each do |line|
        line_array = line.split("\t")
        user_id = line_array[0].to_i
        movie_id = line_array[1].to_i
        rating = line_array[2].to_i
        timestamp = line_array[3].to_i
        @movies[movie_id] ||= Movie.new(movie_id)
        @movies[movie_id].add_rating(user_id, rating, timestamp)
      end
    end
  end

  # returns a number (0 - 100) that indicates the popularity (higher numbers are more popular)
  def popularity(movie_id)
    max_sum_ratings = @movies.values.map { |movie| movie.sum_ratings }.max # determines max sum_ratings
    @movies[movie_id.to_i].sum_ratings * 100.0 / max_sum_ratings # calculates popularity and normalizes
  end

  # generates a list of all movie_id’s ordered by decreasing popularity
  def popularity_list
    @movies.values.sort_by { |movie| popularity(movie.movie_id) }.reverse.map(&:movie_id)
  end

  # generate a number (0 - 100) which indicates the similarity in movie preference between
  # user1 and user2 (higher numbers indicate greater similarity)
  def similarity(user1, user2)
    common_movies = @movies.values.select { |movie| movie.user_rated?(user1.to_i) && movie.user_rated?(user2.to_i) }
    return 0.0 if common_movies.empty? # Common case
    rating_sum = common_movies.inject(0) { |sum, movie| sum + (movie.user_rating(user1.to_i) - movie.user_rating(user2.to_i)).abs }
    max_rating_sum = 4 * common_movies.length
    100.0 - (rating_sum.to_f / max_rating_sum.to_f * 100.0)
  end

  # returns an array list of the top number_of_users (default = 5) whose tastes are most similar to the tastes of user u
  # with the most_similar users at the front of the array
  def most_similar(u, number_of_users = 5)
    similarity_hash = other_users(u.to_i).inject({}) { |user_similarity, user_id| user_similarity.merge({user_id => similarity(u.to_i, user_id)}) }
    similarity_hash.sort_by { |user_similarity| user_similarity[1] }.reverse.take(number_of_users).map(&:first)
  end

  private

  # list of all users except u
  def other_users(u)
    @movies.values.map(&:user_list).flatten.uniq - [u]
  end
end

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

  # returns the user rating from user_id for a movie
  def user_rating(user_id)
    @user_ratings.select { |user_rating| user_rating.user_id == user_id }.first.rating if user_rated?(user_id)
  end

  # returns a list of users that reviewed the movie
  def user_list
    @user_ratings.map(&:user_id)
  end
end

class UserRating

  attr_reader :user_id, :rating, :timestamp

  def initialize(user_id, rating, timestamp)
    @user_id = user_id
    @rating = rating
    @timestamp = timestamp
  end
end
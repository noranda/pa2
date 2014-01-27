# movie_similarity.rb
# Written by: Noranda Brown
# Version: 2014.1.26

class MovieSimilarity
  def initialize(movie_database)
    @movie_database = movie_database
  end

  ##
  # generates a number +0.0+ - +100.0+ which indicates the similarity in movie
  # preference between +user1_id+ and +user2_id+ (higher numbers indicate greater similarity)
  def similarity(user1_id, user2_id)
    raise 'At least one user specified does not exist.' unless @movie_database.users_include?(user1_id, user2_id)
    user_common_movies = @movie_database.movies_in_common(user1_id, user2_id)

    return 0.0 if user_common_movies.empty? # most common case

    rating_sum = user_common_movies.inject(0) { |sum, movie| sum + user_rating_difference(movie, user1_id, user2_id) }
    max_rating_sum = 4 * user_common_movies.length
    100.0 - (rating_sum.to_f / max_rating_sum.to_f * 100.0).round(1)
  end

  ##
  # returns an array list of the top number of users whose tastes are most similar to the
  # tastes of +user_id+ with the most similar users at the front of the array; excludes users with similarity = 0.0
  def most_similar(user_id)
    return [] unless @movie_database.users_include?(user_id)
    sim_hash = similarity_hash(user_id)
    sim_hash.reject! { |user, similarity| similarity == 0.0 }
    sim_hash.sort { |a, b| b[1] <=> a[1] }.map(&:first)
  end

  ##
  # returns a floating point number between +1.0+ and +5.0+ as an estimate of what +user_id+ would rate +movie_id+
  def predict(user_id, movie_id)
    raise 'User or movie does not exist.' unless @movie_database.users_include?(user_id) && @movie_database.movies_include?(movie_id)
    products, weights = predict_product_weights(movie_id, user_id)
    return 1.0 unless weights > 0
    result = products / weights
    result.round(1)
  end

  private ########################################################################

  ##
  # returns the absolute value of the difference between ratings of +movie+ by +user1_id+ and +user2_id+
  def user_rating_difference(movie, user1_id, user2_id)
    (movie.user_rating(user1_id) - movie.user_rating(user2_id)).abs
  end

  ##
  # returns a hash of user => similarity between +user_id+ and all other users
  def similarity_hash(user_id)
    @movie_database.users(user_id).inject({}) do |user_similarity, user|
      user_similarity.merge({user => similarity(user_id, user)})
    end
  end

  def predict_product_weights(movie_id, user_id)
    products = 0.0
    weights = 0.0
    @movie_database[movie_id].user_list.each do |user|
      next if user == user_id # don't count the users own rating
      sim = similarity(user_id, user)
      products += @movie_database[movie_id].user_rating(user) * sim
      weights += sim
    end
    return products, weights
  end
end
# movie_data.rb
# Written by: Noranda Brown
# Version: 2014.1.24

require "pathname"

class MovieData

  def initialize(folder_name, set_pair = nil)
    @training_movies = {}
    @test_movies = {}
    folder_path = Pathname.new(folder_name)
    if set_pair.nil?
      training_path = folder_path.join("u.data")
    else
      training_path = folder_path.join("#{set_pair}.base")
      load_data(folder_path.join("#{set_pair}.base"), @test_movies)
    end
    load_data(training_path, @training_movies)
  end

  # returns a number (0 - 100) that indicates the popularity (higher numbers are more popular) of movie_id from movie_hash
  def popularity(movie_id, movie_hash)
    max_sum_ratings = movie_hash.values.map { |movie| movie.sum_ratings }.max # determines max sum_ratings
    movie_hash[movie_id.to_i].sum_ratings * 100.0 / max_sum_ratings # calculates popularity and normalizes
  end

  # generates a list of all movie_id’s from movie_hash ordered by decreasing popularity
  def popularity_list(movie_hash)
    movie_hash.values.sort_by { |movie| popularity(movie.movie_id, movie_hash) }.reverse.map(&:movie_id)
  end

  # generate a number (0 - 100) which indicates the similarity in movie preference between user1 and user2 from movie_hash
  # (higher numbers indicate greater similarity); calculated from ratio of sum of rating difference on common movies
  # to max difference, normalized
  def similarity(user1, user2, movie_hash)
    common_movies = movie_hash.values.select { |movie| movie.user_rated?(user1.to_i) && movie.user_rated?(user2.to_i) }
    return 0.0 if common_movies.empty? # Common case
    rating_sum = common_movies.inject(0) { |sum, movie| sum + (movie.user_rating(user1.to_i) - movie.user_rating(user2.to_i)).abs }
    max_rating_sum = 4 * common_movies.length
    100.0 - (rating_sum.to_f / max_rating_sum.to_f * 100.0)
  end

  # returns an array list of the top number_of_users (default = 5) from movie_hash whose tastes are most similar to the tastes of user u
  # with the most_similar users at the front of the array
  def most_similar(u, number_of_users = 5, movie_hash)
    similarity_hash = other_users(u.to_i, movie_hash).inject({}) { |user_similarity, user_id| user_similarity.merge({user_id => similarity(u.to_i, user_id, movie_hash)}) }
    similarity_hash.sort_by { |user_similarity| user_similarity[1] }.reverse.take(number_of_users).map(&:first)
  end

  # returns the rating that user_id gave movie_id in the training set, and 0 if user_id did not rate movie_id
  def rating(user_id, movie_id)
    @training_movies[movie_id.to_i].user_rating(user_id) || 0
  end

  # returns a floating point number between 1.0 and 5.0 as an estimate of what user_id would rate movie_id
  def predict(user_id, movie_id, movie_hash)
    sum_similar_ratings = most_similar(user_id, 50, movie_hash).inject(0) { |sum, user| sum + user_rating(user) }
    count_similar_ratings = most_similar(user_id, 50).inject(0, movie_hash) { |count, user| count + 1 if user_rated?(user) }
    (sum_similar_ratings / count_similar_ratings).to_f.round(1)
  end

  # returns the array of movies that user_id has watched
  def movies(user_id, movie_hash)

  end

  # returns the array of users that have seen movie_id
  def viewers(movie_id)

  end

  # runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results.
  # The parameter k is optional and if omitted, all of the tests will be run.
  def run_test

  end

  private #######################################################################

  # reads in data from path and stores movie objects in the movie_hash
  def load_data(path, movie_hash)
    File.open(path, "r") do |file|
      file.each do |line|
        line_array = line.split("\t").map(&:to_i)
        user_id, movie_id, rating, timestamp = line_array
        movie_hash[movie_id] ||= Movie.new(movie_id)
        movie_hash[movie_id].add_rating(user_id, rating, timestamp)
      end
    end
  end

  # list of all users except u in movie_hash
  def other_users(u, movie_hash)
    movie_hash.values.map(&:user_list).flatten.uniq - [u]
  end
end
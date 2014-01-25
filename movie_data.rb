# movie_data.rb
# Written by: Noranda Brown
# Version: 2014.1.25

require 'pathname'
require './movie'
require './user_rating'
require './movie_test'

class MovieData

  # initializes MovieData object by loading data from specified folder_name/u.data or optionally from folder_name/set_pair.base
  # and folder_name/set_pair.test, creating a @training_movies hash and an optional @test_movies hash of Movie objects
  def initialize(folder_name, set_pair = nil)
    @training_movies = {}
    @test_set_path = nil
    folder_path = Pathname.new(folder_name)
    raise 'Directory does not exist.' unless folder_path.directory?
    if set_pair.nil?
      training_path = folder_path.join('u.data')
    else
      training_path = folder_path.join("#{set_pair}.base")
      @test_set_path = folder_path.join("#{set_pair}.test")
    end
    load_training_data(training_path)
  end

  # returns a number (0.0 - 100.0) that indicates the popularity (higher numbers are more popular) of movie_id from training_movies
  def popularity(movie_id)
    if @training_movies.key?(movie_id.to_i)
      max_sum_ratings = @training_movies.values.map { |movie| movie.sum_ratings }.max # determines max sum_ratings
      @training_movies[movie_id.to_i].sum_ratings * 100.0 / max_sum_ratings # calculates popularity and normalizes
    else
      raise 'Movie does not exist.'
    end
  end

  # generates a list of all movie_id’s from training_movies ordered by decreasing popularity
  def popularity_list
    @training_movies.values.sort_by { |movie| popularity(movie.movie_id) }.reverse.map(&:movie_id)
  end

  # generate a number (0.0 - 100.0) which indicates the similarity in movie preference between user1 and user2 from training_movies
  # (higher numbers indicate greater similarity); calculated from ratio of sum of rating difference on common movies
  # to max difference, normalized; returns 0.0 if users have no movies in common
  def similarity(user1_id, user2_id)
    if all_users.include?(user1_id.to_i) && all_users.include?(user2_id.to_i)
      user_common_movies = common_movies(user1_id.to_i, user2_id.to_i)
      return 0.0 if user_common_movies.empty? # most common case
      rating_sum = user_common_movies.inject(0) { |sum, movie| sum + (movie.user_rating(user1_id.to_i) - movie.user_rating(user2_id.to_i)).abs }
      max_rating_sum = 4 * user_common_movies.length
      100.0 - (rating_sum.to_f / max_rating_sum.to_f * 100)
    else
      raise 'At least one user specified does not exist.'
    end
  end

  # returns an array list of the top number_of_users (default = 5) from training_movies whose tastes are most similar to the
  # tastes of user_id with the most_similar users at the front of the array; excludes users with similarity = 0.0
  def most_similar(user_id, number_of_users = 5)
    if all_users.include?(user_id)
      similarity_hash = other_users(user_id.to_i).inject({}) { |user_similarity, user| user_similarity.merge({user => similarity(user_id.to_i, user)}) }
      similarity_hash.reject! { |user, similarity| similarity == 0.0 }
      similarity_hash.sort_by { |user_similarity| user_similarity[1] }.reverse.take(number_of_users).map(&:first)
    else
      []
    end
  end

  # returns the rating that user_id gave movie_id in the training set, and 0 if user_id did not rate movie_id
  def rating(user_id, movie_id)
    if all_users.include?(user_id.to_i) && @training_movies.key?(movie_id.to_i)
      @training_movies[movie_id.to_i].user_rating(user_id.to_i) || 0
    else
      raise 'User or movie does not exist.'
    end
  end

  # returns a floating point number between 1.0 and 5.0 as an estimate of what user_id would rate movie_id
  # calculated by averaging the ratings of the user_id's most-similar users (up to 50)
  def predict(user_id, movie_id)
    if all_users.include?(user_id.to_i) && @training_movies.key?(movie_id.to_i)
      sum_similar_ratings = most_similar(user_id.to_i, 50).inject(0) { |sum, user| sum + @training_movies[movie_id].user_rating(user) }
      count_similar_ratings = most_similar(user_id.to_i, 50).map { |user| @training_movies[movie_id].user_rated?(user) }.select { |rated| rated }.size
      return 1.0 if count_similar_ratings == 0 # no similar users have watched the movie
      (sum_similar_ratings / count_similar_ratings).to_f.round(1)
    else
      raise 'User or movie does not exist.'
    end
  end

  # returns an array of movie_ids that user_id has watched
  def movies(user_id)
    if all_users.include?(user_id.to_i)
      @training_movies.values.select { |movie| movie.user_rated?(user_id.to_i) }.map(&:movie_id)
    else
      raise 'User does not exist.'
    end
  end

  # returns a sorted array of users_ids that have seen movie_id
  def viewers(movie_id)
    if @training_movies.key?(movie_id.to_i)
      @training_movies[movie_id].user_list
    else
      []
    end
  end

  # runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results;
  # the parameter k is optional and if omitted, all of the tests will be run.
  def run_test(k = nil)
    raise 'Test set path not found.' if @test_set_path.nil?
    movie_test = MovieTest.new
    load_data(@test_set_path, k) do |user_id, movie_id, rating, timestamp|
      movie_test << [user_id, movie_id, rating, predict(user_id, movie_id)]
    end
    movie_test
  end

  private #######################################################################

  # reads in data from path and stores movie objects in the movie_hash
  def load_data(path, num_lines = nil)
    count = 0
    File.open(path, 'r') do |file|
      file.each do |line|
        line_array = line.split("\t").map(&:to_i)
        user_id, movie_id, rating, timestamp = line_array
        yield user_id, movie_id, rating, timestamp
        count += 1
        break if count == num_lines
      end
    end
  end

  def load_training_data(training_path)
    load_data(training_path) do |user_id, movie_id, rating, timestamp|
      @training_movies[movie_id] ||= Movie.new(movie_id)
      @training_movies[movie_id].add_rating(user_id, rating, timestamp)
    end
  end

  # list of all users in training_movies
  def all_users
    @training_movies.values.map(&:user_list).flatten.uniq
  end

  # list of all users except u in training_movies
  def other_users(u)
    all_users - [u]
  end

  # returns an array of common movies for user1 and user2
  def common_movies(user1_id, user2_id)
    @training_movies.values.select { |movie| movie.user_rated?(user1_id.to_i) && movie.user_rated?(user2_id.to_i) }
  end
end
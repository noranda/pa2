# movie_data.rb
# Written by: Noranda Brown
# Version: 2014.1.26

require 'rubygems'
require 'bundler'
Bundler.require

require 'pathname'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'movie_database'
require 'movie'
require 'user_rating'
require 'movie_test'
require 'movie_similarity'

class MovieData
  ##
  # initializes MovieData object by loading data from the specified +folder_name+/u.data file,
  # or optionally from +folder_name+/+set_pair+.base
  def initialize(folder_name, set_pair = nil)
    @movie_database = MovieDatabase.new
    @movie_similarity = MovieSimilarity.new(@movie_database)
    @test_set_path = nil
    folder_path = Pathname.new(folder_name)
    raise 'Directory does not exist.' unless folder_path.directory?
    training_path = folder_path.join('u.data')
    unless set_pair.nil?
      training_path = folder_path.join("#{set_pair}.base")
      @test_set_path = folder_path.join("#{set_pair}.test")
    end
    load_data(training_path) do |user_id, movie_id, rating, timestamp|
      @movie_database.add_movie_rating(movie_id, user_id, rating, timestamp)
    end
  end

  ##
  # returns a number +0.0+ - +100.0+ that indicates the popularity (higher numbers are more popular) of +movie_id+
  def popularity(movie_id)
    @movie_database.popularity(movie_id)
  end

  ##
  # generates a list of all movie ids ordered by decreasing popularity
  def popularity_list
    @movie_database.popularity_list
  end

  ##
  # generates a number +0.0+ - +100.0+ which indicates the similarity in movie
  # preference between +user1_id+ and +user2_id+ (higher numbers indicate greater similarity)
  def similarity(user1_id, user2_id)
    @movie_similarity.similarity(user1_id, user2_id)
  end

  ##
  # returns an array list of the top number of users whose tastes are most similar to the
  # tastes of +user_id+ with the most similar users at the front of the array; excludes users with similarity = 0.0
  def most_similar(user_id)
    @movie_similarity.most_similar(user_id)
  end

  ##
  # returns the rating that +user_id+ gave +movie_id+, or +0+ if +user_id+ did not rate +movie_id+
  def rating(user_id, movie_id)
    raise 'User or movie does not exist.' unless @movie_database.users_include?(user_id) && @movie_database.movies_include?(movie_id)
    @movie_database[movie_id].user_rating(user_id) || 0
  end

  ##
  # returns a floating point number between +1.0+ and +5.0+ as an estimate of what +user_id+ would rate +movie_id+
  def predict(user_id, movie_id)
    @movie_similarity.predict(user_id, movie_id)
  end

  ##
  # returns an array of movie ids that +user_id+ has watched
  def movies(user_id)
    raise 'User does not exist.' unless @movie_database.users_include?(user_id)
    @movie_database.movies_user_rated(user_id).map(&:movie_id)
  end

  ##
  # returns a sorted array of users ids that have seen +movie_id+
  def viewers(movie_id)
    return [] unless @movie_database.movies_include?(movie_id)
    @movie_database[movie_id].user_list
  end

  ##
  # runs the predict method on the first k ratings in the test set and returns a MovieTest object containing the results;
  # the parameter k is optional and if omitted, all of the tests will be run
  def run_test(k = nil)
    raise 'Test set path not found.' if @test_set_path.nil?
    movie_test = MovieTest.new
    load_data(@test_set_path, k) do |user_id, movie_id, rating, timestamp|
      movie_test << [user_id, movie_id, rating, predict(user_id, movie_id)]
    end
    movie_test
  end

  private #######################################################################

  ##
  # reads in data from path and stores movie objects in hash
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
end
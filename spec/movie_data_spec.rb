# movie_data_spec.rb
# Written by: Noranda Brown
# Version: 2014.1.26

require 'spec_helper'
require './movie_data'

describe MovieData do

  before do
    allow_any_instance_of(Pathname).to receive(:directory?).and_return(true)
  end

  context '#initialize' do
    it 'can be constructed' do
      allow(File).to receive(:open)
      expect { MovieData.new('test') }.to_not raise_error
    end

    it 'reads u.data when no set pair is passed in' do
      expect(File).to receive(:open).with(Pathname.new('test/u.data'), 'r')
      MovieData.new('test')
    end

    it 'reads the base file when a set pair is passed in' do
      expect(File).to receive(:open).with(Pathname.new('test/foo.base'), 'r')
      MovieData.new('test', :foo)
    end

    it 'raises an error if the directory does not exist' do
      expect { MovieData.new('test') }.to raise_error
    end
  end

  context '#popularity' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 5, 100], [3, 1, 5, 100], [4, 2, 3, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'calculates popularity for the highest rated movie' do
      expect(@md.popularity(1)).to eq(100)
    end

    it 'calculates popularity for the lowest rated movie' do
      expect(@md.popularity(2)).to eq(20)
    end

    it 'raises an error if the movie does not exist' do
      expect { md.popularity(3) }.to raise_error
    end
  end

  context '#popularity_list' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 5, 100], [3, 1, 5, 100], [4, 2, 3, 100], [5, 3, 1, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'creates a popularity list in descending order' do
      expect(@md.popularity_list).to eq([1, 2, 3])
    end
  end

  context '#similarity' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 5, 100],
                       [1, 2, 4, 100], [2, 2, 4, 100],
                       [3, 1, 5, 100], [4, 1, 1, 100],
                       [3, 2, 1, 100], [4, 2, 5, 100],
                       [5, 1, 1, 100], [6, 1, 3, 100],
                       [5, 2, 5, 100], [6, 2, 3, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'calculates the similarity between two common users' do
      expect(@md.similarity(1, 2)).to eq(100.0)
    end

    it 'calculates the similarity between two less common users' do
      expect(@md.similarity(2, 3)).to eq(62.5)
    end

    it 'calculates the similarity between two users that are semi-common' do
      expect(@md.similarity(5, 6)).to eq(50.0)
    end

    it 'calculates the similarity between two users that have no common movies' do
      expect(@md.similarity(3, 4)).to eq(0.0)
    end

    it 'raises an error if at least one specified user does not exist' do
      expect { @md.similarity(1, 7) }.to raise_error
    end
  end

  context '#most_similar' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 4, 100], [3, 1, 3, 100], [4, 1, 2, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'returns an array of the most similar users to a user' do
      expect(@md.most_similar(1)).to eq([2, 3, 4])
    end

    it 'returns an empty array if user does not exist' do
      expect(@md.most_similar(5)).to eq([])
    end
  end

  context '#rating' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 2, 2, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'returns the rating for a movie a user rated' do
      expect(@md.rating(1, 1)).to eq(5)
    end

    it 'returns 0 for a movie a user did not rate' do
      expect(@md.rating(2, 1)).to eq(0)
    end

    it 'raises an error if the user does not exist' do
      expect { @md.rating(3, 1) }.to raise_error
    end

    it 'raises an error if the movie does not exist' do
      expect { @md.rating(1, 3) }.to raise_error
    end
  end

  context '#predict' do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 4, 100], [3, 1, 3, 100], [4, 1, 2, 100],
                                       [2, 2, 3, 100], [3, 2, 5, 100], [4, 2, 4, 100],
                                       [5, 3, 3, 100], [6, 3, 5, 100], [7, 3, 4, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'predicts the rating a user would give a movie he/she has not seen' do
      expect(@md.predict(1, 2)).to eq(3.8)
    end

    it 'returns 3.0 if the user has no similar users that have seen the movie' do
      expect(@md.predict(1, 3)).to eq(3.0)
    end
  end

  context '#movies' do
    before do
      @user_ratings = [[1, 1, 5, 100], [1, 2, 2, 100], [2, 3, 2, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'returns an array of movies watched by a user who exists' do
      expect(@md.movies(1)).to eq([1, 2])
    end

    it 'raises an error if a user does not exist' do
      expect { @md.movies(3) }.to raise_error
    end
  end

  context '#viewers' do
    before do
      @user_ratings = [[3, 1, 5, 100], [1, 1, 2, 100], [2, 1, 2, 100], [4, 1, 4, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test')
    end

    it 'returns a sorted list of users that reviewed the movie' do
      expect(@md.viewers(1)).to eq([1, 2, 3, 4])
    end

    it 'returns an empty array if no users have reviewed the movie' do
      expect(@md.viewers(2)).to eq([])
    end
  end

  context '#run_test' do
    before do
      @training_ratings = [[3, 1, 5, 100], [1, 1, 2, 100], [2, 1, 2, 100], [4, 1, 4, 100],
                           [1, 2, 3, 100], [4, 2, 5, 100], [5, 2, 1, 100], [2, 2, 5, 100]]
      @test_ratings = [[3, 2, 4, 100], [5, 1, 3, 100]]
      allow(File).to receive(:open).with(Pathname.new('test/foo.base'), 'r').and_yield(StringIO.new(@training_ratings.map { |array| array.join("\t") }.join("\n")))
      allow(File).to receive(:open).with(Pathname.new('test/foo.test'), 'r').and_yield(StringIO.new(@test_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new('test', :foo)
    end

    it 'returns a MovieTest object' do
      expect(@md.run_test).to be_a(MovieTest)
    end

    it 'returns a MovieTest object containing the results of predict on the test set' do
      expect(@md.run_test.to_a).to eq([[3, 2, 4, 4.6], [5, 1, 3, 2.0]])
    end

    it 'returns a MovieTest object correctly with a given k' do
      expect(@md.run_test(1).to_a).to eq([[3, 2, 4, 4.6]])
    end

    it 'raises an error if @test_set_path is nil' do
      allow(File).to receive(:open).and_yield(StringIO.new(""))
      md2 = MovieData.new('test')
      expect { md2.run_test }.to raise_error
    end
  end
end
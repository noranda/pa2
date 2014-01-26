# movie_test_spec.rb
# Written by: Noranda Brown
# Version: 2014.1.26

require 'spec_helper'
require './movie_data'

describe MovieTest do

  context '#initialize' do
    it 'can be constructed' do
      expect { MovieTest.new }.to_not raise_error
    end
  end

  context '#mean' do
    before do
      @test_results = [[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]]
      @mt = MovieTest.new
      @test_results.each { |result| @mt << result }
    end

    it 'returns the mean of a prediction error' do
      expect(@mt.mean).to eq(1.0)
    end

    it 'returns 0 if test results array size is < 2' do
      expect(MovieTest.new.mean).to eq(0.0)
    end
  end

  context '#stddev' do
    before do
      @test_results = [[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]]
      @mt = MovieTest.new
      @test_results.each { |result| @mt << result }
    end

    it 'returns the sample standard deviation of the errors' do
      expect(@mt.stddev).to eq(0.8)
    end

    it 'returns 0 if error array size is < 2' do
      expect(MovieTest.new.stddev).to eq(0.0)
    end
  end

  context '#rms' do
    before do
      @test_results = [[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]]
      @mt = MovieTest.new
      @test_results.each { |result| @mt << result }
    end

    it 'returns the root mean square of the errors' do
      expect(@mt.rms).to eq(1.2)
    end

    it 'returns 0 if error array size is < 2' do
      expect(MovieTest.new.rms).to eq(0.0)
    end
  end

  context '#to_a' do
    before do
      @test_results = [[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]]
      @mt = MovieTest.new
      @test_results.each { |result| @mt << result }
    end

    it 'returns an array of the predictions in the form [u,m,r,p]' do
      expect(@mt.to_a).to eq([[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]])
    end
  end

  context '#add_result' do
    before do
      @test_results = [[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2]]
      @mt = MovieTest.new
      @test_results.each { |result| @mt << result }
    end

    it 'adds the given tuple to the test results' do
      @mt.add_result([4, 4, 1, 3])
      expect(@mt.to_a).to eq([[1, 1, 5, 4], [2, 2, 4, 3], [3, 3, 2, 2], [4, 4, 1, 3]])
    end
  end
end
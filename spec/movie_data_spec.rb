# movie_data_spec   .rb
# Written by: Noranda Brown
# Version: 2014.1.24

require 'rspec'
require './movie_data'

describe MovieData do

  context "initialization" do
    it "can be constructed" do
      allow(File).to receive(:open)
      expect { MovieData.new("test") }.to_not raise_error
    end

    it "reads u.data when no set pair is passed in" do
      expect(File).to receive(:open).with(Pathname.new("test/u.data"), "r")
      MovieData.new("test")
    end

    it "reads both the base and test files when a set pair is passed in" do
      expect(File).to receive(:open).with(Pathname.new("test/foo.base"), "r")
      expect(File).to receive(:open).with(Pathname.new("test/foo.test"), "r")
      MovieData.new("test", :foo)
    end
  end

  context "#popularity" do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 5, 100], [3, 1, 5, 100], [4, 2, 3, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new("test")
    end

    it "calculates popularity for the highest rated movie" do
      expect(@md.popularity(1)).to eq(100)
    end

    it "calculates popularity for the lowest rated movie" do
      expect(@md.popularity(2)).to eq(20)
    end
  end

  context "#popularity_list" do
    before do
      @user_ratings = [[1, 1, 5, 100], [2, 1, 5, 100], [3, 1, 5, 100], [4, 2, 3, 100], [5, 3, 1, 100]]
      allow(File).to receive(:open).and_yield(StringIO.new(@user_ratings.map { |array| array.join("\t") }.join("\n")))
      @md = MovieData.new("test")
    end

    it "creates a popularity list in descending order" do
      expect(@md.popularity_list).to eq([1, 2, 3])
    end
  end

  context "#"
end
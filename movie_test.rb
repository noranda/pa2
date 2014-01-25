# movie_test.rb
# Written by: Noranda Brown
# Version: 2014.1.25

class MovieTest

  def initialize
    @test_results = []
  end

  # returns the average predication error (which should be close to zero)
  def mean

  end

  # returns the standard deviation of the error
  def stddev

  end

  # returns the root mean square error of the prediction
  def rms

  end

  # returns an array of the predictions in the form [u,m,r,p]
  def to_a
    @test_results
  end

  def add_result(result_tuple)
    @test_results << result_tuple
  end

  alias_method :<<, :add_result

end
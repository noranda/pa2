# movie_test.rb
# Written by: Noranda Brown
# Version: 2014.1.25

class MovieTest

  def initialize
    @test_results = []
  end

  # returns the average predication error of the test results or 0.0 if < 2 tuples in test results
  def mean
    return 0.0 if @test_results.size < 2
    @test_results.inject(0) { |sum_errors, tuple| sum_errors + (tuple[2] - tuple[3]).abs }.to_f / @test_results.size.to_f
  end

  # returns the standard deviation of the error or 0.0 if errors array size < 2
  def stddev
    return 0.0 if errors.size < 2
    errors.stdev.to_f.round(1)
  end

  # returns the root mean square error of the prediction or 0.0 if errors array size < 2
  def rms
    return 0.0 if errors.size < 2
    Math.sqrt(errors.inject(0) { |sum, error| sum + error * error }.to_f / errors.size.to_f ).round(1)
  end

  # returns an array of the predictions in the form [u,m,r,p]
  def to_a
    @test_results
  end

  # adds the given result tuple to the test results
  def add_result(result_tuple)
    @test_results << result_tuple
  end

  alias_method :<<, :add_result

  private #######################################################################

  def errors
    @test_results.map { |tuple| (tuple[2] - tuple[3]).abs }
  end
end
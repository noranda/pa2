var search_data = {"index":{"searchIndex":["movie","moviedata","moviedatabase","moviesimilarity","movietest","userrating","<<()","[]()","add_movie_rating()","add_rating()","add_result()","max_sum_ratings()","mean()","most_similar()","most_similar()","movies()","movies_in_common()","movies_include?()","movies_user_rated()","new()","new()","new()","new()","new()","new()","popularity()","popularity()","popularity_list()","popularity_list()","predict()","predict()","rating()","rms()","run_test()","similarity()","similarity()","stddev()","sum_ratings()","to_a()","user_list()","user_rated?()","user_rating()","users()","users_include?()","viewers()","gemfile","gemfile.lock","readme","transcript"],"longSearchIndex":["movie","moviedata","moviedatabase","moviesimilarity","movietest","userrating","movietest#<<()","moviedatabase#[]()","moviedatabase#add_movie_rating()","movie#add_rating()","movietest#add_result()","moviedatabase#max_sum_ratings()","movietest#mean()","moviedata#most_similar()","moviesimilarity#most_similar()","moviedata#movies()","moviedatabase#movies_in_common()","moviedatabase#movies_include?()","moviedatabase#movies_user_rated()","movie::new()","moviedata::new()","moviedatabase::new()","moviesimilarity::new()","movietest::new()","userrating::new()","moviedata#popularity()","moviedatabase#popularity()","moviedata#popularity_list()","moviedatabase#popularity_list()","moviedata#predict()","moviesimilarity#predict()","moviedata#rating()","movietest#rms()","moviedata#run_test()","moviedata#similarity()","moviesimilarity#similarity()","movietest#stddev()","movie#sum_ratings()","movietest#to_a()","movie#user_list()","movie#user_rated?()","movie#user_rating()","moviedatabase#users()","moviedatabase#users_include?()","moviedata#viewers()","","","",""],"info":[["Movie","","Movie.html","","<p>movie.rb Written by: Noranda Brown Version: 2014.1.26\n"],["MovieData","","MovieData.html","",""],["MovieDatabase","","MovieDatabase.html","","<p>movie_database.rb Written by: Noranda Brown Version: 2014.1.26\n"],["MovieSimilarity","","MovieSimilarity.html","","<p>movie_similarity.rb Written by: Noranda Brown Version: 2014.1.26\n"],["MovieTest","","MovieTest.html","","<p>movie_test.rb Written by: Noranda Brown Version: 2014.1.26\n"],["UserRating","","UserRating.html","","<p>user_rating.rb Written by: Noranda Brown Version: 2014.1.26\n"],["<<","MovieTest","MovieTest.html#method-i-3C-3C","(result_tuple)",""],["[]","MovieDatabase","MovieDatabase.html#method-i-5B-5D","(movie_id)","<p>returns the movie instance that belongs to the <code>movie_id</code>\n"],["add_movie_rating","MovieDatabase","MovieDatabase.html#method-i-add_movie_rating","(movie_id, user_id, rating, timestamp)","<p>adds movie rating to movie, creating the movie if it does not already exist\n"],["add_rating","Movie","Movie.html#method-i-add_rating","(user_id, rating, timestamp)","<p>adds a user_id, rating and timestamp to a movie\n"],["add_result","MovieTest","MovieTest.html#method-i-add_result","(result_tuple)","<p>adds the given result tuple to the test results\n"],["max_sum_ratings","MovieDatabase","MovieDatabase.html#method-i-max_sum_ratings","()","<p>returns the maximum sum of all ratings across all movies in the movie\ndatabase\n"],["mean","MovieTest","MovieTest.html#method-i-mean","()","<p>returns the average predication error of the test results or 0.0 if &lt; 2\ntuples in test results\n"],["most_similar","MovieData","MovieData.html#method-i-most_similar","(user_id)","<p>returns an array list of the top number of users whose tastes are most\nsimilar to the tastes of <code>user_id</code> …\n"],["most_similar","MovieSimilarity","MovieSimilarity.html#method-i-most_similar","(user_id)","<p>returns an array list of the top number of users whose tastes are most\nsimilar to the tastes of <code>user_id</code> …\n"],["movies","MovieData","MovieData.html#method-i-movies","(user_id)","<p>returns an array of movie ids that <code>user_id</code> has watched\n"],["movies_in_common","MovieDatabase","MovieDatabase.html#method-i-movies_in_common","(user1_id, user2_id)","<p>returns and array of movies in common between <code>user1_id</code> and\n<code>user2_id</code>\n"],["movies_include?","MovieDatabase","MovieDatabase.html#method-i-movies_include-3F","(*movie_ids)","<p>returns true if all <code>movie_ids</code> passed in are in the movie\ndatabase\n"],["movies_user_rated","MovieDatabase","MovieDatabase.html#method-i-movies_user_rated","(user_id)","<p>returns an array of movies rated by the <code>user_id</code>\n"],["new","Movie","Movie.html#method-c-new","(movie_id)",""],["new","MovieData","MovieData.html#method-c-new","(folder_name, set_pair = nil)","<p>initializes MovieData object by loading data from the specified\n<code>folder_name</code>/u.data file, or optionally …\n"],["new","MovieDatabase","MovieDatabase.html#method-c-new","()",""],["new","MovieSimilarity","MovieSimilarity.html#method-c-new","(movie_database)",""],["new","MovieTest","MovieTest.html#method-c-new","()",""],["new","UserRating","UserRating.html#method-c-new","(user_id, rating, timestamp)",""],["popularity","MovieData","MovieData.html#method-i-popularity","(movie_id)","<p>returns a number <code>0.0</code> - <code>100.0</code> that indicates the\npopularity (higher numbers are more popular) of <code>movie_id</code> …\n"],["popularity","MovieDatabase","MovieDatabase.html#method-i-popularity","(movie_id)","<p>returns a number <code>0.0</code> - <code>100.0</code> that indicates the\npopularity (higher numbers are more popular) of <code>movie_id</code> …\n"],["popularity_list","MovieData","MovieData.html#method-i-popularity_list","()","<p>generates a list of all movie ids ordered by decreasing popularity\n"],["popularity_list","MovieDatabase","MovieDatabase.html#method-i-popularity_list","()","<p>generates a list of all movie ids ordered by decreasing popularity\n"],["predict","MovieData","MovieData.html#method-i-predict","(user_id, movie_id)","<p>returns a floating point number between <code>1.0</code> and\n<code>5.0</code> as an estimate of what <code>user_id</code> would rate\n<code>movie_id</code> …\n"],["predict","MovieSimilarity","MovieSimilarity.html#method-i-predict","(user_id, movie_id)","<p>returns a floating point number between <code>1.0</code> and\n<code>5.0</code> as an estimate of what <code>user_id</code> would rate\n<code>movie_id</code> …\n"],["rating","MovieData","MovieData.html#method-i-rating","(user_id, movie_id)","<p>returns the rating that <code>user_id</code> gave <code>movie_id</code>, or\n<code>0</code> if <code>user_id</code> did not rate <code>movie_id</code>\n"],["rms","MovieTest","MovieTest.html#method-i-rms","()","<p>returns the root mean square error of the prediction or 0.0 if errors array\nsize &lt; 2\n"],["run_test","MovieData","MovieData.html#method-i-run_test","(k = nil)","<p>runs the predict method on the first k ratings in the test set and returns\na MovieTest object containing …\n"],["similarity","MovieData","MovieData.html#method-i-similarity","(user1_id, user2_id)","<p>generates a number <code>0.0</code> - <code>100.0</code> which indicates\nthe similarity in movie preference between <code>user1_id</code> and …\n"],["similarity","MovieSimilarity","MovieSimilarity.html#method-i-similarity","(user1_id, user2_id)","<p>generates a number <code>0.0</code> - <code>100.0</code> which indicates\nthe similarity in movie preference between <code>user1_id</code> and …\n"],["stddev","MovieTest","MovieTest.html#method-i-stddev","()","<p>returns the standard deviation of the error or 0.0 if errors array size\n&lt; 2\n"],["sum_ratings","Movie","Movie.html#method-i-sum_ratings","()","<p>returns the sum of all ratings for a movie\n"],["to_a","MovieTest","MovieTest.html#method-i-to_a","()","<p>returns an array of the predictions in the form [u,m,r,p]\n"],["user_list","Movie","Movie.html#method-i-user_list","()","<p>returns a sorted list of users that reviewed the movie\n"],["user_rated?","Movie","Movie.html#method-i-user_rated-3F","(*user_ids)","<p>returns true if user_id has rated a movie and false otherwise\n"],["user_rating","Movie","Movie.html#method-i-user_rating","(user_id)","<p>returns the user rating from user_id for a movie if the movie was rated by\nthe user, else returns 0\n"],["users","MovieDatabase","MovieDatabase.html#method-i-users","(except_for = nil)","<p>list of all users that have rated at least one movie; accepts an optional\nparameter <code>except_for</code> which …\n"],["users_include?","MovieDatabase","MovieDatabase.html#method-i-users_include-3F","(*user_ids)","<p>returns true if all <code>user_ids</code> passed in are in the movie\ndatabase\n"],["viewers","MovieData","MovieData.html#method-i-viewers","(movie_id)","<p>returns a sorted array of users ids that have seen <code>movie_id</code>\n"],["Gemfile","","Gemfile.html","","<p>source “rubygems.org”\n<p>gem “rspec” gem “ruby-standard-deviation”, “~&gt; …\n"],["Gemfile.lock","","Gemfile_lock.html","","<p>GEM\n\n<pre>remote: https://rubygems.org/\nspecs:\n  diff-lcs (1.2.5)\n  rspec (2.14.1)\n    rspec-core (~&gt; 2.14.0) ...</pre>\n"],["README","","README_md.html","","<p>Assignment: PA 2\n<p><img src=\"https://secure.travis-ci.org/noranda/pa2.png\">\n<img\nsrc=\"https://codeclimate.com/github/noranda/pa2.png\"> ...\n"],["transcript","","transcript_md.html","","<p>Transcript\n\n<pre class=\"ruby\">[<span class=\"ruby-identifier\">nbrown</span> <span class=\"ruby-operator\">~</span><span class=\"ruby-regexp\">/vagrant/</span><span class=\"ruby-identifier\">pa2</span>] [<span class=\"ruby-identifier\">master</span> <span class=\"ruby-identifier\">●</span>] <span class=\"ruby-identifier\">❯</span> <span class=\"ruby-identifier\">irb</span>\n<span class=\"ruby-value\">2.1</span><span class=\"ruby-value\">.0</span> <span class=\"ruby-operator\">:</span><span class=\"ruby-value\">001</span> <span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;./movie_data&#39;</span>\n =<span class=\"ruby-operator\">&gt;</span> <span class=\"ruby-keyword\">true</span>\n<span class=\"ruby-value\">2.1</span><span class=\"ruby-value\">.0</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"]]}}
class Movie < ActiveRecord::Base


  def self.allratings
 # find all sorted unique movie rating column records and map to an array
  	
  (find(:all, :select => "rating").map{|x| x.rating}).sort.uniq

  end

end

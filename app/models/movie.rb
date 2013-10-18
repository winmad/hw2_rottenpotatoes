class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.ratings_checker(ratings)
    checker = Hash.new
    self.all_ratings.each do |rating|
      checker[rating] = ratings.include?(rating)
    end
    return checker
  end
end

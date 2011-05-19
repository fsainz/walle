include Math
class HomeController < ApplicationController
  def index
    period_matrix = period_vectors(3.week, 10.day)

    card = Card.new(:strength=>0.5)
    card2 = Card.new(:strength=>1.0)
    
    retention_matrix = period_matrix.map do |period|
      tune_strength(card)
      retention_vector(card, period, period.first)
    end
    retention_matrix2 = period_matrix.map do |period|
      tune_strength(card2)
      retention_vector(card2, period, period.first)
    end
    
    @lines =[
      period_matrix<<[0],
      retention_matrix<<[0]
    ]
    
    @lines2 =[
      period_matrix<<[0],
      retention_matrix2<<[0]
    ]
    
    @values= multiple
  end
  
  
  private
 
  def period_vectors(total_length, period_length)
    days = total_length / 1.day
    period_length = period_length / 1.day
    last = 1
    whole_period = []
    
    while(last < days)
      if last+period_length > days
        whole_period << (last-1..days-1).to_a
      else
        whole_period << (last-1..(last+period_length-1)).to_a
      end
      last = last + period_length
    end
    whole_period
  end
  #    whole_period=(0..days-1).to_a.map(&:to_f)
  #    whole_period.chunk(period_length)
  
  def retention_vector(card, period_vector, offset = 0)
    period_vector.map do |t|
      retention(t-offset,card.strength)
    end
  end
  
  def retention(t,s)
    exp(-t/s)*100
  end
  
  def tune_strength(card)
    card.strength = card.strength * 2.0
  end
  
  def multiple
    values={}
    t=2
    1.upto(5) do |n|
      card= Card.new(:strength => n)
      var_r = 100-retention(t,card.strength)
      var_s = -(card.strength - tune_strength(card)) 
      values[n]={:strength_increase=>var_s, :retention_increase=>var_r}
    end   
    values
    
  end
  
end
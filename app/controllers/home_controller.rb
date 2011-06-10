include Math

class HomeController < ApplicationController
  
  def automata
    @simulator = Simulator.new(:walle_one_random)
    @simulator.simulate(10)
    @histogram = [] 
    @ret_histogram = []
    @simulator.history.to_histogram.each do |e|
      @histogram << e << [0,0,0,0,0,0,0]
    end
    @simulator.history.plot_retentions_before_review.each do |e|
      @ret_histogram << e << [0,0,0,0,0,0,0]
    end
    @histogram.flatten!
    @ret_histogram.flatten!
    
    @simulator2 = Simulator.new(:walle_two)
    @simulator2.simulate(10)
    @histogram2 = [] 
    @ret_histogram2 = []
    @simulator2.history.to_histogram.each do |e|
      @histogram2 << e << [0,0,0,0,0,0,0]
    end
    @simulator2.history.plot_retentions_before_review.each do |e|
      @ret_histogram2 << e << [0,0,0,0,0,0,0]
    end
    @histogram2.flatten!
    @ret_histogram2.flatten!
    
    @x1, @y1 = @simulator.history.plot_average_retention_in(365)
    @x2, @y2 = @simulator2.history.plot_average_retention_in(365)
    
    @x3, @y3 = @simulator.history.plot_number_of_healthy_cards_in(120)
    @x4, @y4 = @simulator2.history.plot_number_of_healthy_cards_in(120)
    
    @x5 = @simulator.history.plot_retention_status
    @x6 = @simulator2.history.plot_retention_status
  end
  
  
  def index
    period_matrix = period_vectors(3.week, 8.day)

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
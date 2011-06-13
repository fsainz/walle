include Math
require 'delegate'
class History < SimpleDelegator
  def initialize
    @data = Hash.new
    @history_by_date = nil
    @last_update = nil
    @healthy_cards_record = []
    @retention_status = []
#    @retentions_before_review = [(1..2).to_a.map{|card_id| [card_id, 100]}]
    super(@data)
  end
  
  def initialize_card(card, strength = nil, date = nil)
    return if @data[card.id]
    @history_by_date = nil
    @last_update ||= date
    s = strength || rand(2)+7
    @data[card.id] = [Event.new(date||Time.now, -1.0, s)]
  end
  
  def update_card(card_id, date, quality, strength)
    @history_by_date = nil
    @last_update = date
    @data[card_id] << Event.new(date, quality, strength.to_f)
  end
  
  def card_strength(card_id)
    @data[card_id].last.strength
  end
  
  def cards_strengths
    strengths = []
    @data.keys.each do |card|
      strengths << card_strength(card)
    end
    strengths
  end
  
  def average_card_strength
    cards_strengths.average
  end
  
  def card_last_update(card_id)
    date = @data[card_id].first.date
    @data[card_id].reject{|e|e.quality == -1.0}.last.try(:date) || date
  end
  
  def optimal_date_of_review(card_id)
    last_review = card_last_update(card_id)
    strength = card_strength(card_id)
    last_review + (strength * log(2)).day
  end
  
  def update_healthy_cards_record
    @healthy_cards_record << number_of_healthy_cards_in(0.days)
  end
  
  def update_retention_status(days=0.days)
    low_cards    = number_of_cards_in_range(days, 0..50)
    medium_cards = number_of_cards_in_range(days, 50..70)
    high_cards   = number_of_cards_in_range(days, 70..100)
    
    @retention_status << [low_cards, medium_cards, high_cards]
  end
  
  def update_retentions_before_review(date_of_review)
    @retentions_before_review ||= [(1..@data.keys.length-1).to_a.map{|card_id| [card_id, 100]}]
    r = @data.keys.inject([]) do |rets, card_id|
      time_lapse = (date_of_review - card_last_update(card_id)) / (60*60*24)
      strength = card_strength(card_id)
      rets << [card_id, retention(time_lapse, strength)]
      rets
    end
    @retentions_before_review << r

    #  retention((date_of_review - card_last_update(card_id)) / (60*60*24), card_strength(card_id))
  end
  
  def plot_retentions_before_review
    @retentions_before_review.map do |week|
      week.sort.map{|e|e[1]}
    end
  end
  
  
  def plot_retention_status
    @retention_status.transpose
  end
  
  def plot_average_retention_in(days)
    x_axis = (0..days).to_a
    y_axis = []
    days.times do |i|
      y_axis << average_retention(i.day)
    end
    return x_axis, y_axis
  end
  
  def plot_number_of_healthy_cards_in(days)
    healthy_cards_record_after_study_period = []
    days.times do |i|
      healthy_cards_record_after_study_period[i] = number_of_healthy_cards_in(i.day)
    end
    y_axis = @healthy_cards_record + healthy_cards_record_after_study_period
    #apaño para que los weeks no aparezcan como días
    x_axis = (0..@healthy_cards_record.length).to_a.map{|i| i*7}
    x_axis += (x_axis.last .. y_axis.length - @healthy_cards_record.length).to_a
    
    #    x_axis = (0..y_axis.length).to_a
    return x_axis, y_axis
  end
  
  def number_of_healthy_cards_in(days)
    number_of_cards_in_range(days, 50..100)
  end
  
  def number_of_cards_in_range(days, range)
    @data.keys.inject(0) do |n, card_id|
      (card_retention_in_range?(card_id, days, range)) ? n + 1 : n
    end
  end
  
  def dates_of_review
    self.by_date.keys.join(" "*30)
  end
  
  def card_retention_in_range?(card_id, days, range)
    ret = card_retention_in(card_id, days)
    range.first <= ret && range.last >= ret
  end
  
  def card_time_to_reach_retention(card_id, ret)
    -card_strength(card_id) * log(ret)
  end
  
  def card_optimal_date_of_review(card_id)
    card_last_update(card_id) + card_time_to_reach_retention(card_id, 0.5).days
  end
  
  def reviewed_cards
    @data.reject do |card_id, historic|
      !historic.any?{|event| event.quality > 0}
    end.keys.sort
  end
  
  
  def average_retention(time = 0.day)
    avg = @data.keys.inject(0.0) do |ret,card_id|
      ret + card_retention_in(card_id, time)
    end
    avg/@data.keys.length.to_f
  end
  
  def card_retention_in(card, time=0.day, date_of_review=nil)
    if date_of_review
      time = date_of_review + time
    else  
      time = @last_update + time
    end
    strength = @data[card].last.strength
    date = card_last_update(card)
    lapse_time = (time-date)/(60*60*24).to_f
    
    retention(lapse_time,strength.to_f)
  end
  
    
  def expected_card_retention(settling_period, expected_strength)
    #    time = date_of_review + settling_period
    #    date = card_last_update(card)
    lapse_time = (settling_period)/(60*60*24).to_f
    
    retention(lapse_time,expected_strength.to_f)
  end
  
  def retention(t,s)
    exp(-t/s)*100
  end
  
  def last_week
    week = []
    @data.each do |k,v|
      week << v.last
    end
    def week.strengths
      self.map(&:strength)
    end
    week
  end
  
  
  
  def by_date
    return @history_by_date if @history_by_date
    @history_by_date = Hash.new()
    @data.each do |card_id, historic|
      historic.each do |event|
        unless @history_by_date[event.date_to_s]
          @history_by_date[event.date_to_s] = [[card_id, event.strength]]
        else
          #ESTO ES UN HORROR: cuando en se añade una tarjeta un día cualquiera de repaso
          # se introduce en el historial con q=-1.0 y ese mismo día se va a repasar (o puede
          # que no se repase, pero se metera un evento en su historial de ese día tambien con 
          # q=-1.0.
          # El caso es que a la hora de pensar en presentar esto en forma de histograma hay que
          # eliminar repeticiones y quedarse con la que tenga la S más grande
          cards = @history_by_date[event.date_to_s]
          
          if cards.any?{|e| e[0] == card_id}
            the_same_card = cards.select{|cs| cs[0] == card_id}
            the_same_card.each{|e| cards.delete(e)} #si hubiera varias coincidencias las borramos todas
            the_same_card << [card_id, event.strength]
            selected_card = the_same_card.sort_by{|e| e[1]}.last #nos quedamos con el que tenga mas strength
            @history_by_date[event.date_to_s] = (cards << selected_card)
          else
            @history_by_date[event.date_to_s] << [card_id, event.strength]
          end
        end
      end
    end
    @history_by_date
  end
  
  def to_histogram
    histo = []
    self.by_date.sort.map{|e| e[1]}.each do |historic|
      histo << historic.sort{ |a, b| a[0] <=> b[0] }.map{|e| e[1]}
    end
    histo
  end
  
  def to_retention_histogram
    histo = []
    by_date_sorted=self.by_date.sort
    last_date = Date.strptime(by_date_sorted.first[0],"%Y-%m-%d").to_time
    last_strengths = by_date_sorted.first[1].sort{ |a, b| a[0] <=> b[0] }.map{|e| e[1]}
    self.by_date.sort.each do |date_historic|
      date     = Date.strptime(date_historic[0],"%Y-%m-%d").to_time
      historic = date_historic[1]
      time_lapse_in_days = (date - last_date)/(60*60*24)
      histo << last_strengths.map{|s| retention(time_lapse_in_days, s)}
      last_date = date
      last_strengths = historic.sort{ |a, b| a[0] <=> b[0] }.map{|e| e[1]}
    end
    histo
  end
  
  #  def inspect
  #    str="\n"
  #    @data.sort.each do |e|
  #      str << "\t#{e[0]} => #{e[1].length}\n"
  #      str << "\t    #{e[1].map(&:inspect).join("\n\t    ")} \n"
  #    end
  #    str
  #  end
end

class Event
  attr_accessor :date, :quality, :strength
  def initialize(date, quality, strength)
    @date, @quality, @strength = date, quality, strength
  end
  
  def date_to_s
    @date.strftime("%Y-%m-%d")
  end
  
  #  def inspect
  #    "[" <<@date.strftime("%Y-%m-%d") << "]  q:#{@quality}    s:#{@strength}" #if @quality > 0
  #  end
end
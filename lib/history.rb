include Math
require 'delegate'
class History < SimpleDelegator
  def initialize
    @data = Hash.new
    @history_by_date = nil
    @last_update = nil
    super(@data)
  end
  
  def initialize_card(card)
    return if @data[card.id]
    @history_by_date = nil
    @last_update = Time.now
    @data[card.id] = [Event.new(@last_update, -1.0, rand(3)+1)]
  end
  
  def update_card(card_id, date, quality, strength)
    @history_by_date = nil
    @last_update = date
    @data[card_id] << Event.new(date, quality, strength)
  end
  
  def card_strength(card_id)
    @data[card_id].last.strength
  end
  
  def card_last_update(card_id)
    date = @data[card_id].first.date
    @data[card_id].reject{|e|e.quality == -1.0}.last.try(:date) || date
  end
  
  
  def average_retention(time = 0.day)
    avg = @data.keys.inject(0.0) do |ret,card_id|
      ret + card_retention_in(card_id, time)
    end
    avg/@data.keys.length.to_f
  end
  
  def card_retention_in(card, time=0.day)
    time = @last_update + time
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
          @history_by_date[event.date_to_s] << [card_id, event.strength]
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
  
  def inspect
    str="\n"
    @data.sort.each do |e|
      str << "\t#{e[0]} => #{e[1].length}\n"
      str << "\t    #{e[1].map(&:inspect).join("\n\t    ")} \n"
    end
    str
  end
end

class Event
  attr_accessor :date, :quality, :strength
  def initialize(date, quality, strength)
    @date, @quality, @strength = date, quality, strength
  end
  
  def date_to_s
    @date.strftime("%Y-%m-%d")
  end
  
  def inspect
    "[" <<@date.strftime("%Y-%m-%d") << "]  q:#{@quality}    s:#{@strength}" #if @quality > 0
  end
end
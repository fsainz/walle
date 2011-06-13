class Simulator
  @@initial_strengths = (0..60).to_a.map{|i| rand(10)+3}
#  @@initial_strengths = (100..120).to_a
  attr_reader :history, :number_of_iterations, :engine
  def initialize(algorithm=nil)
    @history = History.new
    @engine = choose_engine(algorithm)
    @automaton = Automata.new(@engine)
    @number_of_iterations = 0
    @cards = []
    create_cards
  end
  
#  def create_cards(number=20)
#    number.times{Card.create} if Card.count < number
#    initial_strengths = [7] * 10 + [7] * 10
#    @cards = Card.limit(number).all
#    @cards.each_with_index do |card, i| 
#      @engine.add_card(card)
#      @history.initialize_card(card, initial_strengths[i])
#    end
#  end

  def create_cards(number=20)
    initial_strengths = [7] * 10 + [7] * 10
    number.times do |i|
      create_card(initial_strengths[i])
    end
  end
  
  def create_card(strength, date = nil)
    new_id = @cards.empty? ? 1 : @cards.last.id+1
    card = Card.find_or_create(new_id)
    @cards << card
    @engine.add_card(card)
    @history.initialize_card(card, strength, date)
    card
  end
  
  def run_iteration(date = Time.now)
    @automaton.get_test(date)
    @automaton.answer_test(date)
    @number_of_iterations += 1
  end
  
#  def simulate(n = 3)
#    date = Time.now + 1.day
#    n.times do
#      run_iteration(date)
#      date = date + @automaton.periodicity
#    end
#    self
#  end
  
  def simulate(length = 1.month)
    deadline = Time.now + length
    date = Time.now + @automaton.periodicity
    while deadline > date
      create_card(@@initial_strengths[@number_of_iterations], date)
      run_iteration(date)
      date = date + @automaton.periodicity
    end
    self
  end

  
  def inspect
    str = "\t"
    str << "@history = #{@history.inspect}\n\n"
    str << "@engine = #{@engine.inspect}\n\n"
    str << "@automaton = #{@automaton.inspect}\n\n"
    str
  end
  
  def choose_engine(name)
    case name
    when :walle_one then WalleEngine::WalleOne.new(@history)
    when :walle_one_random then WalleEngine::WalleOneRandom.new(@history)
    when :walle_one_coma5 then WalleEngine::WalleOneComa5.new(@history)
    when :walle_two then WalleEngine::WalleTwo.new(@history)
    when :walle_three then WalleEngine::WalleThree.new(@history)
    else WalleEngine::WalleRandom.new(@history)
    end
  end
 
end
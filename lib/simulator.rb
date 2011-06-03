class Simulator
  attr_reader :history, :number_of_iterations
  def initialize(algorithm=nil)
    @history = History.new
    @engine = choose_engine(algorithm)
    @automaton = Automata.new(@engine)
    @number_of_iterations = 0
    create_cards
  end
  
  def create_cards(number=20)
    number.times{Card.create} if Card.count < number

    @cards = Card.limit(number).all
    @cards.each do |card| 
      @engine.add_card(card)
      @history.initialize_card(card)
    end
  end
  
  def run_iteration(date = Time.now)
    @automaton.get_test(date)
    @automaton.answer_test(date)
    @number_of_iterations += 1
  end
  
  def simulate(n = 3)
    date = Time.now + 1.day
    n.times do
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
    else WalleEngine::WalleRandom.new(@history)
    end
  end
 
end
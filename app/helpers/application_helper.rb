module ApplicationHelper
  
  def simulator_stats(sim)
    str = "engine: #{sim.engine.class}"
    str << "\n#reviews:#{sim.number_of_iterations} \t"
    str << "S_media:#{sim.history.last_week.strengths.average} \t"
    str << "S_std:#{sim.history.last_week.strengths.standard_deviation} \t"
    str << "R media (a 1 mes):#{sim.history.average_retention(1.month)}"
    str << "\n Not reviewed cards:[#{((1..20).to_a - sim.history.reviewed_cards).join(', ')}]"
    str
  end
  
end

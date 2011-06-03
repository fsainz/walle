module ApplicationHelper
  
  def simulator_stats(sim)
    str = "#reviews:#{sim.number_of_iterations} \t"
    str << "S_media:#{sim.history.last_week.strengths.average} \t"
    str << "S_std:#{sim.history.last_week.strengths.average} \t"
    str << "R media (a 1 mes):#{sim.history.average_retention(1.month)}"
    str
  end
  
end

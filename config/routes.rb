Walle::Application.routes.draw do
  root :to => 'home#index'
  match '/automata'  => 'home#automata'
end

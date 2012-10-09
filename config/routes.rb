Connect::Application.routes.draw do
  match "welcome" => "main#welcome"
  match "auth" => "main#auth"
  match "logout" => "main#logout"


  match "facebook" => "users#facebook", :via => [:post]
  match "major" => "users#major"
  match "pref" => "users#pref", :via => [:post]
  match "done" => "meals#new", :via => [:post]
  match "hiatus" => "users#hiatus"

  root :to => 'main#index'

end

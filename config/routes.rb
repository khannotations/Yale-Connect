Connect::Application.routes.draw do
  match "welcome" => "main#welcome"
  match "auth" => "main#auth"
  match "logout" => "main#logout"
  match "facebook" => "users#facebook", :via => [:post]

  root :to => 'main#index'

end

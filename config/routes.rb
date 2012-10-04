if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :trips
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :trips
  end
end

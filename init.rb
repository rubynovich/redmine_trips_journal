require 'redmine'

Redmine::Plugin.register :redmine_trips_journal do
  name 'Trips journal'
  author 'Roman Shipiev'
  description 'Registration of trips employees (duration of trips are less 24 hours)'
  version '0.0.2'
  url 'https://bitbucket.org/rubynovich/redmine_redmine_trips_journal'
  author_url 'http://roman.shipiev.me'

  project_module :trips do
    permission :view_trips,  :trips => [:index, :show]
  end

  Redmine::MenuManager.map :top_menu do |menu| 

    parent = menu.exists?(:workflow) ? :workflow : :top_menu
    menu.push( :trips, {:controller => :trips, :action => :index}, 
               { :parent => parent,
                 :caption => :label_trip_plural, 
                 :param => :project_id, 
                 :if => Proc.new{ User.current.allowed_to?({:controller => :trips, :action => :index}, nil, {:global => true}) }
               })

  end

  menu( :project_menu, :trips, {:controller => :trips, :action => :index}, 
        { :caption => :label_trip_plural, 
          :param => :project_id, 
          :if => Proc.new{ User.current.allowed_to?({:controller => :trips, :action => :index}, nil, {:global => true}) }
        })

end

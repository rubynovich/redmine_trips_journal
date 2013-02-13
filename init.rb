require 'redmine'

Redmine::Plugin.register :redmine_trips_journal do
  name 'Trips journal'
  author 'Roman Shipiev'
  description 'Plugin is used for registration of trips employees (duration of trips are less 24 hours)'
  version '0.0.2'
  url 'https://github.com/rubynovich/redmine_redmine_trips_journal'
  author_url 'http://roman.shipiev.me'

  project_module :trips do

  end

  menu :top_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_trip_plural, :param => :project_id, :if => Proc.new{User.current.logged?}

  menu :project_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_trip_plural, :param => :project_id, :if => Proc.new{User.current.logged?}, :require => :member
end

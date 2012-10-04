require 'redmine'

Redmine::Plugin.register :redmine_trips_journal do
  name 'Redmine Trips Journal plugin'
  author 'Roman Shipiev'
  description 'Journal of trips for Redmine'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_redmine_trips_journal'
  author_url 'http://roman.shipiev.me'

  project_module :trips do
    permission :view_trips, :estimated_times => [:index], :public => true
  end

  settings :default => { 
                         :issue_tracker => Tracker.first,
                         :issue_priority => IssuePriority.default,
                         :issue_status => IssueStatus.default
                       }, 
           :partial => 'trips/settings'
           
  menu :top_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_trip_plural, :param => :project_id, :if => Proc.new{User.current.logged?}
  
  menu :project_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_planning, :param => :project_id, :if => Proc.new{User.current.logged?}, :require => :member
end

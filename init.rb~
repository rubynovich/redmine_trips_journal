require 'redmine'

Redmine::Plugin.register :redmine_trips_journal do
  name 'Журнал разъездов'
  author 'Roman Shipiev'
  description 'Журнал разъездов нужен, чтобы регистрировать местные командировки работников длительностью не более суток. При подключении модуля появляется ссылка "Журнал разъездов" в top_menu (там, где и "Домашняя страница")'
  version '0.0.2'
  url 'https://github.com/rubynovich/redmine_redmine_trips_journal'
  author_url 'http://roman.shipiev.me'

  project_module :trips do
    permission :view_trips, :estimated_times => [:index], :public => true
  end

  settings :default => { 
                         :issue_tracker => Tracker.first.id,
                         :issue_priority => IssuePriority.default.id,
                         :issue_status => IssueStatus.default.id
                       }, 
           :partial => 'trips/settings'
           
  menu :top_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_trip_plural, :param => :project_id, :if => Proc.new{User.current.logged?}
  
  menu :project_menu, :trips, {:controller => :trips, :action => :index}, :caption => :label_planning, :param => :project_id, :if => Proc.new{User.current.logged?}, :require => :member
end

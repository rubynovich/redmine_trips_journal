module RedmineTripsJournal
  class Hooks < Redmine::Hook::ViewListener
    #render_on :view_issues_sidebar_issues_bottom, :partial => 'issues/recurrence', :locals => {:issue => @issue}
    render_on :view_issues_sidebar_planning_bottom, :partial => 'issues/tune_in', :locals => {:issue => @issue}
  end
end 

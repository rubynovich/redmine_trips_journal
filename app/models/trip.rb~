class Trip < ActiveRecord::Base
  unloadable
  
  belongs_to :user
  belongs_to :project
  belongs_to :issue
  if Redmine::Plugin.find(:redmine_planning)
    belongs_to :estimated_time, :dependent => :delete    
  end
   
  before_validation :fresh_project_id
  validates_presence_of :project_id, :issue_id, :trip_on, 
    :trip_start_time, :trip_end_time, :comments, :user_id
  validates_uniqueness_of :trip_on, :scope => [:user_id, :trip_start_time, :project_id]
  validates_uniqueness_of :trip_start_time, :scope => [:trip_on, :user_id, :project_id]
  validate :check_trip_on
  validate :check_trip_end_time, :if => lambda{ |object|
    object.trip_start_time.present? && object.trip_end_time.present? 
  }    
    
  if Rails::VERSION::MAJOR >= 3  
    scope :in_projects, lambda{ |project_ids|
      where("project_id IN (?)", project_ids)
    }
    
    scope :actual, lambda{ |start_date, due_date|
      if start_date.present? && due_date.present?
        where("trip_on BETWEEN ? AND ?", start_date, due_date)
      end          
    }    
  else
    named_scope :in_projects, lambda{ |project_ids|
      {
        :conditions => ["project_id IN (?)", project_ids]
      }
    }
    
    named_scope :actual, lambda{ |start_date, due_date|
      if start_date.present? && due_date.present?
        { :conditions => 
            ["trip_on BETWEEN :start_date AND :due_date",
              {:start_date => start_date, :due_date => due_date}]
        }
      end          
    }
  end
  
  def check_trip_on
    if self.trip_on < Date.today      
      errors.add :trip_on, :invalid
    end    
  end

  def check_trip_end_time
    if self.trip_end_time-self.trip_start_time <= 0.0
      errors.add :trip_start_time, :invalid    
      errors.add :trip_end_time, :invalid
    end  
  end
  
  def fresh_project_id
    self.project_id = self.issue.project_id
  end
  
  def create_plan
    self.estimated_time = EstimatedTime.create(
      :issue => self.issue,
      :plan_on => self.trip_on,
      :user => User.current,
      :comments => self.comments,
      :hours => (self.trip_end_time - self.trip_start_time)/3600
    ) if Redmine::Plugin.find(:redmine_planning)
  end
  
  def update_plan
    self.estimated_time.update_attributes(
      :plan_on => self.trip_on,
      :user => User.current,
      :comments => self.comments,
      :hours => (self.trip_end_time - self.trip_start_time)/3600
    ) if Redmine::Plugin.find(:redmine_planning)
  end
  
  private
#    def issue_subject
#      I18n.t(:trips_issue_subject, :comments => self.comments)      
#    end
end

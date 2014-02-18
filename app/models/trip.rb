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
  validate :check_trip_on, if: Proc.new{|o| o.trip_on.present? && (o.trip_on < Date.today)}
  validate :check_trip_end_time, if: Proc.new{ |o| o.trip_start_time.present? && o.trip_end_time.present?}
  validate :check_start_date_due_date, if: Proc.new{|o|
    o.issue.present? && o.trip_on.present? &&
    o.issue.start_date.present? && o.issue.due_date.present?
  }

  scope :in_projects, lambda{ |project_ids|
    where("project_id IN (?)", project_ids)
  }

  scope :actual, lambda{ |start_date, due_date|
    if start_date.present? && due_date.present?
      where("trip_on BETWEEN ? AND ?", start_date, due_date)
    end
  }

  def check_trip_on
    errors.add :trip_on, :invalid
  end

  def check_start_date_due_date
    errors.add :trip_on, :issue_start_date_overflow if (self.issue.start_date > self.trip_on)
    errors.add :trip_on, :issue_due_date_overflow if (self.issue.due_date < self.trip_on)
  end

  def check_trip_end_time
    if self.trip_end_time.seconds_since_midnight - self.trip_start_time.seconds_since_midnight <= 0
      errors.add :trip_start_time, :invalid
      errors.add :trip_end_time, :invalid
    end
  end

  def fresh_project_id
    self.project_id = self.issue.try(:project_id)
  end

  def create_plan
    self.estimated_time = EstimatedTime.new(
      :issue => self.issue,
      :plan_on => self.trip_on,
      :user => User.current,
      :comments => self.comments,
      :hours => (self.trip_end_time.seconds_since_midnight - self.trip_start_time.seconds_since_midnight)/3600.0
    ) if Redmine::Plugin.find(:redmine_planning)
  end

  def update_plan
    self.estimated_time.update_attributes(
      :plan_on => self.trip_on,
      :user => User.current,
      :comments => self.comments,
      :hours => (self.trip_end_time.seconds_since_midnight - self.trip_start_time.seconds_since_midnight)/3600.0
    ) if Redmine::Plugin.find(:redmine_planning)
  end
end

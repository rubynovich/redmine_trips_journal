class TripsController < ApplicationController
  unloadable
  before_filter :author_required, :only => [:edit, :update, :destroy, :show]
  before_filter :get_projects, :only => [:index, :new, :create, :edit, :update]
  before_filter :get_issues, :only => [:index, :new, :create, :edit, :update]
  before_filter :get_current_date
  before_filter :new_object, :only => [:create]
  before_filter :find_object, :only => [:edit, :show, :update, :destroy]
  before_filter :set_today_for_new_object, :only => [:index, :new]

  def index
    @current_dates = [@current_date-2.week, @current_date-1.week, @current_date, @current_date+1.week, @current_date+2.week]
    @collection = Trip.actual(@current_date, @current_date+6.days)
  end

  def new
  end

  def create
    @object.user = User.current
    @object.create_plan
    if @object.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default :action => :index
    else
      render action: 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @object.update_attributes(params[:trip])
      if @object.issue && @object.estimated_time
        @object.update_plan
      else
        @object.create_plan
        @object.save
      end
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default action: 'index'
    else
      render action: 'edit'
    end
  end

  def destroy
    begin
      @object.destroy
    rescue
      flash[:error] = l(:error_unable_delete_trip)
    else
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to params.merge(action: 'index')
  end

  private
    def author_required
      (render_403; return false) unless User.current == Trip.find(params[:id]).user
    end

    def get_project
      @project = if params[:project_id].present?
        Project.find_by_identifier(params[:project_id])
      end
    end

    def get_issues
      conditions = {:assigned_to_id => ([User.current.id] + User.current.group_ids)}
      if @project.present?
        conditions.merge!(:project_id => @project.id)
      end
      @issues = Issue.open.visible.on_active_project.
        find(:all,
        :conditions => conditions,
        :include => [:status, :project, :tracker, :priority],
        :order => "#{Issue.table_name}.id DESC")
#        :order => "#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.due_date")
    end

    def get_projects
      if params[:project_id]
        @projects = Project.active.where(identifier: params[:project_id])
      else
        @projects = Project.active.all(:order => :name)
      end

    end

    def get_current_date
      @current_date = if params[:current_date].blank?
        Date.today
      else
        Date.parse(params[:current_date])
      end
      @current_date -= @current_date.wday.days - 1.day
    end

    def new_object
      @object = Trip.new(params[:trip])
      @object.project_id = @project.id if get_project.present?
    end

    def find_object
      @object = Trip.find(params[:id])
    end

    def set_today_for_new_object
      new_object
      @object.trip_on = Date.today
    end
end

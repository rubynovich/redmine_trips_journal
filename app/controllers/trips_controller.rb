class TripsController < ApplicationController
  unloadable
  before_filter :author_required, :only => [:edit, :update, :destroy, :show]
  before_filter :get_projects, :only => [:index, :new, :create, :edit, :update]  
  before_filter :get_current_date
  before_filter :new_object, :only => [:index, :new, :create]
  before_filter :find_object, :only => [:edit, :show, :update, :destroy]

  def index
      @current_dates = [@current_date-2.week, @current_date-1.week, @current_date, @current_date+1.week, @current_date+2.week]  
    @collection = Trip.actual(@current_date, @current_date+6.days).in_projects(@projects.map(&:id))
  end
  
  def new
  end
  
  def create
    @object.user = User.current
    if @object.valid?
      @object.create_issue
      @object.save
      flash[:notice] = l(:notice_successful_create)
      redirect_back_or_default :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def show
  end
  
  def update
    if @object.update_attributes(params[:trip])
      @object.update_issue
      @object.update_plan if @object.issue && @object.estimated_time
      flash[:notice] = l(:notice_successful_update)    
      redirect_back_or_default :action => :index
    else
      render :action => :edit
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
    redirect_to params.merge(:action => :index)
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

    def get_projects
      @projects = if get_project.present?
        [@project]
      else
        Member.find(:all, :conditions => {:user_id => User.current.id}).map(&:project)
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
end

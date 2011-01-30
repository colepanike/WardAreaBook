class ReportsController < ApplicationController
  before_filter :store_return_point
  caches_action :hope, :monthlyReport, :allMonthlyReports, :layout => false

  # override the application accessLevel method
  def checkAccess
    #only the ward council has access
    if hasAccess(2)
      true
    else
      deny_access
    end
  end

  # TODO reference the hopes by name not id 1
  def hope
    @events = Event.find_all_by_person_id(1, :order => 'date DESC')
    @event_weeks = @events.group_by { |week| week.date.at_beginning_of_week }
  end

  def print
    # TODO have the specific week sent to me
    @week = Date.parse(params[:date])
    @events = Event.find_all_by_person_id(1, :conditions => {:date => @week..@week.advance(:days => 6)}, 
                                             :order => 'date DESC')
    render :layout => 'print'
  end

  def allMonthlyReports
    @events = Event.find(:all, :conditions => "category != 'Attempt' and 
                                               category != 'Other' and
                                               category is not NULL", 
                         :order => 'date DESC')
    @event_months = @events.group_by { |month| month.date.at_beginning_of_month }
    render :monthlyReport
  end
  
  def monthlyReport
    range =  2.months.ago.at_beginning_of_month.to_date
    @events = Event.find(:all, :conditions => ["(category != 'Attempt' and 
                                                 category != 'Other' and  
                                                 category is not NULL) and (date > ?)", range],
                         :order => 'date DESC')
    @event_months = @events.group_by { |month| month.date.at_beginning_of_month }
  end
end

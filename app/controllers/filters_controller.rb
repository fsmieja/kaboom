class FiltersController < ApplicationController
  include   ApplicationHelper

  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  
  def index
    order_str = sort_column + " "  + sort_direction
    
    @filters = Filter.order(order_str).uniq
  end
  
  def delete_all
    @removed = false
    @filter_ids = params[:filter_ids]
     if Filter.delete_all( {id: params[:filter_ids]})
       @removed = true
     else
       @error_messages = "Unable to complete delete request"
     end 
  end
  
  def show
    @filter = Filter.find(params[:id])  
  end
  
  def new
    @filter = Filter.new
  end
  
  def create
    filter = Filter.find_by_name(params[:filter][:name])
    if filter
      @added = false
      filter.update_attributes(params[:filter])
      @updated = true
    else
      filter = Filter.new(params[:filter])
      @added = true
      @new_filter = filter
    end
    if !filter.save!
      @message = "Error saving filter"
      @added = false
      @updated = false
    end
  end
  
  def edit
    @filter = Filter.find(params[:id])
  end
  
  def update
    @filter = Filter.find(params[:id])
    @filter.update_attributes(params[:filter])
    respond_with_bip @filter
  end
  
  def select
    @filter = Filter.find(params[:filter_id])  
  end
  
  private
  
  def sort_column
     Filter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
end

class ProjectsController < ApplicationController
  
  include ApplicationHelper
  
  def index
    @projects = Project.all
  end
    
  def new
    @project = Project.new
  end
  
  def create
    project = Project.new(params[:project])
    if !project.save!
      flash.now[:error] = "Error creating project"
      render 'new'
    else
      redirect_to projects_path, :notice => "Created project"     
    end
  end
  
  def edit
    @project = Project.find(params[:id])  
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash.now[:success] = "Updated project"
    else
      flash.now[:error] = "Error updating project"
    end
    render 'edit'
  end
  
  def show
    @project = Project.find(params[:id])
    @num_notes = @project.notes.count
    @num_tags = @project.tags.count
    if params[:pretty]
      @notes = @project.notes.order("created_at desc")
      @tag_numbers = {}
      @project.add_tag_numbers(@tag_numbers)    
      @tags = (@project.tags + @project.note_tags).uniq
      render :pretty_show
    end
  end

  def notes
    @project = Project.find(params[:id])    
      
    @per_page = params[:per_page] ||  20
    order_str = sort_column + " "  + sort_direction
    @notes = @project.notes.order(order_str).page(params[:page]).per_page(@per_page)
    add_tag_numbers_across_notes(@notes)
    @tags = @project.tags.uniq
  end  
  
  
  def tag
    @added = false
    @project = Project.find(params[:id])
        
    t = Tag.find_or_create_tag(params[:new_tag])
    if !t
      @tag_message = "Tag must be at least 2 characters long"
    else
      if @project.tags.include? t
        @tag_message = "Already have that tag"
      else    
        @project.tags << t
        @tag_message = "Added tag"
        @added = true
      end
    end
    @tags = @project.tags 
    @new_tag = t
  end  
  
  private


end

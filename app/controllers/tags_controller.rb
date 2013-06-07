class TagsController < ApplicationController
  include   ApplicationHelper

  helper_method :sort_column, :sort_direction

  def index
    order_str = sort_column + " "  + sort_direction
    
    @unused_tags =  Tag.joins("left join note_taggings n on tags.id = n.tag_id").where("n.id is null").order("name asc").uniq
    @used_tags = Tag.joins("left join note_taggings n on tags.id = n.tag_id").where("n.id is not null").order(order_str).uniq
  end
  
  def delete_all
    @removed = false
    @tag_ids = params[:tag_ids]
     if Tag.delete_all( {id: params[:tag_ids]})
       @removed = true
     else
       @error_messages = "Unable to complete delete request"
     end 
  end
  
  def mindmap
    #@project = Project.find(params[:id])
    tag_id = params[:id]
    #if !tag_id
    #  tag_id = @project.notes[0].tags[0] 
    #end
    @tag = Tag.find(tag_id)
    @neighbour_tags = @tag.get_node_tags
    @depth = 2
  end
  
  def destroy
    tag = Tag.find(params[:id])
    @id = params[:id]
    @removed = false
    notes = Note.includes(:tags).where(:tags => { :id => @id })
    if notes.count > 0
      @tag_message = "Unable to delete tag since it is being used"
    else
      tag.destroy
      @removed = true
    end
  end
  
  def show
    @tag = Tag.find(params[:id])  
    @notes = @tag.notes
    get_projects(@notes)  # sets @projects ad @project_numbers
  end
  
  def new
    @many = params[:many]
    @tag = Tag.new
  end
  
  def create
    if !Tag.create_tags(params[:tag][:name],params[:many])
      flash.now[:error] = "Error adding tag(s)"
      render 'new'
    else
      redirect_to tags_path, :notice => "Added new tag(s)"     
    end
  end
  
  def edit
    @tag = Tag.find(params[:id])  
  end
  
  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash.now[:success] = "Updated tag"
    else
      flash.now[:error] = "Error updating tag"
    end
    render 'edit'
  end
  
  private
  
  def get_projects(notes)
    projects = []
    project_count = {}
    if notes
      notes.each do |m|
        projects << m.project
        add_to_project_count(project_count,m.project_id)
      end
    end
    @projects = projects.uniq
    @project_numbers = project_count
  end

  def add_to_project_count(project_count,id)
    if project_count[:project_id => id]
      project_count[:project_id => id] += 1
    else
      project_count[:project_id => id] = 1
    end
  end
  
  def sort_column
      if params[:sort]=="times_used"
        "times_used"
      else
        Tag.column_names.include?(params[:sort]) ? params[:sort] : "name"
      end
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
end

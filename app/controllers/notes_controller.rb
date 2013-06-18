class NotesController < ApplicationController
  
  include   NotesHelper
  include   ApplicationHelper
  
  helper_method :sort_column, :sort_direction

  def index
    @project = Project.find(params[:id])    
    @tag_numbers = {}
    @project.add_tag_numbers(@tag_numbers)    
    @tags = (@project.tags + @project.note_tags).uniq
    @all_tags = (@project.tags + @project.note_tags).uniq
    if params[:pretty]
      @notes = @project.notes.joins("LEFT OUTER JOIN positions on positions.note_id = notes.id").order("z_index asc")
      @note = Note.new
      render :notes_table, layout: 'note_table'
    else
      @per_page = params[:per_page] ||  20
      order_str = sort_column + " "  + sort_direction
      @notes = @project.notes.order(order_str).page(params[:page]).per_page(@per_page)
    end
  end

  def search
    project = Project.find(params[:id])
    searchStr = params[:str]
    searchType = params[:search_type]
    if searchType=="Tags"
      @notes = project.notes.joins("inner join note_taggings n on notes.id = n.note_id inner join tags t on n.tag_id = t.id LEFT OUTER JOIN positions on positions.note_id = notes.id").order("z_index asc").where("t.name like '%#{searchStr}%'").uniq
    else
      @notes = project.notes.joins("LEFT OUTER JOIN positions on positions.note_id = notes.id").order("z_index asc").where("notes.title like '%#{searchStr}%' or notes.content like '%#{searchStr}%' or notes.location like '%#{searchStr}%'").uniq
    end
    respond_to do |format|
      format.js # search.js.erb
    end
  end
      
  def divide
      @project = Project.find(params[:id])  
      @note = Note.new
      tag_name = params[:category]
      tag = Tag.find_by_name(tag_name)
      if tag.nil?
        tag = Tag.new({name: params[:category]})
        tag.save!
      end  
      @tag = tag
      @notes_with_tag = @tag.notes
      @notes_without_tag = @project.notes - @notes_with_tag
      @all_tags = (@project.tags + @project.note_tags).uniq
      render :divide_and_conquer, layout: 'note_table'
  end

  def divide_query
      @project = Project.find(params[:id])    
      #@tag = Tag.find(params[:tag_id])
      @tag = Tag.find(8)
      @notes_with_tag = @tag.notes
      @notes_without_tag = @project.notes - @notes_with_tag
  end
  
  def tags
    @note = Note.find(params[:id])    
    @tags = @note.tags.order("name asc")
    @all_tags = @note.project.tags.uniq
    render 'tags/tags'
  end

  def new
    @project = Project.find(params[:id])
    @note = Note.new
  end
  
  def create
    @project = Project.find(params[:id])
    @note = @project.notes.build(params[:note])
    @added = true
    if !@note.save!
      @message = flash.now[:error] = "Error creating note"
      @added = false
      respond_to do |format|
        format.html { render 'new' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to notes_path(@project) }
        format.js
      end
    end
  end

  
  def edit
    @note = Note.find(params[:id])  
    @project = @note.project
  end
  
  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash.now[:success] = "Updated note"
    else
      flash.now[:error] = "Error updating note"
    end
    render 'edit'
  end
  
  def create_tag
    @wide_layout = true
    @note = Note.find(params[:id])
    @tags = @note.tags
    @all_tags = @note.project.tags.uniq
  end
  
  def set_position
    
    note = Note.find(params[:id])
    project_notes = note.project.notes
    max_z = 0
    project_notes.each do |n|
      if !n.position.nil?
        this_z = n.position.z_index
        if !this_z.nil? && this_z > max_z
          max_z = this_z
        end
      end
    end
    position = note.position
    if position.nil?
      position = note.build_position()
    end
    position.top = params[:top]
    position.left = params[:left]
    position.z_index = max_z+1
    position.save!
    render nothing: true
  end
  
  def toggle_tag
    @note = Note.find(params[:target_note_id])        
    @tag = Tag.find(params[:tag_id])
    if @note.tags.include?(@tag)
      @note.tags.delete(@tag)
      @result = "removed"
    else
      @note.tags << @tag
      @result = "added"
    end
    @tag_str=render_to_string(partial: 'notes/tagged_icon', locals: {note_id: @note.id, num_tags: @note.tags.count}, :layout => false)
    @tag_str = @tag_str.html_safe.gsub("\n"," ") if !@tag_str.nil?
    puts @tag_str
    respond_to do |format|
      format.js
    end
  end
  
  def tag
    @added = false
    note = Note.find(params[:id])
        
    t = Tag.find_or_create_tag(params[:new_tag])
    if !t
      @tag_message = "Tag must be at least 2 characters long"
    else
      if note.tags.include? t
        @tag_message = "Already have that tag"
      else    
        note.tags << t
        @tag_message = "Added tag"
        @added = true
      end
    end
    @tags = note.tags 
    @new_tag = t
    
  end
  
  def remove_tag
    @removed = false
    tag_id = params[:tag_id]
    note = Note.find(params[:id])
    tag = note.tags.find(tag_id)
    rescue
      @tag_message = "Not able to remove tag"
    else
      note.tags.delete(tag)  
      @removed = true
      @remove_tag = tag_id
      @tags = note.tags
  end
    
  def show
    @note = Note.find(params[:id])
    @tags = @note.tags
    project = @note.project
    @all_tags = (project.tags+project.note_tags).uniq
    @new_note = Note.new
  end
  
  def destroy
    note = Note.find(params[:id])
    project = note.project
    @id = params[:id]
    note.destroy
    @removed = true
    respond_to do |format|
      format.html { redirect_to notes_path(project), notice: "Deleted note" }
      format.js
    end
  end
  
  private
   

  
  def sort_column
      Note.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  
end

class ProjectsController < ApplicationController
  respond_to :html, :js
  expose( :projects) { current_person.projects.by_name}
  expose( :project ){ projects.find( params[:id])}
  in_place_edit_for :project, :name
  
  
  def create
    @project = Project.create_for_owner params[:project], current_person
    respond_with @project
  end
end

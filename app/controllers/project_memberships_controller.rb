class ProjectMembershipsController < ApplicationController
  respond_to :html, :js
  expose(:project) {current_person.projects.find params[:project_id]}
  expose(:project_membership) {project.project_memberships.find params[:id]}
  
  def create
    @project_membership = project.invite_member params[:project_membership].merge({:invited_by => current_person})
    respond_with @project_membership
  end
  
  def destroy
    @project_membership = project_membership.destroy
    respond_with project_membership
  end
end

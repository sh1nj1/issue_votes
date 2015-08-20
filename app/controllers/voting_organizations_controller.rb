class VotingOrganizationsController < ApplicationController
  unloadable

  # Ensure that we have admin permissions before going further.
  before_filter :require_admin

  # Index-action for voting organizations: list of existing organizations with relevant actions.
  # Index-view for this controller is a partial view.
  def _index
    @voting_organizations = VotingOrganization.all
  end

  # New-action for voting organizations
  def new
    @voting_organization = VotingOrganization.new

  end

  # Edit-action for voting organizations
  def edit
    @redirect_user_id = params[:redirect_user_id]
    @voting_organization = VotingOrganization.find(params[:id])
  end

  # Update-action for voting organizations
  def update
    @redirect_user_id = params[:voting_organization][:redirect_user_id]
    @voting_organization = VotingOrganization.find(params[:id])
    if @voting_organization.update_attributes(params[:voting_organization])
      flash[:notice] = l(:notice_voting_organization_successful_update)
      redirect_to edit_user_path(:id => @redirect_user_id, :tab => 'voting_organizations')
    else
      flash[:error] = l(:error_voting_organization_failed_update) + ': ' +  @voting_organization.errors.full_messages.to_s
      redirect_to edit_user_path(:id => @redirect_user_id, :tab => 'voting_organizations')
    end
  end

  # Create-action for voting organizations
  def create
    @voting_organization = VotingOrganization.new
    @voting_organization.name = params[:voting_organization][:name]
    @redirect_user_id = params[:voting_organization][:redirect_user_id]
    if @voting_organization.save
      flash[:notice] = l(:notice_voting_organization_successful_creation)
      redirect_to edit_user_path(:id => @redirect_user_id, :tab => 'voting_organizations')
    else
      @errors = @voting_organization.errors
      flash[:error] = l(:error_voting_organization_failed_creation) + ': ' + @errors.full_messages.to_s
      redirect_to new_voting_organization_path(:redirect_user_id => @redirect_user_id)
    end
  end

  # Delete-action for voting organizations
  def delete
    @redirect_user_id = params[:redirect_user_id]
    @voting_organization_id = params[:id]
    @voting_organization = VotingOrganization.find(@voting_organization_id)
    if @voting_organization && @voting_organization.delete
      VotingOrganization.delete(@voting_organization_id)
      flash[:notice] = l(:notice_voting_organization_successful_delete)
      redirect_to edit_user_path(:id => @redirect_user_id, :tab => 'voting_organizations')
    else
      @errors = l(:error_voting_organization_not_found) || @voting_organization.errors
      if @errors.instance_of?(ActiveRecord::Errors)
        flash[:error] = @errors.full_messages.to_s
      else
        flash[:error] = @errors
      end
      redirect_to edit_user_path(:id => @redirect_user_id, :tab => 'voting_organizations')
    end
  end
end
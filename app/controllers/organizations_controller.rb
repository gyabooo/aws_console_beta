class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:edit, :update, :destroy]

  def index
    @organizations = policy_scope(Organization.all)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to organizations_url, flash: {success: '組織の作成に成功しました'}
    else
      render :new
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to organizations_url, flash: {success: '組織の編集に成功しました'}
    else
      render :edit
    end
  end

  def destroy
    if @organization.destroy
      redirect_to organizations_url, notice: "組織#{@organization.name}の削除に成功しました。"
    else
      @organizations = Organization.all
      render :index
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name).merge(owner_id: current_user.id, user_ids: [current_user.id])
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end

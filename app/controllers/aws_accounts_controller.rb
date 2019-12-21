class AwsAccountsController < ApplicationController
  before_action :set_aws_account, only: [:edit, :update, :destroy]
  before_action :set_all_organizations, only: [:new, :edit]

  def index
    @aws_accounts = current_user.aws_accounts
  end

  def new
    @aws_account = AwsAccount.new(external_id: SecureRandom.uuid)
  end

  def create
    @aws_account = AwsAccount.new(aws_account_params)
    if @aws_account.save
      redirect_to aws_accounts_url, flash: {success: 'Yes!! Success'}
    else
      render :new
    end
  end

  def update
    if @aws_account.update(aws_account_params)
      redirect_to aws_accounts_url, flash: {success: "#{@aws_account.name}の編集に成功しました"}
    else
      render :edit
    end
  end

  def destroy
    if @aws_account.destroy
      redirect_to aws_accounts_url, notice: "#{@aws_account.name}の削除に成功しました。"
    else
      @aws_accounts = AwsAccount.all
      render :index
    end
  end

  private

  def aws_account_params
    # binding.pry
    params.require(:aws_account).permit(
      :name, :description, :account_id, :organization_id, :external_id, :role_name
    )
  end

  def set_aws_account
    @aws_account = AwsAccount.find(params[:id])
  end

  def set_all_organizations
    @organizations = policy_scope(Organization.all)
  end
end

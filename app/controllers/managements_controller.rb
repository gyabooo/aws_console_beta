class ManagementsController < ApplicationController
  include CommonAws

  def index
    @aws_accounts = current_user.aws_accounts
    @ec2 = {}
    @console_urls = {}

    @aws_accounts.each do |aws_account|
      aws_account_args = [
        aws_account.external_id,
        aws_account.account_id,
        aws_account.role_name
      ]

      @ec2.store(
        aws_account.id,
        get_ec2_instances(*aws_account_args)
      )

      @console_urls.store(
        aws_account.id,
        get_console_url(*aws_account_args)
      )

      # instances = @ec2[aws_account.id].instances.map do |instance|
      #   Ec2Instance.new(
      #     instance_id: instance.id,
      #     aws_account_id: aws_account.id
      #   )
      # end

      # update_instances(instances)
    end

  end

  private

  def get_console_url(external_id, account_id, role_name)
    session = get_role(external_id, account_id, role_name)

    issuer_url = "https://mysignin.internal.mycompany.com/"
    console_url = "https://console.aws.amazon.com/"
    signin_url = "https://signin.aws.amazon.com/federation"

    session_json = {
      :sessionId => session.credentials[:access_key_id],
      :sessionKey => session.credentials[:secret_access_key],
      :sessionToken => session.credentials[:session_token]
    }.to_json

    get_signin_token_url = signin_url + 
                          "?Action=getSigninToken" + 
                          "&SessionType=json&Session=" + 
                          CGI.escape(session_json)

    returned_content = URI.parse(get_signin_token_url).read
    signin_token = JSON.parse(returned_content)['SigninToken']
    signin_token_param = "&SigninToken=" + CGI.escape(signin_token)
    issuer_param = "&Issuer=" + CGI.escape(issuer_url)
    destination_param = "&Destination=" + CGI.escape(console_url)

    return signin_url + "?Action=login" + signin_token_param + issuer_param + destination_param
  end

  def get_ec2_instances(external_id, account_id, role_name)
    ec2 = Aws::EC2::Resource.new(region: Rails.application.credentials.aws[:region], credentials: get_role(external_id, account_id, role_name))
  end

  def get_role(external_id, account_id, role_name)
    client = Aws::STS::Client.new(
      region: Rails.application.credentials.aws[:region]
    )

    role = client.assume_role({
      external_id: external_id, 
      role_arn: "arn:aws:iam::#{account_id}:role/#{role_name}", 
      role_session_name: "#{account_id}_#{role_name}",
      duration_seconds: 900
    })
  end
end

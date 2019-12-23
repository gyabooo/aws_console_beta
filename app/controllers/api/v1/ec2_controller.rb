class Api::V1::Ec2Controller < ApplicationController
  before_action :set_ec2_instance

  def start
    result = {}

    if @instance.exists?
      case @instance.state.code
      when 0  # pending
        puts "#{@instance.id} is pending, so it will be running in a bit"
      when 16  # started
        puts "#{@instance.id} is already started"
      when 48  # terminated
        puts "#{@instance.id} is terminated, so you cannot start it"
      else
        @instance.start
        begin
          @instance.wait_until_running
        rescue Aws::Waiters::Errors::WaiterFailed
          result.store('status', 'false')
        end
        result.store('status', 'true')
      end
    end

    render json: result
  end

  def stop
    result = {}

    if @instance.exists?
      case @instance.state.code
      when 48  # terminated
        puts "#{@instance.id} is terminated, so you cannot stop it"
      when 64  # stopping
        puts "#{@instance.id} is stopping, so it will be stopped in a bit"
      when 89  # stopped
        puts "#{@instance.id} is already stopped"
      else
        @instance.stop
        begin
          @instance.wait_until_stopped
        rescue Aws::Waiters::Errors::WaiterFailed
          result.store('status': false)
        end
        result.store('status', true)
      end
    end

    render json: result
  end

  def restart
    result = {}

    if @instance.exists?
      case @instance.state.code
      when 48  # terminated
        puts "#{@instance.id} is terminated, so you cannot reboot it"
      else
        @instance.reboot
        begin
          @instance.wait_until_running
        rescue Aws::Waiters::Errors::WaiterFailed
          result.store('status': false)
        end
        result.store('status', true)
      end
    end

    render json: result
  end

  private

  def ec2_params
    params.require(:aws_account).permit(:account_id, :external_id, :role_name).merge(instance_id: params[:instance_id])
  end

  def set_ec2_instance
    client = Aws::STS::Client.new(
      region: Rails.application.credentials.aws[:region]
    )

    role = client.assume_role({
      external_id: ec2_params[:external_id], 
      role_arn: "arn:aws:iam::#{ec2_params[:account_id]}:role/#{ec2_params[:role_name]}", 
      role_session_name: "#{ec2_params[:account_id]}_#{ec2_params[:role_name]}",
      duration_seconds: 900
    })
    
    ec2 = Aws::EC2::Resource.new(region: Rails.application.credentials.aws[:region], credentials: role)
    @instance = ec2.instance(ec2_params[:instance_id])
  end

end

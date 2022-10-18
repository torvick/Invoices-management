class Api::V1::SessionsController < Devise::SessionsController
  before_action :logs
  respond_to :json

  def new
    response_method_controller("Invalid Token/Invalid Authentication",false)
    response = ResponsesEngine.build!(params)
    render json: response, status: :unauthorized
  end

  private

  def respond_with(resource, _opts = {})
    response_method_controller('Logged.',true)
    response = ResponsesEngine.build!(params)
    render json: response, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    response_method_controller('Logged out.',true)
    response = ResponsesEngine.build!(params)
    render json: response, status: :ok
  end

  def log_out_failure
    response_method_controller('Logged out failure.',false)
    response = ResponsesEngine.build!(params)
    render json: response, status: :unauthorized
  end

  def logs
    params[:method]         = request.env['REQUEST_METHOD']
    params[:url_path]       = request.url
    params[:request_id]     = request.request_id
    params[:request_ip]     = request.remote_ip
    uri                     = URI(params[:url_path])
    params[:get_host]       = "#{uri.scheme}://#{uri.host}"
  end

  def response_method_controller(data, status)
    params[:data] = {}
    if status
      params[:data][:code]  = 201
      params[:data]['data'] = data
    else
      params[:data][:code]    = 400
      params[:data][:errors]  = [data]
      params[:data][:message] = data
    end
  end
end

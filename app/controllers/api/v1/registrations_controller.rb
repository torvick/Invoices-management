class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :logs
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    response_method_controller({user: resource, message: 'Signed up.'},true)
    response = ResponsesEngine.build!(params)
    render json: response, status: :created
  end

  def register_failed
    response_method_controller(resource.errors,false)
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
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

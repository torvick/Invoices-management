class Api::V1::BaseController < ApplicationController

  private

  def logs
    params[:current_user]   = "Hi: #{current_user.name}"
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

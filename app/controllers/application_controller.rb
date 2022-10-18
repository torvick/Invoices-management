# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:name, :rfc, :email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
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

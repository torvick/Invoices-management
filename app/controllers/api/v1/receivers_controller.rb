class Api::V1::ReceiversController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :logs
  before_action :set_user, only: %i[ show update destroy]

  def index
    @users = User.all
    response_method_controller(@users,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: :ok
  end

  def update
    if @user.update(receiver_params)
      # render json: @user, status: :ok
      response_method_controller( @user,true)
    else
      # render json: @user.errors, status: :unprocessable_entity
      response_method_controller( @user.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def destroy
    if @user.destroy
      # render json: @user, status: :ok
      response_method_controller( @user,true)
    else
      # render json: @user.errors, status: :unprocessable_entity
      response_method_controller( @user.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def show
    # render json: @user, status: :ok
    response_method_controller( @user,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_user")
    response_method_controller( @error.description,false)
    params[:code] = @error.value
    response = ResponsesEngine.build!(params)
    return render json: response, status: :unprocessable_entity
  end

  def receiver_params
    params.require(:receiver).permit(:name, :rfc, :status)
  end

end

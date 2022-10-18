class Api::V1::EmittersController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :logs
  before_action :set_emitter, only: %i[ show update destroy]

  def index
    @emitters = Emitter.all
    response_method_controller(@emitters,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: :ok
  end

  def create
    @emitter = Emitter.new(emitter_params)
    if @emitter.save
      # render json: @emitter, status: :created
      response_method_controller( @emitter,true)
      response = ResponsesEngine.build!(params)
      return render json: response, status: :created
    else
      # render json: @emitter.errors, status: :unprocessable_entity
      response_method_controller( @emitter.errors,false)
      response = ResponsesEngine.build!(params)
      return render json: response, status: :unprocessable_entity
    end
  end

  def update
    if @emitter.update(emitter_params)
      # render json: @emitter, status: :ok
      response_method_controller( @emitter,true)
    else
      # render json: @emitter.errors, status: :unprocessable_entity
      response_method_controller( @emitter.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def destroy
    if @emitter.destroy
      # render json: @emitter, status: :ok
      response_method_controller( @emitter,true)
    else
      # render json: @emitter.errors, status: :unprocessable_entity
      response_method_controller( @emitter.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def show
    # render json: @emitter, status: :ok
    response_method_controller( @emitter,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  private

  def set_emitter
    @emitter = Emitter.find(params[:id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_emitter")
    response_method_controller( @error.description,false)
    params[:code] = @error.value
    response = ResponsesEngine.build!(params)
    return render json: response, status: :unprocessable_entity
  end

  def emitter_params
    params.require(:emitter).permit(:name, :rfc, :status)
  end

end

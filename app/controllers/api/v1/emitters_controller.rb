class Api::V1::EmittersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emitter, only: %i[ show update destroy]

  def index
    @emitters = Emitter.all
    render json: @emitters, status: :ok
  end

  def create
    @emitter = Emitter.new(emitter_params)
    if @emitter.save
      render json: @emitter, status: :created
    else
      render json: @emitter.errors, status: :unprocessable_entity
    end
  end

  def update
    if @emitter.update(emitter_params)
      render json: @emitter, status: :ok
    else
      render json: @emitter.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @emitter.destroy
      render json: @emitter, status: :ok
    else
      render json: @emitter.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @emitter, status: :ok
  end

  private

  def set_emitter
    @emitter = Emitter.find(params[:id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_emitter")
    return render json: {code: @error.value, message: @error.description}, status: :unprocessable_entity
  end

  def emitter_params
    params.require(:emitter).permit(:name, :rfc, :status)
  end

end

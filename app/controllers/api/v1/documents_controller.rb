require 'zip'
class Api::V1::DocumentsController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :logs
  before_action :set_document, only: %i[ show update destroy]

  def index
    @documents = Document.all
    # render json: @documents, status: :ok
    response_method_controller( @documents.errors,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: :ok
  end

  def create
    file = params[:file].read
    filename = params[:file].original_filename
    File.open(File.join(Rails.root, 'public/invoices', filename), 'wb') { |f| f.write file }
    @document = Document.new(name: filename, status: 'pending')
    if @document.save
      ImportData.delay.build(@document)
      # render json: @document, status: :created
      response_method_controller( @document,true)
    else
      # render json: @document.errors, status: :unprocessable_entity
      response_method_controller( @document.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def update
    if @document.update(status: params[:status])
      # render json: @document, status: :ok
      response_method_controller( @document,true)
    else
      # render json: @document.errors, status: :unprocessable_entity
      response_method_controller( @document.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def destroy
    if @document.destroy
      # render json: @document, status: :ok
      response_method_controller( @document,true)
    else
      # render json: @document.errors, status: :unprocessable_entity
      response_method_controller( @document.errors,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def show
    # render json: @document, status: :ok
    response_method_controller( @document,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: :ok
  end

  private

  def set_document
    @document = Document.find(params[:id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_document")
    # return render json: {code: @error.value, message: @error.description}, status: :unprocessable_entity
    response_method_controller( @error.description,false)
    params[:code] = @error.value
    response = ResponsesEngine.build!(params)
    return render json: response, status: :unprocessable_entity
  end

end

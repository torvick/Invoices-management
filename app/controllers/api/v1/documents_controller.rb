require 'zip'
class Api::V1::DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: %i[ show update destroy]

  def index
    @documents = Document.all
    render json: @documents, status: :ok
  end

  def create
    file = params[:file].read
    filename = params[:file].original_filename
    File.open(File.join(Rails.root, 'public/invoices', filename), 'wb') { |f| f.write file }
    @document = Document.new(name: filename, status: 'pending')
    if @document.save
      ImportData.build(@document)
      render json: @document, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def update
    if @document.update(status: params[:status])
      render json: @document, status: :ok
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @document.destroy
      render json: @document, status: :ok
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @document, status: :ok
  end

  private

  def set_document
    @document = Document.find(params[:id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_document")
    return render json: {code: @error.value, message: @error.description}, status: :unprocessable_entity
  end

end

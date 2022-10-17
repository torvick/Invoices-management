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
    @document = Document.new(name: filename)
    if @document.save
      ImportData.delay.build(@document)
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

  private

  def process_zip_file(tmpfile_zip)
    Zip::File.open(tmpfile_zip.path) do |zipfile|

      # iterating through all the entries found in the zip file
      zipfile.each do |entry|
        if entry.file?
          puts "#{entry.name} is a file!"
          attach_file_to_model_obj(entry)

        elsif entry.directory?
          puts "#{entry.name} is a directory!"

        elsif entry.symlink?
          puts "#{entry.name} is a symlink!"
        end

      end
    end
  end

  def attach_file_to_model_obj(entry)
    # first we create a temp file from the file found in the zip archive
    # then attach the temp file to model obj

    Tempfile.open(["my-filename", ".zip"]) do |tmp|
      # this line creates the temp file
      entry.extract(tmp.path) { true }

      # attaching the temp image file to active record object
      Document.last.file(io: File.open(tmp.path), filename: "my-filename.zip")
    end
  end

end

class Api::V1::InvoicesController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :logs
  before_action :set_emitter, :if => :validate_services?
  before_action :set_invoice, only: %i[ show update destroy qr]

  def index
    @invoices = Invoice.all
    @invoices = @invoices.filter_by_status(params[:status]) if params[:status].present?
    @invoices = @invoices.filter_by_emitter(params[:emitter] ||= params[:emitter_id]) if (params[:emitter] ||= params[:emitter_id]).present?
    @invoices = @invoices.filter_by_receiver(params[:receiver]) if params[:receiver].present?
    @invoices = @invoices.filter_by_amount_range(params[:amount_lower], params[:amount_greater]) if params[:amount_lower].present? or params[:amount_greater].present?
    @invoices = @invoices.filter_by_emitted_at(params[:emitted_at]) if params[:emitted_at].present?
    # render json: {invoices: @invoices, total_invoices: @invoices.count, total_amount: @invoices.sum(:amount)}, status: :ok
    response_method_controller( {invoices: @invoices, total_invoices: @invoices.count, total_amount: @invoices.sum(:amount)},true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: :ok
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      # render json: @invoice, status: :created
      response_method_controller( @invoice,true)
    else
      # render json: @invoice.errors, status: :unprocessable_entity
      response_method_controller( @invoice,false)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def update
    if @invoice.update(invoice_params)
      # render json: @invoice, status: :ok
      response_method_controller( @invoice,true)
    else
      # render json: @invoice.errors, status: :unprocessable_entity
      response_method_controller( @invoice.errors,true)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def destroy
    if @invoice.destroy
      # render json: @invoice, status: :ok
      response_method_controller( @invoice,true)
    else
      # render json: @invoice.errors, status: :unprocessable_entity
      response_method_controller( @invoice.errors,true)
    end
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def show
    # render json: @invoice, status: :ok
    response_method_controller( @invoice,true)
    response = ResponsesEngine.build!(params)
    return render json: response, status: params[:code]
  end

  def qr
    qr = RQRCode::QRCode.new(@invoice.cfdi_digital_stamp)
    render json: qr.as_svg, status: :ok
  end

  private

  def validate_services?
     request.original_url.include?('emitters') and request.original_url.include?('invoices') and params[:emitter_id].present?
  end

  def set_emitter
    @emitter = Emitter.find(params[:emitter_id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_emitter")
    # return render json: {code: @error.value, message: @error.description}, status: :unprocessable_entity
    response_method_controller( @error.description,false)
    params[:code] = @error.value
    response = ResponsesEngine.build!(params)
    return render json: response, status: :unprocessable_entity
  end

  def set_invoice
    @invoice = Invoice.find(params[:id] ||= params[:invoice_id])
  rescue Exception => e
    @error = CodeError.find_by(name: "set_invoice")
    # return render json: {code: @error.value, message: @error.description}, status: :unprocessable_entity
    response_method_controller( @error.description,false)
    params[:code] = @error.value
    response = ResponsesEngine.build!(params)
    return render json: response, status: :unprocessable_entity
  end

  def invoice_params
    params.require(:invoice).permit(:invoice_uuid,:status,:amount,:currency,:emitted_at,:expires_at,:signed_at,:cfdi_digital_stamp,:user_id,:emitter_id)
  end

end

require 'zip'
class ImportData

  def self.build(*args)
    new(*args).build!
  end

  def initialize(args)
    @document = args
    @invoices = []
    @correct = []
    @incorrect = []
  end

  def build!
    @document.update(status: 1)
    Zip::File.open(Rails.root + "public/#{@document.name}") do |zip_file|
      zip_file.entries.each do |entry|
        @invoices << Hash.from_xml(zip_file.read(entry.name))
      rescue Exception => e
        puts e
      end
    end
    set_invoices
    @document.update(successful: @correct, failed: @incorrect, status: 2)
  end

  def set_invoices
    @invoices.each do |invoice|
      emitter = set_emitter(invoice['hash']['emitter'])
      receiver = set_receiver(invoice['hash']['receiver'])
      new_invoice = Invoice.new(
        invoice_uuid: invoice['hash']['invoice_uuid'],
        status: invoice['hash']['status'],
        amount: invoice['hash']['amount']['cents'],
        currency: invoice['hash']['amount']['currency'],
        emitted_at: invoice['hash']['emitted_at'],
        expires_at: invoice['hash']['expires_at'],
        signed_at: invoice['hash']['signed_at'],
        cfdi_digital_stamp: invoice['hash']['cfdi_digital_stamp'],
        user: receiver,
        emitter: emitter
      )
      if new_invoice.save
        @correct << invoice
      else
        @incorrect << {invoice: invoice, errors: new_invoice.errors}
      end
    end
  end

  def set_emitter(args)
    emitter = Emitter.find_by(rfc: args['rfc'])
    Emitter.create!(name: args['name'], rfc: args['rfc']) if emitter.nil?
  end

  def set_receiver(args)
    receiver = User.find_by(rfc: args['rfc'])
    User.create!(name: args['name'], rfc: args['rfc'], email: "#{args['name'].gsub(' ','').downcase}@mail.com") if receiver.nil?
  end

end

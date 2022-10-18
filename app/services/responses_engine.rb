class ResponsesEngine

  def self.build!(*args)
    new(*args).build
  end

  def initialize(args)
    @args = args
    @data = @args[:data]
  end

  def build
    return response_success if @data[:code] == 201
    response_error
  end

  def response_error
    {
      code:       (@args[:code] ||= 400),
      request_id: @args[:request_id],
      request_ip: @args[:request_ip],
      url:        @args[:get_host],
      status:     (@data[:status_id] ||= false),
      method:     @args[:method],
      service:    @args[:controller],
      errors:     (@data[:errors] ||= 'Invalid Token'),
      message:    (@data[:message] ||= 'Invalid Token')
    }
  end

  def response_success
    {
      code:       (@args[:code] ||= 200),
      request_id: @args[:request_id],
      request_ip: @args[:request_ip],
      url:        @args[:get_host],
      status:     true,
      method:     @args[:method],
      service:    @args[:controller],
      data:       @data[:data] ||= @data['data']
    }
  end

end

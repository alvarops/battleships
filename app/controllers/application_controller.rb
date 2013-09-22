class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :global_request_logging

  def global_request_logging
    logger.info "URL: #{request.url} IP: #{request.ip} PARAMS: #{request.params}"
    begin
      yield
    ensure
      #logger.info "response_status: #{response.status}"
    end
  end

  def render(options = nil, extra_options = {}, &block)
    options ||= {} # initialise to empty hash if no options specified
    options = options.merge(:callback => params['callback']) if options[:json] && params['callback']
    super(options, extra_options, &block)
  end

  def render_error(msg='Unknown Error')
    redirect_to controller: 'error', action: 'show', error: {error: msg}
  end
end

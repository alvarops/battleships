class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render(options = nil, extra_options = {}, &block)
    options ||= {} # initialise to empty hash if no options specified
    options = options.merge(:callback => params['callback']) if options[:json] && params['callback']
    super(options, extra_options, &block)
  end
end

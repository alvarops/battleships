module TokenFilter 
    extend ActiveSupport::Concern

    included do 
        around_action :authenticate, except: [ :new, :list ]
    end 

    protected

    def authenticate 
        token = params[:token]
        @current_player = Player.find_by_token(token)
        if @current_player then 
            yield
        else
            redirect_to '/error' #TODO (Currently 404 or 500 - General KABOOM)
        end 
    end 
end 
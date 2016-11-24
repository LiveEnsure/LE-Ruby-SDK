class ApplicationController < ActionController::Base
  	protect_from_forgery with: :exception


	def init
		puts "init"
		@url = request.url.split('/').last
		if ((defined? LIVE_ENSURE) && LIVE_ENSURE[:API_KEY] && LIVE_ENSURE[:API_PASSWORD] && LIVE_ENSURE[:AGENT_ID])			
			session[:api_key] = LIVE_ENSURE[:API_KEY]
			session[:api_password] = LIVE_ENSURE[:API_PASSWORD]
			session[:agent_id] = LIVE_ENSURE[:AGENT_ID]
			redirect_to :controller => 'authentication', :action => 'device'
		else
			redirect_to :controller => 'settings', :action => 'index' if @url != 'settings'
		end
	end

	def check_session
		puts "check_session"
		@url = request.url.split('/').last
		puts session[:api_key]
		if !(session[:api_key] && session[:api_key] && session[:agent_id])
		    puts "inside"			
			# redirect_to :controller => 'application',:action => 'init'
			init()
		else
			redirect_to :controller => 'authentication', :action => 'device' if @url == 'settings'
		end
  	end

  	def get_host
		@host = "https://app.liveensure.com/live-identity"
		if ((defined? LIVE_ENSURE) && LIVE_ENSURE[:API_HOST])
			@host = LIVE_ENSURE[:API_HOST]
		end
		return @host
	end

	def get_map_key
		@map_key = "NO_KEY"
		if((defined? LIVE_ENSURE) and LIVE_ENSURE[:GOOGLE_MAP_KEY])
			@map_key = LIVE_ENSURE[:GOOGLE_MAP_KEY]
		elsif session[:map_key]
			@map_key = session[:map_key]
		end
		
		return @map_key
	end

	def set_required_params
		@api_key = session[:api_key]
		@agent_id = session[:agent_id]
		@host = get_host()
		@host_url = @host + "/rest"
		@map_key = get_map_key()
		@version = VERSION
	end
end

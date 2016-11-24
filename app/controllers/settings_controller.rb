class SettingsController < ApplicationController
	before_action :check_session

	def create		
		session[:api_key] = params[:api_key]
		session[:api_password] = params[:api_password]
		session[:agent_id] = params[:agent_id]
		session[:agent_id] = params[:agent_id]
		if(params[:map_key])
			session[:map_key] = params[:map_key]
		end
		redirect_to :controller => 'authentication', :action => 'device'
	end
end

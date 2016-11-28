class AuthenticationController < ApplicationController
	require "httparty"

	before_action :check_session,:set_required_params,:create_liveensure_instance
	layout "base"

	def device
		# puts params[:api_key]
	end

	def knowledge
		# puts params[:api_key]
	end

	def location
		# puts params[:api_key]
	end

	def behaviour
		# puts params[:api_key]
	end

	def init_session
        result = @liveensure_api.init_session(params[:email])

		respond_to do |format|
			format.json { 
				render json: result
			}
		end
	end

	def add_prompt_challenge
		result = @liveensure_api.add_prompt_challenge(params[:question], params[:answer], params[:sessionToken].to_str)
        
		respond_to do |format|
			format.json { 
				render json: result
			}
		end
	end

	def add_touch_challenge
		result = @liveensure_api.add_touch_challenge(params[:orientation], params[:touches], params[:sessionToken].to_str)
        
		respond_to do |format|
			format.json { 
				render json: result
			}
		end
	end

	def add_location_challenge
		result = @liveensure_api.add_location_challenge(params[:lat], params[:lang], "10", params[:sessionToken].to_str)
        
		respond_to do |format|
			format.json { 
				render json: result
			}
		end
	end

	def get_qr_code
		result = @liveensure_api.get_auth_object('IMG', params[:sessionToken])

		respond_to do |format|
			format.json { 
				render json: { link: result }
			}
		end
	end

	def poll_status
		result = @liveensure_api.poll_status(params[:sessionToken].to_str)
		
		respond_to do |format|
			format.json { 
				render json: result
			}
		end
	end
end

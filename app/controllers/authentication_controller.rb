class AuthenticationController < ApplicationController
	require "httparty"

	before_action :check_session,:set_required_params
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
        @data = {
            apiVersion: "5",
            userId: params[:email],
            agentId: @agent_id,
            apiKey: @api_key
        }

		@result = HTTParty.put(@host_url + "/host/session",:body => @data.to_json, :headers => {'Content-Type' => 'application/json'})
		respond_to do |format|
			format.json { 
				render json: @result
			}
		end
	end

	def add_prompt_challenge
        @details = {question: params[:question],
                   answer: params[:answer], 
                   required: "true", 
                   maximumAttempts: "1"}

        @data = {sessionToken: params[:sessionToken].to_str, 
                challengeType: "PROMPT", 
                agentId: @agent_id, 
                challengeDetails: @details}



		@result = HTTParty.put(@host_url + "/host/challenge",:body => @data.to_json, :headers => {'Content-Type' => 'application/json'})
		puts @result
		respond_to do |format|
			format.json { 
				render json: @result
			}
		end
	end

	def add_touch_challenge
        @details = {orientation: params[:orientation],
                   touches: params[:touches],
                   regionCount: "6",
                   required: "true", 
                   maximumAttempts: "1"}

        @data = {sessionToken: params[:sessionToken].to_str, 
                challengeType: "HOST_BEHAVIOR", 
                agentId: @agent_id, 
                challengeDetails: @details}



		@result = HTTParty.put(@host_url + "/host/challenge",:body => @data.to_json, :headers => {'Content-Type' => 'application/json'})
		puts @result
		respond_to do |format|
			format.json { 
				render json: @result
			}
		end
	end

	def add_location_challenge
        @details = {latitude: params[:lat],
                   longitude: params[:lang],
                   radius: "10",  
                   required: "true", 
                   maximumAttempts: "1"}

        @data = {sessionToken: params[:sessionToken].to_str, 
                challengeType: "LAT_LONG", 
                agentId: @agent_id, 
                challengeDetails: @details}



		@result = HTTParty.put(@host_url + "/host/challenge",:body => @data.to_json, :headers => {'Content-Type' => 'application/json'})
		puts @result
		respond_to do |format|
			format.json { 
				render json: @result
			}
		end
	end

	def get_qr_code
		@session_token = params[:sessionToken]
		@type = 'IMG'

        @qurl = @host + "/QR?w=240&sessionToken=" + @session_token
        @furl = @host + "/launcher?sessionToken=" + @session_token
        @liurl = @host + "/launcher?sessionToken=" + @session_token + "&light=1"
        @lurl = "liveensure://?sessionToken=" + @session_token + "&status=" + @host + "/rest"

        if (@type == "IMG")
            @result = @qurl
        elsif (@type == "COMBO")
            @result = @furl
        elsif (@type == "LIGHT")
            @result = @liurl
        elsif (@type == "LINK")
            @result = @lurl
        else
            @result = "NOTOKEN"
		end
		respond_to do |format|
			format.json { 
				render json: { link: @result }
			}
		end
	end

	def poll_status
		@session_token = params[:sessionToken]

		@url = @host_url + "/host/session" + "/" + @session_token + "/" + @agent_id

		@result = HTTParty.get(@url)

		respond_to do |format|
			format.json { 
				render json: @result
			}
		end
	end
end

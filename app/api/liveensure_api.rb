class LiveensureApi
	def initialize(api_key, api_password, agent_id, host)
		@api_key = api_key
		@api_password = api_password
		@agent_id = agent_id
		@host_base = host
		@host_url = @host_base + '/rest'
	end
	

	def init_session(email)
        data = {
            apiVersion: "5",
            userId: email,
            agentId: @agent_id,
            apiKey: @api_key
        }

		return HTTParty.put(@host_url + "/host/session",:body => data.to_json, :headers => {'Content-Type' => 'application/json'})
	end

	def add_prompt_challenge(question, answer, session_token)
        details = {question: question,
                   answer: answer, 
                   required: "true", 
                   maximumAttempts: "1"}

        data = {sessionToken: session_token.to_str, 
                challengeType: "PROMPT", 
                agentId: @agent_id, 
                challengeDetails: details}



		return HTTParty.put(@host_url + "/host/challenge",:body => data.to_json, :headers => {'Content-Type' => 'application/json'})
	end

	def add_touch_challenge(orientation, touches, session_token)
        details = {orientation: orientation,
                   touches: touches,
                   regionCount: "6",
                   required: "true", 
                   maximumAttempts: "1"}

        data = {sessionToken: session_token.to_str, 
                challengeType: "HOST_BEHAVIOR", 
                agentId: @agent_id, 
                challengeDetails: details}

       	puts data

		return HTTParty.put(@host_url + "/host/challenge",:body => data.to_json, :headers => {'Content-Type' => 'application/json'})
		
	end

	def add_location_challenge(lat, lang, radius, session_token)
        details = {latitude: lat,
                   longitude: lang,
                   radius: radius,  
                   required: "true", 
                   maximumAttempts: "1"}

        data = {sessionToken: session_token.to_str, 
                challengeType: "LAT_LONG", 
                agentId: @agent_id, 
                challengeDetails: details}



		return HTTParty.put(@host_url + "/host/challenge",:body => data.to_json, :headers => {'Content-Type' => 'application/json'})
		
	end

	def get_auth_object(type, session_token)
		

        qurl = @host_base + "/QR?w=240&sessionToken=" + session_token
        furl = @host_base + "/launcher?sessionToken=" + session_token
        liurl = @host_base + "/launcher?sessionToken=" + session_token + "&light=1"
        lurl = "liveensure://?sessionToken=" + session_token + "&status=" + @host_base + "/rest"

        if (type == "IMG")
            result = qurl
        elsif (type == "COMBO")
            result = furl
        elsif (type == "LIGHT")
            result = liurl
        elsif (type == "LINK")
            result = lurl
        else
            result = "NOTOKEN"
		end

		return result
	end

	def poll_status(session_token)

		url = @host_url + "/host/session" + "/" + session_token + "/" + @agent_id

		return HTTParty.get(url)
	end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	root 'application#init'

  	resources :settings

  	match '/live/device',	to: 'authentication#device', via: 'get'
  	match '/live/knowledge',	to: 'authentication#knowledge', via: 'get'
  	match '/live/location',	to: 'authentication#location', via: 'get'
  	match '/live/behaviour',	to: 'authentication#behaviour', via: 'get'
  	match '/authentication/init_session', to: 'authentication#init_session', via: 'post'
  	match '/authentication/add_prompt_challenge', to: 'authentication#add_prompt_challenge', via: 'post'
  	match '/authentication/add_touch_challenge', to: 'authentication#add_touch_challenge', via: 'post'
  	match '/authentication/add_location_challenge', to: 'authentication#add_location_challenge', via: 'post'
  	match '/authentication/get_qr_code', to: 'authentication#get_qr_code', via: 'get'
  	match '/authentication/poll_status', to: 'authentication#poll_status', via: 'get'

end

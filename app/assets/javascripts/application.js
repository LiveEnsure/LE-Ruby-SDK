// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require_tree .
function makeInitSessionCall() {
	$("#qr-img").attr("src", "//s3.amazonaws.com/clickmeter.com/Web/static/small-loader.gif");
	appendToRequestBox("/host/session", "PUT")
	return $.post(urls.initSession, $("#email-form").serialize(), function(response) {
		console.log('dafdsfdsfdsfsd');
		console.log(response);
		appendToResponseBox("/host/session", "PUT", JSON.stringify(response, null, 4));
		
		return response;
	},'json').then(function(response){
		if(!response.sessionToken){
			alert(response.statusMessage);
			$("#qr-img").attr("src", "");
			return $.Deferred().reject(response).promise();
		}

		localStorage.setItem("sessionToken", response.sessionToken);
		return response;
	});
}

function getQRCode() {
	var url = "/QR?w=240&sessionToken=" + localStorage.getItem('sessionToken');
	appendToRequestBox(url, "GET")
	return $.get(urls.getCode, {sessionToken: localStorage.getItem('sessionToken')}, function(response) {
		console.log(response);
		if(typeof window.orientation == 'undefined'){
			$("#qr-img").attr("src", response.link);
		 }
		appendToResponseBox(url, "GET", "Image Url - " + response.link);
	},'json');
}

function addPromptChallenge() {
	$("#question-sessionToken").val(localStorage.getItem('sessionToken'));
	appendToRequestBox("/host/challenge", "PUT")
	return $.post(urls.addPromptChallenge, $("#question-form").serialize(), function(response) {
		appendToResponseBox("/host/challenge", "PUT", JSON.stringify(response, null, 4));
	},'json');	
}

function addBehaviourChallenge() {
	$("#b-sessionToken").val(localStorage.getItem('sessionToken'));
	$("#touches").val(touches.join(','));
	appendToRequestBox("/host/challenge", "PUT")
	return $.post(urls.addBehaviourChallenge, $("#behaviour-form").serialize(), function(response) {
		appendToResponseBox("/host/challenge", "PUT", JSON.stringify(response, null, 4));
	});	
}

function addLocationChallenge() {
	$("#location-sessionToken").val(localStorage.getItem('sessionToken'));
	appendToRequestBox("/host/challenge", "PUT")
	return $.post(urls.addLocationChallenge, $("#location-form").serialize(), function(response) {
		appendToResponseBox("/host/challenge", "PUT", JSON.stringify(response, null, 4));
	});	
}

function poll() {
	 if(typeof window.orientation !== 'undefined'){
		window.location = "liveensure://localhost/mobile?sessionToken="+localStorage.getItem('sessionToken')+"&status=https://app23.liveensure.com/live-identity/idr"; 	
	 }
	
	// retrun;
	var dfd = jQuery.Deferred();
	// $("#result-img").attr("src", "/static/liveensuredemo/img/failure.png");
	var url = "/host/session/" + localStorage.getItem("sessionToken") + "/" + agentId;
	var timeout = null;
	clear = setInterval(function(){
		appendToRequestBox(url, "GET")
		$.get(urls.pollStatus, {sessionToken: localStorage.getItem('sessionToken')}, function(response) {
			console.log(response);
			$("#polling-status-ip").val(response.sessionStatus);
			if (response.sessionStatus === "FAILED") {
				$("#qr-img").attr("src", "/assets/failure.png");
				clearInterval(clear);
				clearTimeout(timeout);

				dfd.resolve();
			} else if (response.sessionStatus === "SUCCESS") {
				$("#qr-img").attr("src", "/assets/tick-mark-img.png");
				clearInterval(clear);
	clearTimeout(timeout);
				dfd.resolve();
			} 
			appendToResponseBox(url, "GET", JSON.stringify(response, null, 4));
		},'json');	
	}, 5000);
	timeout = setTimeout(function() {
		console.log("clear timeout called");
		$("#qr-img").attr("src", "/assets/failure.png");
		clearInterval(clear);
		dfd.resolve();
	}, 1000 * 2 * 60);
	return dfd.promise();
}

function appendToRequestBox(r, method) {
	$("#request-box").val($("#request-box").val() + r + " - " + method + "\n");
}

function appendToResponseBox(r, method, resp) {
	$("#response-box").val($("#response-box").val() + r + " - " + method + "\n" + resp + "\n");
}


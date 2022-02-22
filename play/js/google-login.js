(function () {
	if (window.gapi) {
		gapi.load("auth2", function() {
			if (gapi.auth2) {
				gapi.auth2.init({
					client_id: "156495950351-9vvpk8ubf4udrdbrvsma33n01gqm484d.apps.googleusercontent.com"
				});
			}
		});
	}
})();

function onGoogleButtonClicked() {
	if (window.gapi && window.gapi.auth2) {
		gapi.auth2.getAuthInstance().signIn().then(function (user) {
			document.getElementById("AlternativaLoader").onGoogleTokenReceived(user.getAuthResponse().id_token);
		});
	}
}

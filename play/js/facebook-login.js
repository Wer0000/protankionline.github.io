window.fbAsyncInit = function () {
	FB.init({
		appId: '191694068262560',
		cookie: true,
		xfbml: true,
		version: 'v2.10'
	});
};

(function (d, s, id) {
	var js, fjs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) {
		return;
	}
	js = d.createElement(s);
	js.id = id;
	js.src = "https://connect.facebook.net/en_US/sdk.js";
	fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function loginViaFacebook() {
	FB.login(function (response) {
		if (response.status === 'connected') {
			authorizeLoginParams('facebook', {"access_token": response.authResponse.accessToken});
		}
	}, {scope: 'public_profile'});
}

function loginViaExternal(provider) {
	if (provider === 'facebook') {
		loginViaFacebook();
	}
}

function authorizeLoginParams(provider, params) {
	document.getElementById('AlternativaLoader').authorizeLoginParams(provider, params);
}

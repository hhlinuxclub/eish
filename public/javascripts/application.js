// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

SyntaxHighlighter.config.clipboardSwf = null;
SyntaxHighlighter.all();

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
	// markItUp initialization
	$("textarea.textile").markItUp(mySettings);

	// Password strength meter settings
	$("#user_password").passStrength({
		messageloc: 1,
		userid:	"#user_username"
	});

	// Login form hints
	$("#username.userLinks").focus(function() {
		if ($("#username.userLinks").val() == "username") {
			$("#username.userLinks").css("color", "#000");
			$("#username.userLinks").val("");
		};
	});

	$("#username.userLinks").blur(function() {
		if ($("#username.userLinks").val() == "") {
			$("#username.userLinks").css("color", "#ccc");
			$("#username.userLinks").val("username");
		};
	});

	$("#password.userLinks").focus(function() {
		if ($("#password").val() == "password") {
			$("input:password.userLinks").css("color", "#000");
			$("input:password.userLinks").val("");
		};
	});

	$("#password.userLinks").blur(function() {
		if ($("#password").val() == "") {
			$("input:password.userLinks").css("color", "#ccc");
			$("input:password.userLinks").val("password");
		};
	});

  /* Fancybox Default
     Galleries are created from found anchors who have the same "rel" tags
     Use the title attribute if you want to show a caption */
  $("a.fancybox").fancybox();
});

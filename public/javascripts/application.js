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

$(function() {
		$("#tabs").tabs({ cookie: { expires: 30 }, collapsible: true });
});

$(document).ready(function() {
	$("textarea.textile").markItUp(mySettings);
	
	$("#new_category").submitWithAjax();
	
	$("#bulk_check").click(function() {
		this.checked = !(this.checked == true);
		var ischecked = !(this.checked == true);
		$("input:checkbox").attr("checked", function() {
			this.checked = ischecked;
		});
	});
	
	$("#username").click(function() {
		var username = $("#username").val();
		
		if (username == "username") {
			$("#username").val("");
		};
	});
	
	$("#username").blur(function() {
		var username = $("#username").val();
		
		if (username == "") {
			$("#username").val("username");
		};
	});
	
	$("#password").click(function() {
		var username = $("#password").val();
		
		if (username == "password") {
			$("#password").val("");
		};
	});
	
	$("#password").blur(function() {
		var username = $("#password").val();
		
		if (username == "") {
			$("#password").val("password");
		};
	});

	$('.date').datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd.mm.yy',
		showButtonPanel: true
	});

	$("#user_password").passStrength({
		messageloc: 1,
		userid:	"#user_username"
	});

  /* Fancybox Default */ 
  /* Galleries are created from found anchors who have the same "rel" tags */
  /* Use the title attribute if you want to show a caption */
  $("a.fancybox").fancybox();
});

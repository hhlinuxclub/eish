// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
	$("#new_category").submitWithAjax();
	$("#loginBoxForm").submitWithAjax();
	$("#jsLogin").submitWithAjax();
	
	$("#accordion").accordion({
		collapsible: true,
		autoHeight: false
	});
	
	$("#accordion").accordion("activate", -1);
	
	$("#bulk_check").click(function() {
		this.checked = !(this.checked == true);
		var ischecked = !(this.checked == true);
		$("input:checkbox").attr("checked", function() {
			this.checked = ischecked;
		});
	});
	
	$("#preview").dialog({
		autoOpen: false,
		bgiframe: true,
		height: 400,
		width: 700,
		modal: true
	});
	
	$('.date').datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd.mm.yy',
		showButtonPanel: true,
	});
	
	$("a.login").attr({ 
		href: "#"
    });

	$("#loginDialog").dialog({
    	autoOpen: false,
		bgiframe: true,
		modal: true,
		title: "Login",
		resizable: false
	});
	
	$("#loginDialog input[type=text]").addClass("ui-widget-content ui-corner-all");
	$("#loginDialog input[type=password]").addClass("ui-widget-content ui-corner-all");
	
	$('.login').click(function() {
		$("#loginDialog").dialog('open')
	});
		
	$("#user_password").passStrength({
		messageloc: 1,
		userid:	"#user_username"
	});
})

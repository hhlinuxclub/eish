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
	// markItUp initialization
	$("textarea.textile").markItUp(mySettings);

	// Password strength meter settings
	$("#user_password").passStrength({
		messageloc: 1,
		userid:	"#user_username"
	});
	
	// Insert the datepicker
	$(".date").datepick({showOn: 'button', buttonImageOnly: true, buttonImage: '/images/tango/16px/events.png', dateFormat: 'dd.mm.yy', minDate: 0, firstDay: 1});

  /* Fancybox Default
     Galleries are created from found anchors who have the same "rel" tags
     Use the title attribute if you want to show a caption */
  $("a.fancybox").fancybox();
});

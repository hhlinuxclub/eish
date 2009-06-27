// Place your administration-specific JavaScript functions and classes here

// Set cookie for admin view tabs
$(function() {
		$("#tabs").tabs({ cookie: { expires: 30 }, collapsible: true });
});

$(document).ready(function() {
	$("#new_category").submitWithAjax();

	// Admin view bulk check
	$("#bulk_check").click(function() {
		this.checked = !(this.checked == true);
		var ischecked = !(this.checked == true);
		$("input:checkbox").attr("checked", function() {
			this.checked = ischecked;
		});
	});

	// jQuery UI datepicker settings
	$('.date').datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd.mm.yy',
		showButtonPanel: true
	});
});

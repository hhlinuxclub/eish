// Place your administration-specific JavaScript functions and classes here
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
  
	// Insert the datepicker
	$(".date").datepick({showOn: 'button', buttonImageOnly: true, buttonImage: '/images/tango/16px/events.png', dateFormat: 'dd.mm.yy', minDate: 0, firstDay: 1});
	
	//Image insertion pretification
	$(".textileCodeBlocks").remove();;
	$(".imageInsert").css("display","block");
	$("th:contains('Textile')").text("Insert Textile");
});

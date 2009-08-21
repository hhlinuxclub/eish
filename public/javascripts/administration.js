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

	// jQuery UI datepicker settings
	$(".date").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd.mm.yy',
		showButtonPanel: true
	});
	
	//Image insertion pretification
	$(".textileCodeBlocks").remove();;
	$(".imageInsert").css("display","block");
	$("th:contains('Textile')").text("Insert Textile");
});

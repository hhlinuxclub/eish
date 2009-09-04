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
	
	//Image insertion pretification
	$(".textileCodeBlocks").remove();;
	$(".imageInsert").css("display","block");
	$("th:contains('Textile')").text("Insert Textile");
});


(function($) {

jQuery.fn.initializeNotes = function(options) {

	options = $.extend($.fn.initializeNotes.defaults, options);
	
	return this.each(function() {
	
	var spacing = options.spacing, margin = options.margin;
	var grid_id = $(this).attr("data-grid");
	var top = $(this).attr("data-top");
	var left = $(this).attr("data-left");
	var z_index = $(this).attr("data-z");
	var parent_height = $(this).parent().height();
	var parent_width = $(this).parent().width();
	var my_height = $(this).addClass('rotate-3').height();
	var my_width = $(this).addClass('rotate-3').width();
	var max_top = parent_height-my_height-margin;//-parseInt(table_obj.css("borderTopWidth"), 10); 
	var max_left = parent_width-my_width-margin;//-parseInt(table_obj.css("borderLeftWidth"), 10);
	var line_height = my_height+spacing, col_spacing = my_width+spacing;
	var per_line = Math.floor(parent_width / col_spacing);
	var lines_per_table = Math.floor(parent_height / line_height);
	//alert(this.html());
	//alert("grid: "+grid_id+",pos: "+top+","+left+","+z_index);
	if (top==-1) {
		var line_number = Math.floor(grid_id / per_line);
		if (grid_id>=0 && line_number < lines_per_table) {
			//alert("note width: "+this.width()+", table width: "+table_obj.width()+", per line: "+per_line+", per table: "+lines_per_table);
			left = margin + (grid_id % per_line)*col_spacing;
			top  = margin + line_number*line_height;
			z_index = 0;
		}
		else {
			top  = Math.random()*max_top;
			left = Math.random()*max_left;
			z_index = 100;
		}
	}
	else {
		if (top>max_top) {
			top = max_top;
		}
		if (left>max_left) {
			left = max_left;
		}
	}
	return $(this).css("position","absolute")
	.addClass('rotate-3')
	.position({
		my: "left top",
		at: 'left+'+left+' top+'+top,   
		of: $(this).parent(),
		collision: "none"	
	})
	//.css("z-index", z_index)
	.draggable({
  		stack: ".draggable", 
  		containment: "parent",
	  	stop: function( event, ui ) {
  			var id = $(this).attr("data-note_id");
  			var top = ui.position.top;
  			var left = ui.position.left;
			var zindex = $( this ).css("z-index");
  			$('#id').val(id);
  			$('#top').val(top);
  			$('#left').val(left);
			$('#position_form').submit();
  		}
    });
 });
};

jQuery.fn.initializeNotes.defaults = {
	spacing: 30,
	margin: 5
};


jQuery.fn.initializeTable = function (options) {

	options = $.extend($.fn.initializeTable.defaults, options);

	var parent_width = this.parent().width();
	var parent_height = this.parent().height();	
	
	this.css("height", parent_height-options.delta_height);
	this.css("width", parent_width);//-this.css("borderWidthLeft"));
	
	this.position({
		my: "center bottom",
		at: "center bottom-"+this.parent().css("borderBottomWidth"),
		of: this.parent(),
		collision: "none"
	})	;
	
	this.css("position","relative");
	return this;
}	

jQuery.fn.initializeTable.defaults = {
	delta_height: 100
};


jQuery.fn.initializeDivideTable = function(options) {

	options = $.extend($.fn.initializeDivideTable.defaults, options);

	function setNewPosition(obj,helper_pos) {
		var left = helper_pos.left;
  		var parent_width = obj.parent().width();
  		
		if (left>parent_width)
			left -= parent_width;	
		else if (left < 0) 
			left += parent_width;
  		obj.position({
  			my: "left top",
  			at: 'left+'+left+' top+'+helper_pos.top,
  			of: obj.parent()
  		});
	}
	function submit_tag_data(obj) {
		$("#target_note_id").val(obj.attr("data-note_id"));
		$("#tag_form").submit();
	}

	var table = $(this).parent();
	var myType = $(this).attr("id");
	var otherType = $(this).siblings().first().attr("id");
	//alert(my_pos+','+at_pos);
	return this.each(function() {
  		return $(this)
	  	  .width(table.width()/2-2)
  		  .height(table.height())
  		  .position(
	      {
		    my: ""+options.position+" bottom",
			at: ""+options.position+" bottom",
			of: table,
			collision: "none"
	  	  })
  		  .droppable({
  			tolerance: "fit",
  			scope: ".source .target",
  			helper: "clone",
  			drop: function(event, ui) {
  				var obj = ui.draggable;
  				if (!obj.hasClass(myType)) {
	  				obj.removeClass(otherType).addClass(myType).appendTo("#"+myType);
	  				submit_tag_data(obj);
				}
				setNewPosition(obj,ui.helper.position());
			}
  		})
 	});
 }

jQuery.fn.initializeDivideTable.defaults = {
	position: 'left'
};


jQuery.fn.initializeDivideNotes = function(options) {

	options = $.extend($.fn.initializeDivideNotes.defaults, options);

	var parent = $(this).parent();
	
	var spacing = options.spacing, margin = options.margin;
	var parent_width = $(this).parent().width();
	var my_height = $(this).addClass('rotate-3').height();
	var my_width = $(this).addClass('rotate-3').width();
	var max_top = parent.height()-my_height-margin;
	var max_left = parent.width()-my_width-margin;
	var line_height = my_height+spacing, col_spacing = my_width+spacing;
	var per_line = Math.floor(parent.width() / col_spacing);
	var lines_per_table = Math.floor(parent.height() / line_height);
    var parent_id = parent.attr("id");

	var top, left;
	
	function getPosition(grid_id) {
	  var line_number = Math.floor(grid_id / per_line);
	  if (grid_id>=0 && line_number < lines_per_table) {
		left = margin + (grid_id % per_line)*col_spacing;
		top  = margin + line_number*line_height;
	  }
	  else {
	  	alert('random');
		top  = Math.random()*max_top;
		left = Math.random()*max_left;
	  }
	  if (top>max_top) {
		top = max_top;
	  }
	  if (left>max_left) {
		left = max_left;
	  }
	}


	var grid_id = 0;
	
	return this.each(function() {
	  var my_id = $(this).attr("data-note_id")
	  getPosition(grid_id++); 
	  return $(this)
	    .addClass(parent_id).addClass('rotate-3')
		.draggable({
		  	revert: "invalid",
  			stack: ".draggable", 
  			helper: "original",
  			scope: ".source .target",
  			start: function( event, ui ) {
		  		containment: "#table"
  			},
  			containment: "#table"
    	})
    	.position({
    		my: "left top",
    		at: "left+"+left+" top+"+top,
    		of: parent,
    		collision: "none"
    	})
 	  });
};

jQuery.fn.initializeDivideNotes.defaults = {
	spacing: 30,
	margin: 5
};
  
})(jQuery);



var last_polled_time = 0;

var poll_appspot = function(ba) {
    $.ajax({
	       url:'http://ietfvote.appspot.com/recent/',
	       success:function(s) {
		   js = JSON.parse(s);
		   
		   ba.update_plot(js.data);
		   setTimeout(function() {
				  poll_appspot(ba);
			      },
			      50000000);
		   }
	   }
	  );
};

var ba_rate = function(div, poll) {
    var div_ = div;  // The div to render on
    var poll_ = poll;
    var chart_ = undefined;
    var raters_ = {};
    var current_speaker_ = undefined;
    var this_second_ = 0;
    var idle_lifetime_ = 300000; // 5 minutes
    
    var compute_rating = function() {
	var to_delete = [];
	var total = 0;
	var count = 0;

	// Go through all the raters, aggregating those which aren't
	// idle and recording those which are
	_.each(raters_, function(rating, rater_name, list) {
		   // TODO(ekr@rtfm.com): Filter out when speaker changes
		   if ((this_second_ - rating.time) > idle_lifetime_) {
		       to_delete.push(rating.judge);
		   } else {
		       total += rating.rating;
		       count++;
		   }
	       });
	_.each(to_delete, function(x) {
		   delete raters_[x];
	       });
	
	rating = total/count;
	if (isNaN (rating)) {
	    console.log("Huh: rating is nan: " + total + "," + count);
	    rating = 2.5;
	}
	return rating;
    };

    
    var update_plot = function(ratings) {
	var serieses;

	serieses = compute_updates(ratings);
	console.log("Computed updates: " + serieses[0].length + " points " + 
		   serieses[1].length + " flags");
	
	_.each(serieses[0], function(x) {
		   chart_.series[0].addPoint(x);
	       });
	_.each(serieses[1], function(x) {
		   chart_.series[1].addPoint(x);
	       });

	return;	
    };

    var compute_updates = function(ratings) {
	var series = [];
	var flags = [];

	if (ratings.length == 0)
	    return [[],[]];

    	if (!this_second_) {
	    this_second_ = Math.floor(ratings[0].time/1000) * 1000;
	}

	_.each(ratings, function(rating) {
		   var r;
		   
		   // Compute ratings up to the next sample
		   while(this_second_ < rating.time) {

		       if (!_.isEmpty(raters_)) {
			   r = compute_rating();
			   var point = [this_second_, r];
//			   console.log("P: " + this_second_ + " " + r);
			   series.push([this_second_, r]);
		       }
		       else {
//			  chart_.series[0].addPoint([this_second_, 2.5]);
			   series.push([this_second_, r]);
		       }
		       this_second_ += 1000;
		   }
		   
		   if (current_speaker_ !== rating.speaker) {
//		       console.log("Speaker switched. New rating should be " + rating.rating);
		       raters_ = {};
/*
		       chart_.series[1].addPoint({
						     x:rating.time,
						     y:rating.rating,
						     title:rating.speaker,
						     text:rating.speaker
						 });/ */
		       flags.push({
				      x:rating.time,
				      y:rating.rating,
				      title:rating.speaker,
				      text:rating.speaker
				  });
		   }
		   
		   current_speaker_ = rating.speaker;
		   raters_[rating.judge] = rating;
	       });
	return [series, flags];
    };

    var start_plot = function(initial_data) {
	var serieses = compute_updates(initial_data);

	chart_ = new Highcharts.StockChart( {
						chart : {
						    renderTo: 'container',
						    events:{
							load: function() {
							    setTimeout(
							    poll_,
						            100);
							}
						    }
						},
						
						yAxis : {
						    min:0,
						    max:5,
						    title : {
							text : 'Speaker Rating'
							}
						},
						rangeSelector : {
						    buttons : [
							{
							    count: 5,
							    type: 'minute',
							    text: '5M'
							},
							{
							    count: 15,
							    type: 'minute',
							    text: '15M'
							},
							{
							    type: 'all',
							    text: 'All'
							},
						    ],
						    inputEnabled: false,
						    selected: 0
						},
						
						series : [ {
							       name : 'Rating',
							       data : serieses[0],
							       id :'ratingsseries'
							   },
							   {
							       type:'flags',
							       data:serieses[1],
							       onSeries:'ratingsseries'
							   }
							 ],
						
					    }
					  );
    };

    return {
	start_plot : start_plot,
	update_plot: update_plot,
	compute_updates: compute_updates	
    };
}

/*
     var simulator = new data_simulator();
     var initial_data = [];
     var t = (new Date().getTime() / 1000) * 1000 -100000;
     var ba;

     for (var i=0; i<100; i++) {
	initial_data.push([t, 2.5])
        t+=1000;			    
     }
	*/		

var startup = function(div) {
//    $("#rating-slider").slider();

    $.ajax({
	       url:'http://ietfvote.appspot.com/recent/',
	       success:function(s) {
		   js = JSON.parse(s);
		   
		   ready(div,js.data);
	       }
	   }
	  );
};

var ready = function(div, initial_data) {
    var series;
    var flags;
    
    var ba = new ba_rate(div, function() {poll_appspot(ba);});
    ba.start_plot(initial_data);
};

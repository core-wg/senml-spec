var last_polled_time = 0;
var me = "monkey-" + Math.floor(Math.random() * 10000000);
var prefix = 'http://' + window.location.host + ':' + window.location.port + '/';

var slider_change_cb = function(event, ui) {
    console.log("Slider changed. new value=" + ui.value);
    $.ajax({
               url:prefix + 'rate/' + me + '/' + ui.value + '/',
               success:function(x) { console.log("Rating recorded");}
           });
};

var poll_appspot = function(ba, last_time) {
    var url;

    if (!last_time) {
	url = prefix + 'recent/';
    }
    if (last_time) {
	url = prefix + 'since/' + last_time + '/';
    }
    console.log("Fetching url " + url);
    $.ajax({
	       url:url,
	       success:function(s) {
		   js = JSON.parse(s);
		   
                   console.log("Got " + js.data.length + " values");
//                   console.log(js.data);
		   last_time = js.now + 1;
		   ba.update_plot(js.data, js.now);
		   setTimeout(function() {
				  poll_appspot(ba, last_time);
			      },
			      1000);
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
                       console.log("Expiring out judge " + rating.judge);
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
	    rating = 3;
	}
	return rating;
    };

    
    var update_plot = function(ratings, now) {
	var serieses;

	serieses = compute_updates(ratings, now);
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

    var compute_updates = function(ratings, now) {
	var series = [];
	var flags = [];

    	if (!this_second_) {
	    this_second_ = Math.floor(ratings[0].time/1000) * 1000;
	}

	_.each(ratings, function(rating) {
		   var r;

		   if (rating.time > this_second_) {
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
		   }
	       });
        
        // Fill in values to now
        for (;this_second_ < now; this_second_ += 1000) {
            series.push([this_second_, compute_rating()]);
        }
	return [series, flags];
    };

    var start_plot = function(initial_data, now) {
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
						    max:6,
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

var startup = function(div) {
    $("#rating-slider").slider({
                                   min:1,
                                   max:5,
                                   value:3
                               });

    $.ajax({
	       url:prefix + 'recent/',
	       success:function(s) {
		   js = JSON.parse(s);
		   
		   ready(div,js.data, js.now);
	       }
	   }
	  );
};

var ready = function(div, initial_data, now) {
    var series;
    var flags;
    
    var ba = new ba_rate(div, function() {poll_appspot(ba, 0);});
    ba.start_plot(initial_data, now);
};


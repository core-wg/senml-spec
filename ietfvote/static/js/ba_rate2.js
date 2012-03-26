(function() {
	"use strict"; /*global _,$,Highcharts*/
	var last_polled_time = 0;

	var poll_appspot = function(ba) {
			$.ajax({
				url: 'http://ietfvote.appspot.com/recent/',
				success: function(s) {
					var js = JSON.parse(s);

					ba.update_plot(js.data);
					setTimeout(function() {
						poll_appspot(ba);
					}, 5000);
				}
			});
		};

	var ba_rate = function(div, initial_data, poll) {
			var div_ = div; // The div to render on
			var poll_ = poll;
			var chart_;
			var raters_ = {};
			var total_ = 0;
			var count_ = 0;
			var current_speaker_;
			var this_second_ = 0;
			var idle_lifetime_ = 300000; // 5 minutes
			var cumulative_rating = function(judge, rating) {
					if (raters_[judge]) {
						total_ -= raters_[judge];
					} else {
						count_++;
					}
					total_ += rating;
					raters_[judge] = rating;
					return total_ / count_;
				};

			var update_plot = function(ratings) {
					if (ratings.length === 0) {
						return;
					}

					_.each(ratings, function(rating) {
						var r;
						if (current_speaker_ !== rating.speaker) {
							// console.log("Speaker switched. New rating should be " + rating.rating);
							raters_ = {};
							total_ = 0;
							count_ = 0;
							chart_.series[1].addPoint({
								x: rating.time,
								y: rating.rating,
								title: rating.speaker,
								text: rating.speaker
							});
						}
						r = cumulative_rating(rating.judge, rating.rating)
						chart.series[0].addPoint([rating.time, r]);

						// Compute ratings up to the next sample
						while (this_second_ < rating.time) {
							if (!_.isEmpty(raters_)) {
								r = compute_rating();
								var point = [this_second_, r];
								// console.log("P: " + this_second_ + " " + r);
								chart_.series[0].addPoint([this_second_, r]);
							} else {
								chart_.series[0].addPoint([this_second_, 2.5]);
							}
							this_second_ += 1000;
						}

						current_speaker_ = rating.speaker;
						raters_[rating.judge] = rating;
					});
				};

			var get_next_data = function() {
					var d = poll_();
					//	update_plot(d);
				};

			var start_plot = function() {
					chart_ = new Highcharts.StockChart({
						chart: {
							renderTo: 'container',
							events: {
								load: function() {
									setTimeout(
									get_next_data, 100);
								}
							}
						},

						yAxis: {
							min: 0,
							max: 5
						},
						rangeSelector: {
							buttons: [{
								count: 5,
								type: 'minute',
								text: '5M'
							}, {
								count: 15,
								type: 'minute',
								text: '15M'
							}, {
								type: 'all',
								text: 'All'
							}, ],
							inputEnabled: false,
							selected: 0
						},

						series: [{
							name: 'Ratings',
							data: initial_data,
							id: 'ratingsseries'
						}, {
							type: 'flags',
							data: [],
							onSeries: 'ratingsseries'
						}],

					});
				};

			return {
				start_plot: start_plot,
				update_plot: update_plot
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

	var ready = function(div, initial_data) {
			var t = (new Date().getTime() / 1000) * 1000 - 100000;
			var ba = new ba_rate(div, initial_data, function() {
				poll_appspot(ba);
			});
			ba.start_plot();
		};

	var startup = function(div) {
			$.ajax({
				url: 'http://ietfvote.appspot.com/recent/',
				success: function(s) {
					var js = JSON.parse(s);
					ready(div, js.data);
				}
			});
		};
	window.startup = startup;

}());

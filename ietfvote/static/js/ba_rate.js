(function() {
	'use strict'; /*jshint browser:true*/
	/*global _,$,console,Highcharts*/
	var last_polled_time = 0;
	var me = "webmule" + Math.floor(Math.random() * 10000000);
	var prefix = 'http://' + window.location.host + ':' + window.location.port + '/';

	var slider_change_cb = function(event, ui) {
			$.ajax({
				url: prefix + 'rate/' + me + '/' + ui.value,
				success: function(x) {
					console.log("Rating recorded", ui.value);
				}
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
			$.ajax({
				url: url,
				success: function(s) {
					var js = JSON.parse(s);

					last_time = js.now + 1;
					ba.update_plot(js.data, js.now);
					setTimeout(function() {
						poll_appspot(ba, last_time);
					}, 2000);
				}
			});
		};

	var ba_rate = function(div, poll) {
			var div_ = div; // The div to render on
			var poll_ = poll;
			var chart_;
			var raters_ = {};
			var current_speaker_;
			var this_second_ = 0;
			var compute_rating = function() {
					var total = 0;
					var count = 0;
					var rating;

					// Go through all the raters, aggregating those which aren't
					// idle and recording those which are
					_.each(raters_, function(rating, rater_name, list) {
						// TODO(ekr@rtfm.com): Filter out when speaker changes
						if ( !! rating.rating) {
							total += rating.rating;
							count++;
						}
					});

					$('#users').text('' + count + ' voters');
					rating = total / count;
					if (isNaN(rating)) {
						rating = 3;
					}
					return rating;
				};

			var update_plot = function(ratings, now) {
					var serieses = compute_updates(ratings, now);

					_.each(serieses.points, function(x) {
						chart_.series[0].addPoint(x);
					});
					_.each(serieses.flags, function(x) {
						chart_.series[1].addPoint(x);
					});

					return;
				};

			var compute_updates = function(ratings, now) {
					var series = [];
					var flags = [];

					if (!this_second_) {
						this_second_ = Math.floor(ratings[0].time / 1000) * 1000;
					}

					_.each(ratings, function(rating) {
						var r;

						if (rating.time > this_second_) {
							// Compute ratings up to the next sample
							while (this_second_ < rating.time) {

								if (!_.isEmpty(raters_)) {
									r = compute_rating();
									var point = [this_second_, r];
								}
								series.push([this_second_, r]);
								this_second_ += 1000;
							}

							if (current_speaker_ !== rating.speaker) {
								raters_ = {};
								flags.push({
									x: rating.time,
									y: rating.rating,
									title: rating.speaker,
									text: rating.speaker
								});
							}

							current_speaker_ = rating.speaker;
							raters_[rating.judge] = rating;
						}
					});

					// Fill in values to now
					this_second_ = Math.floor(now / 1000) * 1000;
					series.push([this_second_, compute_rating()]);
					return { points: series, flags: flags };
				};

			var start_plot = function(initial_data, now) {
					var serieses = compute_updates(initial_data, now);

					chart_ = new Highcharts.StockChart({
						chart: {
							renderTo: 'container',
							events: {
								load: function() {
									setTimeout(poll_, 1000);
								}
							}
						},

						yAxis: {
							min: 0,
							max: 6,
							title: {
								text: 'Speaker Rating'
							}
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
							}],
							inputEnabled: false,
							selected: 0
						},

						series: [{
							name: 'Rating',
							data: serieses.points,
							id: 'ratingsseries'
						}, {
							type: 'flags',
							data: serieses.flags,
							onSeries: 'ratingsseries'
						}]
					});
				};

			return {
				start_plot: start_plot,
				update_plot: update_plot,
				compute_updates: compute_updates
			};
		};

	var ready = function(div, initial_data, now) {
			var series;
			var flags;

			var ba = new ba_rate(div, function() {
				poll_appspot(ba, 0);
			});
			ba.start_plot(initial_data, now);
		};
	var startup = function(div) {
			$("#rating-slider").slider({
				orientation: "vertical",
				min: 1,
				max: 5,
				step: 0.1,
				value: 3,
				stop: slider_change_cb
			});

			$.ajax({
				url: prefix + 'recent/',
				success: function(s) {
					var js = JSON.parse(s);

					ready(div, js.data, js.now);
				}
			});
		};
	window.startup = startup;
}());

var data_simulator = function() {
    // Actual rating for each speaker
    var speaker_ratings_ = {
	"alice":8,
	"bob":6,
	"charlie":4,
	"dave":2
    };
    var speakers_ = _.keys(speaker_ratings_);
    var num_raters_ = 100;
    var time_ = new Date().getTime();
    var current_speaker_ = "alice";
       
    var random_int = function(range) {
	return Math.floor(Math.random() * range);
    };
    var generate_next_second = function() {
	var results = [];
	time_ += 1000;

	// Chance of switching is 1% each second
	var should_switch = random_int(50) === 0;

	var i;

	if (should_switch) {
	    current_speaker_ = speakers_[random_int(speakers_.length)];
	    console.log("Switched to speaker " + current_speaker_);
	}

	for (i=0; i<num_raters_; i++) {
	    // Each rater has about a 1% chance of rating each second
	    if (random_int(100) === 0)  {
		results.push({
				 time:time_,
				 judge:i,
				 speaker:current_speaker_,
				 rating:generate_rating()
			     });				 
	    }
	}

	return results;
    };
    
    var generate_rating = function() {
	var variate = random_int(9);
	var offset;
	var rating = speaker_ratings_[current_speaker_];

	switch(variate) {
	    case 0:
	    rating += -2;
	    break;
	    
	    case 1:
	    case 2:
	    rating += -1;
	    break;

	    case 3:
	    case 4:
	    case 5:
	    rating += 0;
	    break;
	    
	    case 6:
	    case 7:
	    rating += 1;
	    break;

	    case 8:
	    rating += 2;
	}
	
	if (rating < 1) {
	    rating = 1;
	}
	if (rating > 10) {
	    rating = 10;
	}
		
	console.log("Simulated rating " + rating/2);
	return rating/2;
      };

    return {
	generate_next_second: generate_next_second
    };
};
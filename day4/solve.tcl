#!/usr/bin/env tclsh

proc recordevent {begin end guard asleep} {
	global sleeptime

	if {!$asleep} {
		# ignored, only track sleep time
		return 0
	}
#	puts "Guard #$guard asleep from [clock format $begin -format "%Y-%m-%d %H:%M"] - [clock format $end -format "%Y-%m-%d %H:%M"]"
	set minutes ""
	for {set i $begin} {$i < $end} {set i [clock add $i 1 minute]} {
		if {[clock format $i -format %H] ne "00"} {
			continue
		}
		set minute [clock format $i -format %M]
		lappend minutes $minute
		if {![dict exists $sleeptime $guard $minute]} {
			dict set sleeptime $guard $minute 0
		}
		set count [dict get $sleeptime $guard $minute]
		dict set sleeptime $guard $minute [incr count]
	}
#	puts "--> $minutes"
}

proc addevent {ts guardid asleep} {
	global lastevent

	if {[info exists lastevent]} {
		lassign $lastevent last_ts last_guardid last_asleep
		recordevent $last_ts $ts $last_guardid $last_asleep
	}
	set lastevent [list $ts $guardid $asleep]
}

set sleeptime ""
set data [string trim [exec cat input]]
foreach line [split $data \n] {
	#[1518-07-21 00:03] Guard #1249 begins shift
	#[1518-08-29 00:59] wakes up
	#[1518-02-09 00:30] falls asleep
	set line [join [lassign [split $line] date time]]
	set ts [clock scan "$date $time" -format {[%Y-%m-%d %H:%M]}]
	dict lappend events $ts $line
}
dict for {ts events} [lsort -stride 2 -index 0 -integer -increasing $events] {
	foreach event $events {
#		puts "[clock format $ts -format "%Y-%m-%d %H:%M"] $event"
		if {[regexp -- {^Guard #(\d+) begins shift} $event - id]} {
			set guard $id
			addevent $ts $guard 0
		} elseif {$event eq "wakes up"} {
			addevent $ts $guard 0
		} elseif {$event eq "falls asleep"} {
			addevent $ts $guard 1
		} else {
			error "Unknown event type: '$event'"
		}
	}
}
addevent $ts $guard 0
dict for {guard info} $sleeptime {
	set sleep 0
	dict for {minute count} $info {
		incr sleep $count
	}
	lappend total $guard $sleep
}
lassign [lsort -stride 2 -index 1 -integer -decreasing $total] guard sleep
puts "Most sleeptime: #$guard ($sleep minutes)"
lassign [lsort -stride 2 -index 1 -integer -decreasing [dict get $sleeptime $guard]] minute count
puts "Most asleep at minute 00:$minute ($count times)"
puts "Solution: [expr {[scan $minute %d]*$guard}]"

set max {0 - -}
dict for {guard info} $sleeptime {
	dict for {minute count} $info {
		if {$count > [lindex $max 0]} {
			set max [list $count $minute $guard]
		}
	}
}
lassign $max count minute guard
puts "Solution2: #$guard was asleep at minute 00:$minute $count times: [expr {$guard*$minute}]"

#!/usr/bin/env tclsh
set deps ""
set current ""

proc worker_tick {id} {
	global current

	if {[dict exists $current $id]} {
		lassign [dict get $current $id] step workleft
		if {!$workleft} {
			puts "Worker #$id finished step $step"
			done $step
			dict unset current $id
		} else {
			puts "Worker #$id working on $step"
			incr workleft -1
			dict set current $id [list $step $workleft]
		}
	}
	if {![dict exists $current $id]} {
		set step [getnext]
		if {$step eq ""} {
			puts "Worker #$id idle"
		} else {
			puts "Worker #$id started work on $step"
			dict set current $id [list $step [expr {60 + [scan $step %c] - [scan A %c] + 1 - 1}]]; # -1 because this tick counts]
		}
	}
}

foreach line [split [string trim [exec cat input]] \n] {
	lassign [split $line] - dep - - - - - result
	if {![dict exists $deps $dep]} {
		dict set deps $dep ""
	}
	dict set deps $result $dep 1
}

proc done {step} {
	global deps

	foreach result [dict keys $deps] {
		catch {dict unset deps $result $step}
	}
}

proc getnext {} {
	global deps

	set ready [dict filter $deps value {}]
	set step [lindex [lsort [dict keys $ready]] 0]
	dict unset deps $step
	return $step
}

set sec 0
while {[dict size $deps] || [dict size $current]} {
	puts "===== $sec"
	foreach id {1 2 3 4 5} {
		worker_tick $id
	}
	incr sec
}

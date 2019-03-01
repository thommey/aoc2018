#!/usr/bin/env tclsh
set deps ""

foreach line [split [string trim [exec cat input]] \n] {
	lassign [split $line] - dep - - - - - result
	if {![dict exists $deps $dep]} {
		dict set deps $dep ""
	}
	dict set deps $result $dep 1
}
while {[dict size $deps]} {
	set ready [dict filter $deps value {}]
	set step [lindex [lsort [dict keys $ready]] 0]
	puts -nonewline $step
	foreach result [dict keys $deps] {
		catch {dict unset deps $result $step}
	}
	dict unset deps $step
#	puts $deps
}
puts ""

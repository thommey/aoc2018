#!/usr/bin/env tclsh
set min_x 1000
set min_y 1000
set max_x -1
set max_y -1
foreach line [string trim [split [exec cat input] \n]] {
	regexp {position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>} $line - x y vx vy
	lappend points [dict create x $x y $y vx $vx vy $vy]
	set min_x [expr {min($min_x,$x)}]
	set min_y [expr {min($min_y,$y)}]
	set max_x [expr {max($max_x,$x)}]
	set max_y [expr {max($max_y,$y)}]
}

proc find {x y} {
	global points

	foreach p $points {
		if {[dict get $p x] == $x && [dict get $p y] == $y} {
			return 1
		}
	}
	return 0
}

proc tick {} {
	global points min_x min_y max_x max_y

	set min_x [set min_y [set max_x [set max_y 0]]]
	set points [lmap p $points {
		dict set p x [expr {[dict get $p x]+[dict get $p vx]}]
		dict set p y [expr {[dict get $p y]+[dict get $p vy]}]
		set min_x [expr {min($min_x,[dict get $p x])}]
		set min_y [expr {min($min_y,[dict get $p y])}]
		set max_x [expr {max($max_x,[dict get $p x])}]
		set max_y [expr {max($max_y,[dict get $p y])}]
		return -level 0 $p
	}][set points ""]
}

set ticks [lindex $argv 0]
while {$ticks} {
#	puts "[expr {[lindex $argv 0]-$ticks}] $min_x-$max_x/$min_y-$max_y"
#	puts [lindex $points 93]
	tick
	incr ticks -1
}
for {set x $min_x} {$x <= $max_x} {incr x} {
	for {set y $min_y} {$y <= $max_y} {incr y} {
		puts -nonewline [expr {[find $x $y] ? "#" : "."}]
	}
	puts ""
}

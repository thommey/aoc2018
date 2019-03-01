#!/usr/bin/env tclsh

array set fabric ""
foreach {id @ pos size} [exec cat input] {
	set id [string range $id 1 end]
	dict set ok $id 1
	set pos [string range $pos 0 end-1]
	lassign [split $pos ,] x y
	lassign [split $size x] size_x size_y
	for {set i $x} {$i < $x + $size_x} {incr i} {
		for {set j $y} {$j < $y + $size_y} {incr j} {
			if {[info exists fabric($i,$j)]} {
				dict set ok $id 0
				if {$fabric($i,$j) ne "X"} {
					dict set ok $fabric($i,$j) 0
				}
				set fabric($i,$j) X
			} else {
				set fabric($i,$j) $id
			}
		}
	}
}
set overlap 0
foreach {pos value} [array get fabric] {
	if {$value eq "X"} {
		incr overlap
	}
}
puts "overlapping squares: $overlap"
puts "not overlapping ids: [dict keys [dict filter $ok value 1]]"

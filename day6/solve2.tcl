#!/usr/bin/env tclsh
set id 1
set min_x 100000
set min_y 100000
set max_x -1
set max_y -1
set points ""
set thresh 10000
foreach {y x} [string trim [exec cat input]] {
	set y [string range $y 0 end-1]
	dict set points [list $x $y] $id
	if {$x < $min_x} { set min_x $x }
	if {$y < $min_y} { set min_y $y }
	if {$x > $max_x} { set max_x $x }
	if {$y > $max_y} { set max_y $y }
	incr id
}
puts "Grid: $min_x,$min_y -> $max_x,$max_y"
proc dist {x y x2 y2} {
	return [expr {abs($x2-$x)+abs($y2-$y)}]
}
proc closest {x y} {
	set sum 0
	dict for {point id} $::points {
		set dist [dist $x $y {*}$point]
#		puts "eval closest: $x,$y dist to $point = $dist"
#		puts "$x,$y += ($x,$y)/($point) = $dist"
		incr sum $dist
		if {$sum >= $::thresh} {
			break
		}
	}
#	puts "=== $sum"
	return $sum
}

incr min_y -10
incr min_x -10
incr max_x 10
incr max_y 10
set sum 0
for {set x $min_x} {$x <= $max_x} {incr x} {
	for {set y $min_y} {$y <= $max_y} {incr y} {
		set dist [closest $x $y]
		if {$dist < $::thresh} {
			puts -nonewline "#"
			incr sum
		} else {
			puts -nonewline "."
		}
	}
	puts ""
}
puts $sum

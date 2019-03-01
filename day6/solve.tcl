#!/usr/bin/env tclsh
set id 1
set min_x 100000
set min_y 100000
set max_x -1
set max_y -1
set points ""
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
	set min [list 100000 -]
	dict for {point id} $::points {
		set dist [dist $x $y {*}$point]
#		puts "eval closest: $x,$y dist to $point = $dist"
		if {$dist < [lindex $min 0]} {
			set min [list $dist $id]
		} elseif {$dist == [lindex $min 0]} {
			set min [list $dist .]
		}
	}
	return [lindex $min 1]
}
for {set x $min_x} {$x <= $max_x} {incr x} {
	for {set y $min_y} {$y <= $max_y} {incr y} {
		dict set grid [list $x $y] [closest $x $y]
#		puts "$x,$y = [dict get $grid [list $x $y]]"
		puts -nonewline "[dict get $grid [list $x $y]]"
	}
	puts ""
}
incr min_y -100
incr min_x -100
incr max_x 100
incr max_y 100
set count ""
set ids [dict values $points]
dict for {coord id} $grid {
	if {$id eq "."} { continue }
	lassign $coord x y
#	puts "$x,$y => $id"
	if {![dict exists $count $id]} { dict set count $id 0 }
	if {[dict get $count $id] == -1} { continue }
	if {$x == $min_x || $y == $min_y || $x == $max_x || $y == $max_y} {
		dict set count $id -1
	}
	dict set count $id [expr {[dict get $count $id] +1}]
}
lassign [lsort -stride 2 -index 1 -integer -decreasing $count] id size
puts "Largest: #$id (size $size)"

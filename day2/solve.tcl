#!/usr/bin/env tclsh

set total ""
foreach line [exec cat input] {
	set line [lsort [split $line ""]]
	set this ""
	foreach l $line {
		dict incr this $l
	}
	set reverse ""
	foreach {a b} $this {
		lappend reverse $b $a
	}
	dict for {count letter} $reverse {
		dict incr total $count
	}
}
puts [expr {[dict get $total 2]*[dict get $total 3]}]

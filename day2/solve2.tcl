#!/usr/bin/env tclsh

set generated ""
foreach word [exec cat input] {
	for {set i 0} {$i < [string length $word]} {incr i} {
		set placeholder [string replace $word $i $i ?]
		if {[dict exists $generated $placeholder]} {
			puts "[dict get $generated $placeholder] => [string replace $word $i $i ""]"
			exit 0
		}
		dict set generated $placeholder 1
	}
}

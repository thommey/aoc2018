#!/usr/bin/env tclsh

set nums [exec cat input]

proc parsenode {numVar} {
	upvar 1 $numVar nums

	set nums [lassign $nums numchildren nummetadata]
	set children ""
	while {$numchildren} {
		lappend children [parsenode nums]
		incr numchildren -1
	}
	set metadata ""
	while {$nummetadata} {
		set nums [lassign $nums m]
		lappend metadata $m
		incr nummetadata -1
	}
	return [dict create children $children metadata $metadata]
}

proc sumnodes {nodes} {
	set sum 0
	if {![dict size $nodes]} {
		return $sum
	}
	dict with nodes {
		if {[llength $children]} {
			foreach m $metadata {
				incr sum [sumnodes [lindex $children $m-1]]
			}
		} elseif {[llength $metadata]} {
			set sum [tcl::mathop::+ {*}$metadata]
		}
	}
	return $sum
}
set nodes [parsenode nums] 
puts [sumnodes $nodes]

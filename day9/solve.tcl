proc K {x y} { set x }
proc addmarble {player i} {
	global data scores

	if {![dict exists $data currentidx] && !$i} {
		dict set data marbles {0}
		dict set data currentidx 0
	} elseif {$i % 23 == 0} {
		set score $i
		set removeidx [expr {([dict get $data currentidx] - 7)%[llength [dict get $data marbles]]}]
		set removed [lindex [dict get $data marbles] $removeidx]
		dict with data {
			set marbles [lreplace $marbles[set marbles {}] $removeidx $removeidx]
		}
		incr score $removed
		dict set data currentidx [expr {$removeidx == [llength [dict get $data marbles]] ? 0 : $removeidx}]
		dict incr scores $player $score
	} else {
		dict with data {
			set currentidx [expr {($currentidx + 1) % [llength $marbles]}]
			incr currentidx
			set marbles [linsert $marbles[set marbles {}] $currentidx $i]
		}
	}
}

set data {marbles 0 currentidx 0}
set player 0
lassign $argv players marbles
for {set m 1} {$m <= $marbles} {incr m} {
	incr player
	addmarble $player $m
#	puts "\[$player] \[marble $m\] $data"
	set player [expr {$player%$players}]
}
set scores [lsort -stride 2 -index 1 -integer -decreasing $scores]
lassign $scores player score
puts "Winner: Player #$player Score $score"

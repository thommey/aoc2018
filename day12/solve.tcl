set initial {###....#..#..#......####.#..##..#..###......##.##..#...#.##.###.##.###.....#.###..#.#.##.#..#.#}
#set initial {#..#.#..##......###...###}

foreach {a - b} [string trim [exec cat input]] {
	set transform($a) $b
}

set rounds 20

set state $initial
puts "0 $state"
for {set i 0} {$i < $rounds} {incr i} {
	set state "....$state...."
	set new ""
	for {set s 2} {$s < [string length $state] - 2} {incr s} {
		set seq [string range $state $s-2 $s+2]
#		if {![info exists transform($seq)]} {
#			set transform($seq) .
#		}
		append new $transform($seq)
	}
	set state $new
	puts "[expr {$i+1}] $state"
}
set sum 0
for {set i [expr {(-2)*$rounds}]; set s 0} {$s < [string length $state]} {incr s; incr i} {
	if {[string index $state $s] eq "#"} {
		incr sum $i
	}
}
puts $sum

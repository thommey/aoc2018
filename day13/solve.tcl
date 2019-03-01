set lines [split [string trim [exec cat input]] \n]
foreach line $lines {
	lappend lengths [string length $line]
}
set maxy 0
set maxx 0
for {set y 0} {$y < [llength $lines]} {incr y} {
	if {$y > $maxy} {set maxy $y}
	set line [lindex $lines $y]
	for {set x 0} {$x < [string length $line]} {incr x} {
		if {$x > $maxx} {set maxx $x}
		set c [string index $line $x]
		if {$c in {- | \\ / +}} {
			dict set map $x $y track $c
		} elseif {$c in {< >}} {
			dict set map $x $y track -
		} elseif {$c in {v ^}} {
			dict set map $x $y track |
		}
		if {$c in {< > v ^}} {
			dict set map $x $y cart direction $c
			dict set map $x $y cart nextturn left
		}
	}
}

proc step {} {
	global map

	dict for {x lineData} $map {
		dict for {y cellData} $lineData {
			if {![dict exists $cellData cart]} {
				continue
			}
			set direction [dict get $cellData cart direction]
			switch -exact -- $direction {
				">" { set dst [list [expr {$x+1}] $y] }
				"<" { set dst [list [expr {$x-1}] $y] }
				"v" { set dst [list $x [expr {$y+1}]] }
				"^" { set dst [list $x [expr {$y-1}]] }
				default { error "invalid direction: $direction" }
			}
			puts "Moving ($x,$y) $direction to ([join $dst ,])"
			if {[dict exists $map {*}$dst cart]} {
				puts "Crash on: $dst"
				exit 0
			}
			set nextturn [dict get $cellData cart nextturn]
			switch -exact -- $direction {
				">" {
					switch -exact -- [dict get $map {*}$dst track] {
						"-" {} "|" { error "Invalid track direction" } "\\" { set direction "v" } "/" { set direction "^" }
						"+" { set direction [dict get {left ^ straight > right v} $nextturn]; set nextturn [dict get {left straight straight right right left} $nextturn] }
						default { error "Unknown track direction" }
					}
				}
				"<" {
					switch -exact -- [dict get $map {*}$dst track] {
						"-" {} "|" { error "Invalid track direction" } "\\" { set direction "^" } "/" { set direction "v" }
						"+" { set direction [dict get {left v straight < right ^} $nextturn]; set nextturn [dict get {left straight straight right right left} $nextturn] }
						default { error "Unknown track direction" }
					}
				}
				"v" {
					switch -exact -- [dict get $map {*}$dst track] {
						"|" {} "-" { error "Invalid track direction" } "\\" { set direction ">" } "/" { set direction "<" }
						"+" { set direction [dict get {left > straight v right <} $nextturn]; set nextturn [dict get {left straight straight right right left} $nextturn] }
						default { error "Unknown track direction" }
					}
				}
				"^" {
					switch -exact -- [dict get $map {*}$dst track] {
						"|" {} "-" { error "Invalid track direction" } "\\" { set direction "<" } "/" { set direction ">" }
						"+" { set direction [dict get {left < straight ^ right >} $nextturn]; set nextturn [dict get {left straight straight right right left} $nextturn] }
						default { error "Unknown track direction" }
					}
				}
				default { error "invalid direction: $direction" }
			}
			dict set map {*}$dst cart direction $direction
			dict set map {*}$dst cart nextturn $nextturn
			dict unset map $x $y cart
		}
	}
}
set step 0
while 1 {
#	for {set y 0} {$y <= $maxy} {incr y} {
#		for {set x 0} {$x <= $maxx} {incr x} {
#			puts -nonewline [expr {![dict exists $map $x $y] ? " " : ([dict exists $map $x $y cart] ? [dict get $map $x $y cart direction] : [dict get $map $x $y track])}]
#		}
#		puts ""
#	}
#	after 500
	puts "Step [incr step]"
	step
}

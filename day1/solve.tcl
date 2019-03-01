set data [exec cat input]
set sum 0
set seen ""
set i 0
while {1} {
	set d [lindex $data [expr {$i % [llength $data]}]]
	set sum [expr {$sum+($d)}]
	if {[dict exists $seen $sum]} {
		puts $sum
		break
	}
	dict set seen $sum 1
	incr i
}

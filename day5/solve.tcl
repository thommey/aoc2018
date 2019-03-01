set word [string trim [exec cat input]]
for {set i 0} {$i < [string length $word]} {incr i} {
	set l [string index $word $i]
	set ln [string index $word $i+1]
	if {[string is upper $l] && [string tolower $l] eq $ln || [string is lower $l] && [string toupper $l] eq $ln} {
		set word [string replace $word $i $i+1]
		incr i -2
	}
}
puts "Solution: [string length $word]"
set score ""
set input $word
foreach letter {a b c d e f g h i j k l m n o p q r s t u v w x y z} {
	set word [string map [list $letter "" [string toupper $letter] ""] $input]
	for {set i 0} {$i < [string length $word]} {incr i} {
		set l [string index $word $i]
		set ln [string index $word $i+1]
		if {[string is upper $l] && [string tolower $l] eq $ln || [string is lower $l] && [string toupper $l] eq $ln} {
			set word [string replace $word $i $i+1]
			incr i -2
		}
	}
	dict set score $letter [string length $word]
}
puts "Solution2: [lindex [lsort -stride 2 -integer -increasing -index 1 $score] 1]"

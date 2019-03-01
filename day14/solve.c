#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <stdlib.h>

#define RECIPE_MAX 1024*1024*2
int8_t recipes[RECIPE_MAX];

int main(int argc, char **argv) {
	size_t elf1, elf2, next;
	size_t limit = atoi(argv[1]);

	elf1 = 0;
	elf2 = 1;
	recipes[elf1] = 3;
	recipes[elf2] = 7;
	next = 2;
	while (1) {
		/* combine recipes */
		int8_t combination = recipes[elf1] + recipes[elf2];
		if (combination >= 10) {
			recipes[next++] = combination / 10;
		}
		recipes[next++] = combination % 10;
		if (next >= limit + 10) {
			printf("Result: ");
			for (int i = 0; i < 10; i++) {
				printf("%" PRId8, recipes[limit + i]);
			}
			printf("\n");
			break;
		}
		/* move on */
		elf1 = (elf1 + recipes[elf1] + 1) % next;
		elf2 = (elf2 + recipes[elf2] + 1) % next;
#ifdef DEBUG
		printf("Recipes: ");
		for (size_t i = 0; i < next; i++) {
			if (elf1 == i) {
				printf("*");
			} else if (elf2 == i) {
				printf("+");
			}
			printf("%" PRId8 " ", recipes[i]);
		}
		printf("\n");
#endif
	}
	return 0;
}

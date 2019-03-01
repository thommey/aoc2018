#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <stdlib.h>

#define RECIPE_MAX 1024*1024*1024
int8_t recipes[RECIPE_MAX];

int main(int argc, char **argv) {
	size_t elf1, elf2, next;

	elf1 = 0;
	elf2 = 1;
	recipes[elf1] = 3;
	recipes[elf2] = 7;
	next = 2;
	int state = 0;
	while (1) {
		/* combine recipes */
		int8_t combination = recipes[elf1] + recipes[elf2];
		if (combination >= 10) {
			recipes[next++] = combination / 10;
			if (state == 0 && combination / 10 == 8) {
				state++;
			} else if (state == 1 && combination / 10 == 4) {
				state++;
			} else if (state == 2 && combination / 10 == 6) {
				state++;
			} else if (state == 3 && combination / 10 == 6) {
				state++;
			} else if (state == 4 && combination / 10 == 0) {
				state++;
			} else if (state == 5 && combination / 10 == 1) {
				state++;
			} else {
				state = 0;
			}
		}
		if (state == 6) {
			printf("After %zd recipes\n", next - 6);
#ifdef DEBUG
			printf("Recipes: ");
			for (size_t i = 0; i < next; i++) {
				printf("%" PRId8 "", recipes[i]);
			}
			printf("\n");
#endif
			break;
		}
		recipes[next++] = combination % 10;
		if (state == 0 && combination % 10 == 8) {
			state++;
		} else if (state == 1 && combination % 10 == 4) {
			state++;
		} else if (state == 2 && combination % 10 == 6) {
			state++;
		} else if (state == 3 && combination % 10 == 6) {
			state++;
		} else if (state == 4 && combination % 10 == 0) {
			state++;
		} else if (state == 5 && combination % 10 == 1) {
			state++;
		} else {
			state = 0;
		}
		if (state == 6) {
			printf("After %zd recipes\n", next - 6);
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

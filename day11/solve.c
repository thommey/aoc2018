#include <stdio.h>
#include <limits.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>

int64_t x[300][300];
int64_t SERIAL;

static inline int64_t getscore(int i, int j) {
	if (x[i][j] == LONG_MIN) {
		x[i][j] = ((((i+11)*(j+1)+SERIAL)*(i+11)/100)%10)-5;
	}
	return x[i][j];
}

static inline void resetscore(void) {
	for (int i = 0; i < 300; i++) {
		for (int j = 0; j < 300; j++) {
			x[i][j] = LONG_MIN;
		}
	}
}

int main(int argc, char **argv) {
	int debug_x = -1, debug_y = -1;
	resetscore();
	struct {
		int64_t score;
		int x, y;
	} result = {0, -1, -1};
	SERIAL = atoi(argv[1]);
	if (argc >= 4) {
		debug_x = atoi(argv[2]);
		debug_y = atoi(argv[3]);
	}
	for (int i = 0; i < 298; i++) {
		for (int j = 0; j < 298; j++) {
			int64_t score = getscore(i, j) + getscore(i + 1, j) + getscore(i + 2, j) +
					getscore(i, j + 1) + getscore(i + 1, j + 1) + getscore(i + 2, j + 1) +
					getscore(i, j + 2) + getscore(i + 1, j + 2) + getscore(i + 2, j + 2);
			if (i == debug_x - 1 && j == debug_y - 1) {
				printf("Score at (%d,%d) = %" PRId64 "\n", i+1, j+1, getscore(i, j));
			}
			if (score > result.score) {
				result.score = score;
				result.x = i;
				result.y = j;
			}
		}
	}
	printf("Max score: %" PRId64 " @ (%d,%d)\n", result.score, result.x+1, result.y+1);
}

#include <stdio.h>
#include <limits.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>

#define MIN(x, y) ((x) < (y) ? (x) : (y))

int64_t x[300][300];
int64_t SERIAL;

static void resetscore(int64_t SERIAL) {
	for (int i = 0; i < 300; i++) {
		for (int j = 0; j < 300; j++) {
			x[i][j] = ((((i+11)*(j+1)+SERIAL)*(i+11)/100)%10)-5;
		}
	}
}

int main(int argc, char **argv) {
	struct {
		int64_t score;
		int x, y, size;
	} result = {0, -1, -1};
	resetscore(atoi(argv[1]));
	for (int i = 0; i < 299; i++) {
	//	printf("%d\n", i);
		for (int j = 0; j < 299; j++) {
			int64_t score = 0;
#if 0
			for (int size = 1; size <= MIN(300-i, 300-j); size++) {
#endif
			for (int size = 1; size <= MIN(300-i, 300-j); size++) {
				for (int a = 0; a < size; a++) {
					score += x[i+a][j+size-1];
					score += x[i+size-1][j+a];
				}
				score -= x[i+size-1][j+size-1];
				if (score > result.score) {
					result.score = score;
					result.x = i;
					result.y = j;
					result.size = size;
				}
			}	
		}
	}
	printf("Max score: %" PRId64 " @ (%d,%d) size %d\n", result.score, result.x+1, result.y+1, result.size);
}

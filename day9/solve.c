#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <stdlib.h>

uint64_t *scores;
struct marble {
	uint32_t value;
	struct marble *prev, *next;
} *current;

uint32_t addmarble(uint32_t marble) {
	if (marble % 23 == 0) {
		uint32_t score = marble;

		current = current->prev->prev->prev->prev->prev->prev;
		score += current->prev->value;
		current->prev->prev->next = current;
		free(current->prev);
		current->prev = current->prev->prev;
		return score;
	} else {
		struct marble *m = malloc(sizeof *m);

		m->value = marble;
		m->next = current->next->next;
		m->prev = current->next;
		current->next->next->prev = m;
		current->next->next = m;
		current = m;

		return 0;
	}
}

#ifdef DEBUG
void printmarbles(struct marble *initial) {
	struct marble *tmp = initial;
	do {
		printf("%" PRIu32 " ", tmp->value);
		tmp = tmp->next;
	} while (tmp != initial);
}
#endif

int main(int argc, char **argv) {
	long players = strtol(argv[1], NULL, 10);
	uint32_t marbles = (uint32_t)strtol(argv[2], NULL, 10);

	scores = malloc(players * sizeof *scores);
	memset(scores, 0, players * sizeof *scores);

	current = malloc(sizeof *current);
#ifdef DEBUG
	struct marble *initial = current;
#endif
	current->value = 0;
	current->prev = current->next = current;

	size_t bestplayer;
	uint32_t maxscore = 0;

	for (uint32_t m = 1; m <= marbles; m++) {
#ifdef DEBUG
		printf("[%" PRIu32 "] [P %ld] ", m, (m - 1) % players);
		printmarbles(initial);
		printf("\n");
#endif
		uint32_t score = addmarble(m);
		if (score) {
			size_t player = (m - 1) % players;
			scores[player] += score;
			if (scores[player] > maxscore) {
				maxscore = scores[player];
				bestplayer = player;
			}
		}
	}
	printf("Winner: Player #%zd Score %" PRIu32 "\n", bestplayer + 1, maxscore);
	return 0;
}

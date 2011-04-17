#include <stdio.h>
#include <stdlib.h>

#define NUM_LETTERS 26

typedef struct conversion {
	char to;
	int timesUsed;
} conversion;
conversion *conversions[NUM_LETTERS];

void allocConversions() {
	int i;
	for (i = 0; i < NUM_LETTERS; i++) {
		conversions[i] = (conversion *) malloc(sizeof(conversion));
	}
}
void resetConversions() {
	int i;
	for (i = 0; i < NUM_LETTERS; i++)
		conversions[i]->timesUsed = 0;
}
int canConvert(char from, char to) {
	conversion *c = conversions[from - 97];
	if (c->timesUsed == 0) {
		c->timesUsed = 1;
		c->to = to;
		return 1;
	} else if (c->to == to) {
		c->timesUsed += 1;
		return 1;
	} else return 0;
}
void undoConversion(char from) {
	conversions[from - 97]->timesUsed -= 1;
}

int main() {
	allocConversions();
	resetConversions();
	printf("canConvert(a,z) : %d\n", canConvert('a', 'z'));
	printf("canConvert(a,b) : %d\n", canConvert('a', 'b'));
	printf("canConvert(a,z) : %d\n", canConvert('a', 'z'));
	undoConversion('a');
	printf("canConvert(a,b) : %d\n", canConvert('a', 'b'));
	undoConversion('a');
	printf("canConvert(a,b) : %d\n", canConvert('a', 'b'));

	return 0;
}

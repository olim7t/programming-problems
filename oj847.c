#include <stdio.h>

int main() {
	long n;
	long k;
	int p;
	while (scanf("%ld", &n) == 1) {
		k = 1;
		p = 0;
		while (k < n) {
			k *= (p ? 2 : 9);
			p = !p;
		}
		if (p) printf("Stan wins.\n");
		else printf("Ollie wins.\n");
	}
	return 0;
}

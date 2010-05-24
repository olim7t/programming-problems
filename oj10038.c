#include <stdio.h>

#define MAX_SIZE 3000

int jumps[MAX_SIZE];
int numJumps;

int jump(int a, int b) {
	int j = a - b;
	if (j < 0) j = -j;
	return j - 1;
}

int main() {
	int n, i, j, n1, n2;
	int jolly;
	while(scanf("%d", &n) == 1) {
		jolly = 1;
		numJumps = n - 1;
		for (i = 0; i < numJumps; i++) jumps[i] = 0;

		scanf("%d", &n2);
		for (i = 0; i < n - 1; i++) {
			if (jolly) {
				n1 = n2;
				scanf("%d", &n2);
				j = jump(n1, n2);
				if (jumps[j] == 1) jolly = 0;
				else jumps[j] = 1;
			} else {
				scanf("%*d");
			}
		}	
		for (i = 0; jolly && i < numJumps;  i++) jolly &= jumps[i];
		if (jolly) printf("Jolly\n");
		else printf("Not jolly\n");
	}
	return 0;
}

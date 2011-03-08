#include <stdio.h>

int count, dollars, cents;
long *p, expenses[1000];

long computeAmount();
long diffIfUnder(long n, long l);
long diffIfAbove(long n, long l);
void printAmount(long a);

int main() {
	while (scanf("%d", &count) != EOF) {
		if (count == 0) {
			return 0;
		} else if (count == 1) {
			scanf("%d.%d", &dollars, &cents);
			printAmount(0);
		} else {
			for (p = &expenses[0]; p < &expenses[count]; p++) {
				scanf("%d.%d", &dollars, &cents);
				*p = dollars * 100 + cents;
			}
			printAmount(computeAmount());
		}
	}
	return 0;
}

long computeAmount() {
	long total = 0;
	long result;
	for (p = &expenses[0]; p < &expenses[count]; p++) {
		total += *p;
	}
	long avg = total / count;
	if (total % count == 0) {
		result = 0;
		for (p = &expenses[0]; p < &expenses[count]; p++) {
			result += diffIfUnder(*p, avg);
		}
	} else {
		long r1 = 0;
		long r2 = 0;
		for (p = &expenses[0]; p < &expenses[count]; p++) {
			r1 += diffIfUnder(*p, avg);
			r2 += diffIfAbove(*p, avg + 1);
		}
		result = (r1 > r2 ? r1 : r2);	
	}
	return result;
}

long diffIfUnder(long n, long l) {
	if (n < l) return l - n; else return 0;
}
long diffIfAbove(long n, long l) {
	if (n > l) return n - l; else return 0;
}
void printAmount(long a) {
	printf("$%ld.%02ld\n", a / 100, a % 100);
}

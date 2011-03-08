#include <stdio.h>

/* The number of primes between 2 and sqrt(2^32 -1) */
#define NUM_PRIMES 6542
unsigned long primes[NUM_PRIMES];
int numPrimes = 0;

void precomputePrimes() {
	unsigned long n;
	int i, isPrime;
	primes[numPrimes++] = 2;
	for (n = 3; n < 65536; n += 2) {
		isPrime = 1;
		for (i = 0; isPrime && i < numPrimes; i++)
			if (n % primes[i] == 0) isPrime = 0;
		if (isPrime) primes[numPrimes++] = n; 
	}
}

/* Finds the smallest divisor p of n such that 1 < p <= n */
unsigned long findSmallestDivisor(unsigned long n) {
	int i;
	unsigned long p;
	for (i = 0; i < NUM_PRIMES; i++) {
		p = primes[i];
		if (n % p == 0) return p;
	}
	return n;
}

int countDivisors(unsigned long n) {
	if (n == 1) return 1;
	unsigned long s = findSmallestDivisor(n);
	if (s == n) return 2;
	else {
		unsigned long d = n / s;
		int pow = 1;
		while (d % s == 0) {
			d = d / s;
			pow++;
		}
		return countDivisors(d) * (pow + 1);
	}
}

int main() {
	precomputePrimes();

	unsigned long n;
	while (scanf("%lu", &n) == 1 && n != 0) {
		if (countDivisors(n) % 2 == 1)
			printf("yes\n");
		else
			printf("no\n");
	}
	return 0;
}

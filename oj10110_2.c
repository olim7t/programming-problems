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

#define CACHE_SIZE 0x5FFFFFF
short cache[CACHE_SIZE] = {0};

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

short hasOddNumDiv(unsigned long n) {
	if (n == 1) return 1;
	short cacheable = (n < CACHE_SIZE);
	short *cached = &cache[n];
	if (cacheable && *cached > 1) return *cached - 1;
	short result;
	unsigned long d = findSmallestDivisor(n);
	if (d == n) result = 0;
	else {
		n /= d;
		int pow = 1;
		while (n % d == 0) {
			n /= d;
			pow++;
		}	
		result = !(pow & 1) && hasOddNumDiv(n);
	}
	if (cacheable) *cached = result + 1;
	return result;
}

int main() {
/*
	int i;
	for (i = 0; i < CACHE_SIZE; i++) cache[i] = -1;
*/

	precomputePrimes();

	unsigned long n;
	while (scanf("%lu", &n) == 1 && n != 0) {
		if (hasOddNumDiv(n))
			printf("yes\n");
		else
			printf("no\n");
	}
	return 0;
}

/* Online judge 10035 - Primary arithmetic.
 * Simple version.
 */
#include <stdio.h>

int main() {
	int in1, in2;
	int min, max, dmin, dmax, carry, n;
	while (1) {
		if (scanf("%d %d", &in1, &in2) != 2) return 1;
		if (in1 == 0 && in2 == 0) return 0;
		if (in1 < in2) {
			min = in1; max = in2;
		} else {
			min = in2; max = in1;
		}
		carry = 0;
		n = 0;
		while (min > 0) {
			dmin = min % 10; min = min / 10;
			dmax = max % 10; max = max / 10;
			carry = (dmin + dmax + carry > 9);
			n += carry;
		}
		while (max > 8) {
			dmax = max % 10; max = max / 10;
			carry = (dmax + carry > 9);
			n += carry;
		}
		if (n == 0) printf("No carry operation.\n");
		else if (n == 1) printf("1 carry operation.\n");
		else printf("%d carry operations.\n", n);
	}
	return 1;
}

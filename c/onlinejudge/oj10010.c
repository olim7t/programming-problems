#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX 50

#define N 1
#define S 2
#define E 4
#define W 8
#define NE N | E
#define NW N | W
#define SE S | E
#define SW S | W

int width, height;
char letters[MAX * MAX];
char buf[MAX+1];

int wordFits(int pos, int size, int dir) {
	int fits = 1;
	if (dir & W) fits &= (pos % MAX - size + 1 >= 0);
	else if (dir & E) fits &= (pos % MAX + size - 1 < width); 
	if (fits)
		if (dir & N) fits &= (pos / MAX - size + 1 >= 0);
		else if (dir & S) fits &= (pos / MAX + size - 1 < height);
	return fits;
}

int next(int pos, int dir) {
	int r = pos;
	if (dir & W) r -= 1;
	else if (dir & E) r += 1;
	if (dir & N) r-= MAX;
	else if (dir & S) r+= MAX;
	return r;
}

int searchInDir(char* w, int size, int pos, int dir) {
	if (!wordFits(pos, size, dir)) return 0;
	else {
		int i, p = pos, found = 1;
		for (i = 1; found && i < size; i++) {
			p = next(p, dir);
			found &= (w[i] == letters[p]);
		}
		return found;
	}
}

int searchAtPos(char* w, int pos) {
	if (w[0] != letters[pos]) return 0;
	int size = strlen(w);
	return searchInDir(w, size, pos, N)
		|| searchInDir(w, size, pos, S)
		|| searchInDir(w, size, pos, E)
		|| searchInDir(w, size, pos, W)
		|| searchInDir(w, size, pos, NE)
		|| searchInDir(w, size, pos, NW)
		|| searchInDir(w, size, pos, SE)
		|| searchInDir(w, size, pos, SW);
}

int main() {
	int i, j, numCases, numWords, found;
	scanf("%d", &numCases);
	while (numCases-- > 0) {
		scanf("%d %d", &height, &width);
		for (i = 0; i < height; i++) {
			scanf("%50s", buf);
			for (j = 0; j < width; j++) {
				letters[i * MAX + j] = toupper(buf[j]);
			}
		}
		scanf("%d", &numWords);
		while (numWords-- > 0) {
			scanf("%50s", buf);
			i = 0;
			while (buf[i] != '\0') {
				buf[i] = toupper(buf[i]);
				i += 1;
			}
			found = 0;
			for (i = 0; !found && (i < height); i++) {
				for (j = 0; !found && (j < width); j++) {
					found = searchAtPos(buf, i * MAX + j);	
				}
			}
			printf("%d %d\n", i, j);
		}
		if (numCases > 0) printf("\n");
	}
	return 0;
}

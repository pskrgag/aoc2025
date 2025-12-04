#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

static void part1(void)
{
	FILE *f;
	char *line = NULL;
	size_t len = 0;
	ssize_t read;
	int val = 50, res = 0;

	f = fopen("in", "r");
	assert(f);

	while (getline(&line, &len, f) != -1) {
		int n = atoi(line + 1);
		int tmp;

		switch (line[0]) {
		case 'R':
			val += n;
			break;
		case 'L':
			tmp = val - n;

			if (tmp < 0)
				val = 100 - -tmp;
			else
				val = tmp;
			break;
		default:
			assert(0);
		}

		val %= 100;
		if (val == 0)
			res += 1;
	}

	fclose(f);
	free(line);
	printf("Res = %d\n", res);
}

static void part2(void)
{
	FILE *f;
	char *line = NULL;
	size_t len = 0;
	ssize_t read;
	int val = 50, res = 0;

	f = fopen("in", "r");
	assert(f);

	while (getline(&line, &len, f) != -1) {
		int n = atoi(line + 1);
		int tmp;

		if (n >= 100) {
			res += n / 100;
			n %= 100;
		}

		switch (line[0]) {
		case 'R':
			val += n;

			if (val >= 100)
				res += 1;
			break;
		case 'L':
			tmp = val - n;

			if (val != 0 && tmp <= 0)
				res += 1;

			if (tmp < 0)
				val = 100 - -tmp;
			else
				val = tmp;
			break;
		default:
			assert(0);
		}

		val %= 100;
	}

	fclose(f);
	free(line);
	printf("Res = %d\n", res);
}
int main(void)
{
	part2();
}

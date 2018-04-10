#include "stdafx.h"
#include "starter.h"

void start(int *multipliers, int multipliersNum, int finisher, int rank, int size) {
	int **mh = new int*[size];
	int **mk = new int*[size];
	int **mg = new int*[size];

	for (int i = 0; i < size; i++) {
		mh[i] = new int[size];
		mk[i] = new int[size];
		mg[i] = new int[size];
	}

	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			mh[i][j] = 1;
			mk[i][j] = 1;
			mg[i][j] = 1;
		}
	}

	int *rawmh = new int[size * size];
	int *rawmk = new int[size * size];
	int *rawmg = new int[size * size];

	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			rawmh[i * size + j] = mh[i][j];
			rawmk[i * size + j] = mk[i][j];
			rawmg[i * size + j] = mg[i][j];
		}
	}

	MPI_Send(rawmg, size * size, MPI_INT, finisher, 0, MPI_COMM_WORLD);

	for (int i = 0; i < multipliersNum; i++) {
		int data[] = { i * size / multipliersNum, (i + 1) * size / multipliersNum };

		MPI_Send(data, 2, MPI_INT, multipliers[i], 1, MPI_COMM_WORLD);
		MPI_Send(rawmh, size * size, MPI_INT, multipliers[i], 2, MPI_COMM_WORLD);
		MPI_Send(rawmk, size * size, MPI_INT, multipliers[i], 3, MPI_COMM_WORLD);
	}
}

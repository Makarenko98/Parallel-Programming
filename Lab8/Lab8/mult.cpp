#include "stdafx.h"
#include "mult.h"
#include <iostream>

using namespace std;

void doMultiplication(int starter, int rank, int finisher, int size) {
	int rawLen = size * size;
	int metadata[2];
	int* mhRaw = new int[rawLen];
	int* mkRaw = new int[rawLen];

	MPI_Recv(metadata, 2, MPI_INT, starter, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	MPI_Recv(mhRaw, size * size, MPI_INT, starter, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	MPI_Recv(mkRaw, size * size, MPI_INT, starter, 3, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

	int **mh = new int*[size];
	int **mk = new int*[size];

	int num = metadata[1] - metadata[0];

	int **res = new int*[num];

	for (int i(0); i < num; i++) {
		res[i] = new int[size];
	}

	for (int i = 0; i < num; i++) {
		for (int j = 0; j < size; j++) {
			res[i][j] = 0;
		}
	}

	for (int i(0); i < size; i++) {
		mh[i] = new int[size];
		mk[i] = new int[size];
	}

	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			mh[i][j] = mhRaw[i * size + j];
			mk[i][j] = mkRaw[i * size + j];
		}
	}

	for (int i = metadata[0]; i < metadata[1]; i++) {
		for (int j = 0; j < size; j++) {
			for (int k = 0; k < size; k++) {
				res[i - metadata[0]][j] += mh[i][k] * mk[k][j];
			}
		}
	}

	int headers[] = { num, metadata[0] };

	int *resRaw = new int[num * size];

	for (int i = 0; i < num; i++) {
		for (int j = 0; j < size; j++) {
			resRaw[i * size + j] = res[i][j];
		}
	}

	MPI_Send(headers, 2, MPI_INT, finisher, 1, MPI_COMM_WORLD);
	MPI_Send(resRaw, num * size, MPI_INT, finisher, 2, MPI_COMM_WORLD);
}

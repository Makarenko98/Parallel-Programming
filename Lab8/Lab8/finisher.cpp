#include "stdafx.h"
#include "finisher.h"
#include <iostream>

using namespace std;

int max(int **m, int size) {
	int mf = m[0][0];

	for (int i = 0; i < size; i++)
		for (int j = 0; j < size; j++)
			if (m[i][j] > mf)
				mf = m[i][j];

	return mf;
}

void printMatrix(int **m, int size) {
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			cout << m[i][j] << "\t";
		}
		cout << endl;
	}
}

void finish(int *multipliers, int multipliersNum, int starter, int rank, int size) {
	int last = 0;

	int **mf = new int*[size];
	for (int i(0); i < size; i++)
		mf[i] = new int[size];

	int *mgRaw = new int[size * size];

	MPI_Recv(mgRaw, size * size, MPI_INT, starter, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

	int **mg = new int*[size];

	for (int i = 0; i < size; i++)
		mg[i] = new int[size];

	for (int i = 0; i < size; i++)
		for (int j = 0; j < size; j++)
			mg[i][j] = mgRaw[i * size + j];

	int m = max(mg, size);

	for (int i = 0; i < multipliersNum; i++) {
		int *headers = new int[2];
		MPI_Recv(headers, 2, MPI_INT, multipliers[i], 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

		int *data = new int[headers[0] * size];

		MPI_Recv(data, size * headers[0], MPI_INT, multipliers[i], 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

		for (int j = headers[1]; j < headers[1] + headers[0]; j++) {
			for (int k = 0; k < size; k++) {
				mf[j][k] = data[size * (j - headers[1]) + k];
			}
		}
	}

	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			mf[i][j] *= m;
		}
	}

	cout << "MF = MAX(MG) * (MH * MK)\nmfult:\n";
	printMatrix(mf, size);
}

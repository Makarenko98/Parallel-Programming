#include "stdafx.h"
#include "finisher.h"
#include "starter.h"
#include "mult.h"


int main(int argc, char *argv[]) {
	int rank;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	int mult[] = { 1, 2, 3, 4 };

	if (rank == 0) {
		start(mult, 4, 5, 1, 10);
	}
	else if (rank == 1) {
		doMultiplication(0, rank, 5, 10);
	}
	else if (rank == 2) {
		doMultiplication(0, rank, 5, 10);
	}
	else if (rank == 3) {
		doMultiplication(0, rank, 5, 10);
	}
	else if (rank == 4) {
		doMultiplication(0, rank, 5, 10);
	}
	else if (rank == 5) {
		finish(mult, 4, 0, rank, 10);
	}

	MPI_Finalize();

	return 0;
}

//mpiexec -n 6 lab8.exe

#include "stdafx.h"
#include <omp.h>
#include <iostream>
#include <ctime>
#include <conio.h>
#include <stdio.h>
#include "Data.h"

using namespace std;

// I = MAX(MO*MP)*R + MS*S
// 6
// 6
// 6

void main()
{
	int sizeOfArrays = 3;

	cout << "N:" << endl;

	cin >> sizeOfArrays;

	Data data(sizeOfArrays);

	int** MO = data.GetMatrixOfOne();
	int** MP = data.GetMatrixOfOne();
	int** MS = data.GetMatrixOfOne();
	int** Rm = data.vectorToMatrix(data.GetVectorOfOne());
	int** Sm = data.vectorToMatrix(data.GetVectorOfOne());
	int* result;

#pragma omp parallel sections
	{
#pragma omp section
			MO = data.multMatrixNuberParallel(data.max(data.multMatrixParallel(MO, MP)), Rm);
#pragma omp section	
			MS = data.multMatrix(MS, Sm);
	}

#pragma omp barrier
	{
		result = data.matrixToVector(data.sumOfMatrix(MO, MS));
		data.printVector(result);
		_getch();
		system("pause");
	}
}


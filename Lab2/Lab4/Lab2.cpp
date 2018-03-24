#include "stdafx.h"
#include <windows.h>
#include <iostream>
#define THREADS_NUMBER 3
using namespace std;

HANDLE MRxMSevent;

void FillVector(int n, int* p);
void FillMatrix(int n, int**m);
void Calculate();
void PrintMatrix(int n, int** A);
void PrintVector(int n, int* A);
int** vectorToMatrix(int n, int* vector);
int* matrixToVector(int n, int** matrix);
int** multMatrix(int n, int** matrix1, int** matrix2);
int** sumOfMatrix(int n, int** matrix1, int** matrix2);

DWORD WINAPI MOxP(CONST LPVOID lpParam);
DWORD WINAPI MRxMS(CONST LPVOID lpParam);
DWORD WINAPI MRxMSxS(CONST LPVOID lpParam);

int **T, **MO, *P, **MR, **MS, *S, **SM, **MP, N;

// T = MO*P + (MR*MS)*S

int main()
{
	N = 0;
	cout << "N: " << endl;
	cin >> N;
	MO = new int*[N];
	MR = new int*[N];
	MS = new int*[N];
	P = new int[N];
	S = new int[N];
	FillMatrix(N, MO);
	FillMatrix(N, MR);
	FillMatrix(N, MS);
	FillVector(N, P);
	FillVector(N, S);

	Calculate();
	cout << "RESULT:" << endl;
	PrintMatrix(N, T);
	system("pause");
	return 0;
}

// T = MO*P + (MR*MS)*S

void Calculate()
{

	MP = vectorToMatrix(N, P);
	SM = vectorToMatrix(N, S);

	HANDLE threads[THREADS_NUMBER];

	MRxMSevent = CreateEvent(NULL, TRUE, FALSE, TEXT("MRxMSevent"));


	threads[0] = CreateThread(NULL, 0, &MOxP, NULL, 0, NULL);
	threads[1] = CreateThread(NULL, 0, &MRxMS, NULL, 0, NULL);
	threads[2] = CreateThread(NULL, 0, &MRxMSxS, NULL, 0, NULL);

	WaitForMultipleObjects(THREADS_NUMBER, threads, TRUE, INFINITE);

	T = sumOfMatrix(N, MO, MR);
}

void FillVector(int n, int* p)
{
	for (int i = 0; i < n; i++)
		p[i] = 1;
}

void FillMatrix(int n, int**m)
{
	for (int i = 0; i < n; i++) {
		m[i] = new int[n];
		FillVector(n, m[i]);
	}
}

DWORD WINAPI MOxP(CONST LPVOID lpParam) {
	MO = multMatrix(N, MO, MP);
	ExitThread(0);
}

DWORD WINAPI MRxMS(CONST LPVOID lpParam) {
	MR = multMatrix(N, MR, MS);
	SetEvent(MRxMSevent);
	ExitThread(0);
}

DWORD WINAPI MRxMSxS(CONST LPVOID lpParam) {
	WaitForSingleObject(MRxMSevent, INFINITE);
	MR = multMatrix(N, MR, SM);
	ExitThread(0);
}

void PrintMatrix(int n, int** A)
{
	for (int i = 0; i < n; i++)
		PrintVector(n, A[i]);
}

void PrintVector(int n, int* A)
{
	for (int i = 0; i < n; i++)
		cout << A[i] << " ";
	cout << endl;
}


int** vectorToMatrix(int n, int* vector)
{
	int** matrix = new int*[n];

	for (int i = 0; i < n; i++)
	{
		matrix[i] = new int[n];
	}

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			matrix[i][j] = 0;
		}
	}

	for (int i = 0; i < n; i++) {
		matrix[i][0] = vector[i];
	}

	return matrix;
}


int* matrixToVector(int n, int** matrix)
{
	int* vector = new int[n];
	int indexOfVector = 0;

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (matrix[i][j] != 0) vector[indexOfVector++] = matrix[i][j];
		}
	}

	return vector;
}

int** multMatrix(int n, int** matrix1, int** matrix2)
{
	int** resultMatrix = new int*[n];

	for (int i = 0; i < n; i++)
	{
		resultMatrix[i] = new int[n];
	}

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			resultMatrix[i][j] = 0;
		}

	}

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			for (int k = 0; k < n; k++) {
				resultMatrix[i][j] += matrix1[i][k] * matrix2[k][j];
			}
		}
	}

	return resultMatrix;
}

int** sumOfMatrix(int n, int** matrix1, int** matrix2)
{
	int** resMatrix = new int*[n];

	for (int i = 0; i < n; i++)
	{
		resMatrix[i] = new int[n];
	}

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			resMatrix[i][j] = matrix1[i][j] + matrix2[i][j];
		}
	}

	return resMatrix;
}
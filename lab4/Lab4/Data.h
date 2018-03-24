#pragma once
#include <iostream>;

class Data
{
public:
	Data(int sizeOfArrays);

	~Data();

	int* GetRandomVector();
	int** GetRandomMatrix();
	int* GetVectorOfOne();
	int** GetMatrixOfOne();
	void printVector(int* vector);
	void printMatrix(int** matrix);
	int* sumOfVectors(int* vector1, int* vector2);
	int** sumOfMatrix(int** matrix1, int** matrix2);
	int** vectorToMatrix(int* vector);
	int* matrixToVector(int** matrix);
	int** multMatrix(int** matrix1, int** matrix2);
	int** multMatrixParallel(int** matrix1, int** matrix2);
	int** transMatrix(int** matrix);
	int dotProduct(int* vector1, int* vector2);
	int* sortVector(int* vector);
	int** multMatrixNuber(int n, int ** matrix);
	int** multMatrixNuberParallel(int n, int ** matrix);
	int max(int** vector);

private:
	int sizeOfArrays;
};


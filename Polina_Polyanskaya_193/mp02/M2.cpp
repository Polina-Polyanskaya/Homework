#include <iostream>
#include <fstream>
#include <cstdlib>
#include <stdlib.h>
#include <string>
#include <vector>
#include <thread>
#include <mutex>
using namespace std;

//Полянская Полина БПИ193 17 вариант

mutex g_lock;
//вектор с координатами проработанных частей участка
static vector<pair<int, int>> Garden;
//число строк в участке
static int rows = 0;
//число столбцов в участке
static int columns = 0;

/// <summary>
/// Проверяет, был ли какой-либо садовник в данной части участка.
/// Если не был, то садовник начинает работать на данной части участка.
/// </summary>
/// <param name="i">позиция в участке по столбцам</param>
/// <param name="j">позиция в участке по строкам</param>
/// <param name="way">информация о том, как ходит садовник</param>
void Adder(int i, int j, string way)
{
	g_lock.lock();
	bool checker = false;
	auto it = Garden.begin();
	//Проверка на то, есть ли такая координата в списке проработанных частях участка
	while (it != Garden.end())
	{
		if (it->first == i && it->second == j)
		{
			checker = true;
		}
		it++;
	}
	//Если такой координаты не было, то садовник приступает к работе.
	if (!checker)
	{
		Garden.push_back(make_pair(i, j));
		cout << "Gardener" << way << " was in spot of bed (" << i << ";" << j << ")." << endl;
	}
	g_lock.unlock();
}

/// <summary>
/// Метод проходит по всему участку по горизонтальному пути.
/// </summary>
void fillGarden1()
{
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < columns; j++)
		{
			Adder(i, j, ", who steps in a horizontal way, ");
		}
	}
}

/// <summary>
/// Метод проходит по всему участку вертикальному пути.
/// </summary>
void fillGarden2()
{
	for (int j = columns - 1; j >= 0; j--)
	{
		for (int i = rows - 1; i >= 0; i--)
		{
			Adder(i, j, ", who steps in a vertical way, ");
		}
	}
}

/// <summary>
/// Превращает строку в число.
/// </summary>
/// <param name="str">входящая строка</param>
/// <returns></returns>
int Converter(string str)
{
	cout << str << endl;
	bool Bool = true;
	string check;
	int res = 0;
	while (Bool)
	{
		try {
			cin >> check;
			res = stoi(check);
			//проверяет если число <=0, больше 100 или не целое, то повторяется ввод строки
			if (res <= 0 || to_string(res) != check || res > 100)
			{
				throw exception();
			}
			Bool = false;
		}
		catch (exception e) {
			cout << "It's a wrong input. Try again." << endl;
		}
	}
	return res;
}

int main()
{
	cout << "You can write down only int numbers from 1 to 100 ([1,100])." << endl;
	rows = Converter("Write down a number of rows.");
	columns = Converter("Write down a number of columns.");
	//создаются два потока - два садовника
	thread* thread1 = new thread{ fillGarden1 };
	thread* thread2 = new thread{ fillGarden2 };
	thread1->join();
	thread2->join();
	delete thread1;
	delete thread2;
}

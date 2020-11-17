#include <iostream>
#include <fstream>
#include <cstdlib>
#include <stdlib.h>
#include <string>
#include <vector>
#include <thread>
#include <random>
#include <mutex>
using namespace std;

static vector <pair<pair<int, int>, string>> library;
static vector<pair<string, int>> books_names;
static int M, N, K = 0;
static int length = 0;
mutex g_lock;
static int counter = 0;

//Полянская Полина Алексеевна БПИ193 17 вариант
/*
Условие:
Задача   об   инвентаризации   по   книгам.   После   нового   года   в библиотеке университета обнаружилась пропажа каталога.
После поиска и наказания, виноватых ректор дал указание восстановить каталог силами студентов. Фонд библиотека представляет собой прямоугольное помещение, в котором находится M рядов по N шкафов по K книг в каждом шкафу.
Требуется создать многопоточное приложение, составляющее каталог. При решении задачи использовать метод «портфель задач», причем в качестве отдельной задачи задается внесение в каталог записи об отдельной книге.
 */

 /// <summary>
 /// Проверяет, удовлетворяет ли введенное число всем условиям
 /// </summary>
 /// <param name="str">Строка о том, какое число вводит пользователь</param>
 /// <returns>Возвращает правильное число</returns>
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

/// <summary>
/// Берёт элемент из вектора books_names и добавляет в вектор library элемент, после удаляет этот элемент из books_names.
/// </summary>
void full_catalog()
{
	g_lock.lock();
	counter++;
	int max = length;
	if (counter == 4)
	{
		max = books_names.size();
	}
	for (int i = 0; i < max; i++)
	{
		vector<pair<string, int>> name_num_of_str;
		name_num_of_str.push_back(books_names[books_names.size() - 1]);
		auto it = name_num_of_str.begin();
		vector<int> nums(2);
		int number_in_vector = it->second + 1;
		//Узнаём, в каком ряду находится данная книга
		for (int j = 0; j < M; j++)
		{
			if (number_in_vector > j * N * K && number_in_vector <= (j + 1) * N * K)
			{
				nums[0] = j + 1;
			}
		}
		//Узнаём, в каком шкафу находится данная книга
		int num_left = number_in_vector - (nums[0] - 1) * N * K;
		for (int j = 0; j < N; j++)
		{
			if (num_left > j * K && num_left <= (j + 1) * K)
			{
				nums[1] = j + 1;
			}
		}
		string name = it->first;
		library.push_back(make_pair(make_pair(nums[0], nums[1]), name));
		//Удаляем добавленную в каталог книгу 
		books_names.pop_back();
	}
	g_lock.unlock();
}

/// <summary>
/// Генерирует и возвращается строку длиной 8
/// </summary>
/// <returns></returns>
string create_string()
{
	char s[] = "abcdefghijklmonpqrstuvwxyz";
	string str = "";
	for (int i = 0; i < 8; i++)
	{
		str += s[rand() % 26];
	}
	return str;
}

/// <summary>
/// Добавляет в вектор books_names название книги и её порядковый номер   
/// </summary>
/// <param name="amount"></param>
/// <param name="i"></param>
void add_books_names(int amount, int i)
{
	if (books_names.size() != amount)
	{
		books_names.push_back(make_pair(create_string(), i));
	}
}

int main()
{
	cout << "You can write down only int numbers from 1 to 100 ([1,100])." << endl;
	//Пользователь вводит число рядов
	M = Converter("Write down a number of rows.");
	//Пользователь вводит число шкафов в ряду
	N = Converter("Write down a number of bookcases in one row.");
	//Пользователь вводит число книг в одном шкафу
	K = Converter("Write down a number of books in the bookcase.");
	//Вывод установленных значений
	cout << "The number of rows = " << M << endl;
	cout << "The number of bookcases in one row = " << N << endl;
	cout << "The number of books in one bookcase = " << K << endl;
	vector<int> numbers = { M,N,K };
	int amount_of_books = M * N * K;
	for (int i = 0; i < amount_of_books; i++)
	{
		add_books_names(amount_of_books, i);
	}
	length = books_names.size() / 4;
	//Создание потоков
	std::thread* thr[4];
	for (int i = 0; i < 4; i++)
	{
		thr[i] = new std::thread{ full_catalog };
	}
	//Завершение потоков
	for (int i = 0; i < 4; i++) {
		thr[i]->join();
		delete thr[i];
	}
	auto it = library.begin();
	//Выводятся положения всех книг
	while (it != library.end())
	{
		int m = it->first.first;
		int n = it->first.second;
		string name = it->second;
		cout << "The name of book is " << name << ". It lies in row = " << m << " and bookcase = " << n << endl;
		it++;
	}
}

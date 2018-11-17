# Foundation of Computer Engineering

## Project 02 -- C++ Programming

---

### [1] Write a C++ program that generates an array of 50 random integers no greater than 100.

**ANS** Below is the procedure from [random number generation](rng.cpp) that generates N integers from uniform distribution *U(a, b)*

```c++
/*
    generate an random integer array of size N, each integer is i.i.d according to uniform distribution [LOWER, UPPER]

    @param N the size of target array
    @param LOWER the lower bound of the uniform distribution
    @param UPPER the upper bound of the uniform distribution
    @return the generated random integer array
*/
std::vector<int> rng::get_random_input(
    const int N,
    const int LOWER, const int UPPER 
) {
    // random number generator:
    std::random_device rd;
    std::seed_seq      seed{rd(), rd(), rd(), rd(), rd(), rd(), rd(), rd()};
    std::mt19937       gen(seed); 
    std::uniform_int_distribution<int> dist(LOWER, UPPER);

    // output array:
    std::vector<int> array(N);
    
    generate(begin(array), end(array), bind(dist, gen));
    
    return array;
}
```

---

### [2] Figure out a way to measure the execution time of a particular section of a program in C++ and use this approach to time the portion of the program written in question [1] that generates the array.

**ANS** In this project the library *chrono* is used to measure the execution time of a statement. Below is the code snippet from [the main function](main.cpp) that measures the execution time of random number generation:

```c++
      // get random input:
      auto input_gen_start = std::chrono::system_clock::now();
      sorting::Array input = rng::get_random_input(size);
      auto input_gen_end = std::chrono::system_clock::now();
      std::chrono::duration<double> input_gen_time = input_gen_end - input_gen_start;
      // record input generation time:
      std::cout << input_gen_time.count() << ", ";
```

---

### [3] Write a C++ function that sorts an array of integers in descending order given as input the size and the starting address of the array using the following sorting algorithms:

* Bubble sort
* Selection sort
* Insertion sort

**ANS** The required three algorithms are implemented in the library [sorting](sorting.cpp)

* Bubble sort
```c++
/*
    sort an array of integers using bubble sort

    @param INPUT the input array
    @return the sorted copy of the input array
*/
sorting::Array sorting::bubble_sort(const sorting::Array &INPUT) {
  Array output(INPUT);

  const int N = INPUT.size();

  // only handle array with more than 1 item:
  if (N > 1) {
    for (int i = N - 1; i > 0; --i) {
      for (int j = 0; j < i; ++j) {
        // assumption: the former should be no larger than the latter
        if (output.at(j) > output.at(j+1)) {
          int temp = output.at(j);
          output.at(j) = output.at(j+1);
          output.at(j+1) = temp;
        }
      }
    }
  }

  return output;
}
```

* Selection sort
```c++
/*
    sort an array of integers using selection sort

    @param INPUT the input array
    @return the sorted copy of the input array
*/
sorting::Array sorting::selection_sort(const sorting::Array &INPUT) {
  Array output(INPUT);

  const int N = INPUT.size();

  if (N > 1) {
    for (int i = 0; i < N - 1; ++i) {
      // initialize:
      int min_idx = i;

      // find min:
      for (int j = i + 1; j < N; ++j) {
        if (output.at(j) < output.at(min_idx)) {
          min_idx = j;
        }
      }

      // assign:
      if (min_idx != i) {
        int temp = output.at(i);
        output.at(i) = output.at(min_idx);
        output.at(min_idx) = temp;
      }
    }
  }

  return output;
}
```

* Insertion sort
```c++
/*
    sort an array of integers using insertion sort

    @param INPUT the input array
    @return the sorted copy of the input array
*/
sorting::Array sorting::insertion_sort(const sorting::Array &INPUT) {
  Array output(INPUT);

  const int N = INPUT.size();

  if (N > 1) {
    for (int i = 1; i < N; ++i) {
      // set target value:
      const int value = output.at(i);

      // insert into subarray:
      int insertion_idx = i - 1;
      while (insertion_idx >= 0 && output.at(insertion_idx) > value) {
        output.at(insertion_idx+1) = output.at(insertion_idx);
        --insertion_idx;
      }
      output.at(insertion_idx + 1) = value;
    }
  }

  return output;
}
```

---

### [4] Combine the codes you developed in steps [1] through [4] to compare the speed of the three above mentioned sorting algorithm (in your report provide a Table that lists the time required to sort arrays of four different lengths (50, 500, 5000, and 50000) using the three sorting algorithms for comparison and use this Table to draw conclusions of your study).

**ANS** Below is the driver program that measures the execution time of random number generation and sorting algorithm for input size of 50, 500, 5000, 50000 and 500000. The results are summarized in the table after the code snippet:

```c++
int main(int argc, char **argv) {
  // number of samples for each size:
  const int N = 3;
  // input sizes:
  std::vector<int> sizes {50, 500, 5000, 50000, 500000};
  // sorting algorithms:
  std::vector<sorting::SortingAlgorithm> algos {
    sorting::bubble_sort,
    sorting::selection_sort,
    sorting::insertion_sort
  };

  // perform experiment:
  for (int n = 0; n < N; ++n) {
    for (const auto &size: sizes) {
      // record size:
      std::cout << size << ", ";

      // get random input:
      auto input_gen_start = std::chrono::system_clock::now();
      sorting::Array input = rng::get_random_input(size);
      auto input_gen_end = std::chrono::system_clock::now();
      std::chrono::duration<double> input_gen_time = input_gen_end - input_gen_start;
      // record input generation time:
      std::cout << input_gen_time.count() << ", ";

      for (const auto &sorting_algo: algos) {
        // sort input:
        auto sorting_start = std::chrono::system_clock::now();
        sorting::Array output = sorting_algo(input);
        auto sorting_end = std::chrono::system_clock::now();
        std::chrono::duration<double> sorting_time = sorting_end - sorting_start;
        // record sorting time:
        std::cout << sorting_time.count() << ", ";        
      }

      std::cout << std::endl;
    }
  }

  // finish data collection:
  std::time_t end_time = std::chrono::system_clock::to_time_t(
    std::chrono::system_clock::now()
  );
  std::cout << "finished computation at " << std::ctime(&end_time) << std::endl;

  return 0;
}
```

| Input Size |         Random Number Generation        |               Bubble Sort               |               Selection Sort              |              Insertion Sort             |
|:----------:|:---------------------------------------:|:---------------------------------------:|:-----------------------------------------:|:---------------------------------------:|
|     50     | 0.000529403 / 0.000147447 / 0.000116811 | 0.000256393 / 0.000109270 / 0.000051671 | 0.000125729 / 0.00004.6177 / 0.00004.3811 | 0.000095079 / 0.000023912 / 0.000018655 |
|     500    | 0.000560324 / 0.000210953 / 0.000243862 |   0.02180470 / 0.00622987 / 0.00593825  |    0.0069163 / 0.00365581 / 0.00311192    |   0.00417298 / 0.00231721 / 0.00228948  |
|    5000    | 0.000788646 / 0.000689142 / 0.000653107 |      0.535776 / 0.528183 / 0.532696     |       0.264199 / 0.253091 / 0.259929      |      0.184097 / 0.183723 / 0.18312      |
|    50000   |   0.00476566 / 0.00463979 / 0.00422744  |       52.9022 / 52.8991 / 52.9778       |        26.0306 / 25.5982 / 25.4874        |       18.1211 / 18.2004 / 18.3635       |
|   500000   |    0.0418296 / 0.0430644 / 0.0429522    |       5296.27 / 5294.24 / 5292.99       |         2555.7 / 2555.25 / 2557.63        |       1831.86 / 1829.66 / 1827.48       |

Here the above table in CSV is also provided for reproducible research.

```csv
  input size, random number generation, bubble sort, selection sort, insertion sort
  50, 0.000529403, 0.000256393, 0.000125729, 9.5079e-05
  500, 0.000560324, 0.0218047, 0.0069163, 0.00417298
  5000, 0.000788646, 0.535776, 0.264199, 0.184097
  50000, 0.00476566, 52.9022, 26.0306, 18.1211
  500000, 0.0418296, 5296.27, 2555.7, 1831.86
  50, 0.000147447, 0.00010927, 4.6177e-05, 2.3912e-05
  500, 0.000210953, 0.00622987, 0.00365581, 0.00231721
  5000, 0.000689142, 0.528183, 0.253091, 0.183723
  50000, 0.00463979, 52.8991, 25.5982, 18.2004
  500000, 0.0430644, 5294.24, 2555.25, 1829.66
  50, 0.000116811, 5.1671e-05, 4.3811e-05, 1.8655e-05
  500, 0.000243862, 0.00593825, 0.00311192, 0.00228948
  5000, 0.000653107, 0.532696, 0.259929, 0.18312
  50000, 0.00422744, 52.9778, 25.4874, 18.3635
  500000, 0.0429522, 5292.99, 2557.63, 1827.48
```

---

### [5] What is the complexity of the program in [1] and [3]? Explain your answer.

**ANS** In order to exclude the overhead introduced by irrelevant subtasks like context switch and memory allocation during initialization phase, here we only focus on algorithm performance when the input size is large enough, namely:

|         Algorithm        | Input Size Threshold |
|:------------------------:|:--------------------:|
| Random Number Generation |         50000        |
|        Bubble Sort       |         5000         |
|      Selection Sort      |         5000         |
|      Insertion Sort      |         5000         |

#### Complexity Analysis

From the measurements of execution time when the input size is larger than the corresponding threshold, it is easy to see that:

* Random Number Generation scales linearly with input size
* Bubble Sort, Selection Sort and Insertion Sort scale quadratically with input size

So the complexity of each algorithm (big-O notation, worst case performance) can be summarized as follows:

|         Algorithm        | Input Size Threshold |
|:------------------------:|:--------------------:|
| Random Number Generation |         O(N)         |
|        Bubble Sort       |        O(N**2)       |
|      Selection Sort      |        O(N**2)       |
|      Insertion Sort      |        O(N**2)       |

#### Constant Coefficient Analysis for Dominant Term

For the three sorting algorithm:

* The number of comparisons is both O(N**2). However, in insertion sort the randomness of input is leveraged thus the expected complexity will only be the half of the other two.
* Regarding item rearrangement, for bubble sort O(N**2) expensive swap operations are need, while only O(N) will be enough for selection sort. For insertion sort, since cheaper shift and direct assignment operations will be used in replacement of the expensive swap, it will be the fastest among the three.

The experiment results agree very well with the above theoretical analysis:

* It is obvious that bubble sort is the slowest: the other two algorithms only need less than half of the time to sort the same input. 
* Insertion sort is still faster than selection sort since the randomness of input is leveraged and less expensive operations are used for item rearrangement.

That is the reason why in STL insertion sort is used for leaf node sorting inside the quick sort.

#include "rng.hpp"
#include "sorting.hpp"

#include <vector>
#include <chrono>
#include <ctime>
#include <iostream>

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

/**
    ECE697 Project 2
    sorting.cpp
    purpose: sorting algorithm library implementation

    @author Yao Ge
    @version 1.0 13/11/2018
*/

#include "sorting.hpp"

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

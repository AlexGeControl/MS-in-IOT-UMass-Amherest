/**
    ECE697 Project 2
    sorting.hpp
    purpose: sorting algorithm library interfaces

    @author Yao Ge
    @version 1.0 13/11/2018
*/

#ifndef SORTING_HPP_
#define SORTING_HPP_

#include <vector>

namespace sorting {
  // input type definition:
  typedef std::vector<int> Array;

  // algorithm type definition:
  typedef Array (*SortingAlgorithm)(const Array &);
  /*
      sort an array of integers using bubble sort

      @param INPUT the input array
      @return the sorted copy of the input array
  */
  Array bubble_sort(const Array &INPUT);

  /*
      sort an array of integers using selection sort

      @param INPUT the input array
      @return the sorted copy of the input array
  */
  Array selection_sort(const Array &INPUT);

  /*
      sort an array of integers using insertion sort

      @param INPUT the input array
      @return the sorted copy of the input array
  */
  Array insertion_sort(const Array &INPUT);
};

#endif

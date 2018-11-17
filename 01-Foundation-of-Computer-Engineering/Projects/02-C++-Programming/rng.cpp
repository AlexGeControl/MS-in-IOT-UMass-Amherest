/**
    ECE697 Project 2
    rng.cpp
    purpose: random integer array generation library impelmentation

    @author Yao Ge
    @version 1.0 13/11/2018
*/

#include "rng.hpp"

#include <random>     // random_device, seed_seq, mt19937 and uniform_int_distribution
#include <algorithm>  // generate
#include <iterator>   // begin, end, and ostream_iterator
#include <functional> // bind

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
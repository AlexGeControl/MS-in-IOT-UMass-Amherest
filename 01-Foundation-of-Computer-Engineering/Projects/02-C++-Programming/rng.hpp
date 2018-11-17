/**
    ECE697 Project 2
    rng.hpp
    purpose: random integer array generation library interfaces

    @author Yao Ge
    @version 1.0 13/11/2018
*/

#ifndef RNG_HPP_
#define RNG_HPP_

#include <vector>

/*
    generate an random integer array of size N, each integer is i.i.d according to uniform distribution [LOWER, UPPER]

    @param N the size of target array
    @param LOWER the lower bound of the uniform distribution
    @param UPPER the upper bound of the uniform distribution
    @return the generated random integer array
*/
namespace rng {
    std::vector<int> get_random_input(
        const int N,
        const int LOWER = 0, const int UPPER = 100
    );
};

#endif
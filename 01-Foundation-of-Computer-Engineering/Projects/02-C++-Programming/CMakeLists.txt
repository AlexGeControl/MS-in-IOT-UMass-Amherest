# minimum cmake version:
cmake_minimum_required( VERSION 3.5 )

# project name:
project( CPPProgramming )

# libraries:
add_library( rng SHARED rng.cpp )
add_library( sorting SHARED sorting.cpp )

# runnable:
SET(CMAKE_CXX_FLAGS "-std=c++0x")

# executables:
add_executable( main main.cpp )
target_link_libraries( main rng sorting )

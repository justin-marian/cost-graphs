CXX = g++
CXXFLAGS = -std=c++17 -Wall

.PHONY: build clean

build: task1 task2 task3

task1: p1.cpp
	$(CXX) $(CXXFLAGS) -o p1 p1.cpp

task2: p2.cpp
	$(CXX) $(CXXFLAGS) -o p2 p2.cpp

task3: p3.cpp
	$(CXX) $(CXXFLAGS) -o p3 p3.cpp

run-p1:
	./p1
run-p2:
	./p2
run-p3:
	./p3

clean:
	@rm -f p1 p2 p3 *.txt *.out
	@rm -rf tests/p1/out/* tests/p2/out/* tests/p3/out/*
	@rm -rf tests/p1/*.out tests/p2/*.out tests/p3/*.out


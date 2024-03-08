CXX = g++
CXXFLAGS = -std=c++17 -Wall
SRCDIR = src
TESTSDIR = tests

.PHONY: build clean

build: task1 task2 task3

task1: $(SRCDIR)/p1.cpp
	$(CXX) $(CXXFLAGS) -o p1 $(SRCDIR)/p1.cpp

task2: $(SRCDIR)/p2.cpp
	$(CXX) $(CXXFLAGS) -o p2 $(SRCDIR)/p2.cpp

task3: $(SRCDIR)/p3.cpp
	$(CXX) $(CXXFLAGS) -o p3 $(SRCDIR)/p3.cpp

run-p1:
	./p1
run-p2:
	./p2
run-p3:
	./p3

clean:
	@rm -f p1 p2 p3 *.txt *.out
	@rm -rf $(TESTSDIR)/p1/out/* $(TESTSDIR)/p2/out/* $(TESTSDIR)/p3/out/*
	@rm -rf $(TESTSDIR)/p1/*.out $(TESTSDIR)/p2/*.out $(TESTSDIR)/p3/*.out

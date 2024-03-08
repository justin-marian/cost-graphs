#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DEBUG=on

total=0						# don't change
MAX_POINTS=100      		# you can change it
UTILS=utils					# don't change

# Put your tasks in this function
test_homework() {
	if [[ "$1" = "1" || "$1" = "p1" ]]; then
		test_p1
	elif [[ "$1" = "2" || "$2" = "p2" ]]; then
		test_p2
	elif [[ "$1" = "3" || "$3" = "p3" ]]; then
		test_p3
	elif [[ "$1" = "cs" ]]; then
		echo "skip running tests"
	else
		test_p1
		test_p2
		test_p3
	fi
}


# Task 1
test_p1() {
	n_tests=10
	src_names=(p1.c p1.cpp)
	tests=( $(seq 0 $(($n_tests - 1))) )
	points=(3 3 3 3 3 3 3 3 3 3)
	pmax=30

	run_problem p1 1
}

# Task 2
test_p2() {
	n_tests=10
	src_names=(p2.c p2.cpp)
	tests=( $(seq 0 $(($n_tests - 1))) )
	points=(3 3 3 3 3 3 3 3 3 3)
	pmax=30

	run_problem p2 2
}

# Task 3
test_p3() {
	n_tests=10
	src_names=(p3.c p3.cpp)
	tests=( $(seq 0 $(($n_tests - 1))) )
	points=(3 3 3 3 3 3 3 3 3 3)
	pmax=30

	run_problem p3 3
}

check_readme() {
	README=README.md

	echo -e "${BLUE}---------------------------------------------------------"
	echo "---------------------------------------------------------"
	echo "=============>>>>>>>Check $README<<<<<<<==============="
	echo "---------------------------------------------------------"

	score=10
	max_score=10

	if (( $(echo "$total == 0" | bc -l)  )); then
		echo -e "${YELLOW}Punctaj $README neacordat. Punctajul pe teste este $total!${NC}"
	elif [ ! -f $README ]; then
		score=0
		echo -e "${RED}$README lipsa.${NC}"
	elif [ -f $README ] && [ "`ls -l $README | awk '{print $5}'`" == "0" ]; then
		score=0
		echo -e "${RED}$README gol.${NC}"
	else
		score=$max_score
		echo -e "${GREEN}$README OK. Punctajul final se va acorda la corectare.${NC}"
	fi

	total=$(bc <<< "$total + $score")

	echo -e "${YELLOW}=============>>>>>>>$README: $score/$max_score<<<<<<<==============${NC}"
	echo -e "${BLUE}---------------------------------------------------------"
	echo "---------------------------------------------------------"
}

check_cpp_errors() {
	cnt_cpp=$(cat $1 | grep "Total errors found" | cut -d ':' -f2 | cut -d ' ' -f2)
}

timeout_test() {
	tag=$1
	timeout=$2
	(time timeout $timeout make $tag) >& error

	cnt=`cat error | grep "'$tag' failed" | wc -l`

	if [ $cnt -gt 0 ]; then
		t=`cat error | grep "real" | cut -d 'm' -f2 | cut -d 's' -f1 | tr ',' '.'`
		if [  $(echo "$t > $timeout" | bc) -eq 1  ]; then
			rm -f error
			echo "$t s" > tle
		fi
	else
		t=`cat error | grep "real" | cut -d 'm' -f2 | cut -d 's' -f1`
		echo "$t s" > output.time
		rm -f error
	fi
}

run_problem() {
	name=$1
	id=$2

	echo -e "${BLUE}---------------------------------------------------------"
	echo "---------------------------------------------------------"
	echo "--------------------- problem $id: $name ---------------------"

	score=0

	if [ `find -L . -name ${src_names[0]} | wc -l` -eq 1  ]; then
		timeout=`cat $UTILS/timeout/c.timeout$id`
		echo -e "${YELLOW}-------------------- time C => ${timeout}sec -------------------${NC}"
	elif [ `find -L . -name ${src_names[1]} | wc -l` -eq 1  ]; then
		timeout=`cat $UTILS/timeout/c.timeout$id`
		echo -e "${YELLOW}-------------------- time C++ => ${timeout}sec -------------------${NC}"
	fi

	rm -rf $TESTS_DIR/$name/out/
	mkdir -p $TESTS_DIR/$name/out/

	for i in "${tests[@]}"; do
		IN=$TESTS_DIR/$name/input/test$((i+1)).in
		REF=$TESTS_DIR/$name/ref/test$((i+1)).ref
		OUT=$TESTS_DIR/$name/out/test$((i+1)).out

		if [ $i -lt 10 ]
		then
			i=" "$i
		fi

		if [ ! -f $IN ]; then
			echo -e "${RED}Test $i problem $id .......... 0/${points[$i]} - $IN missing!${NC}"
			continue
		fi

		cp $IN date.in
		cp $REF res.ok

		touch date.out
		chmod 666 date.out

		timeout_test run-p$id $timeout
		

		if [ -f error ]; then
			echo -e "${RED}Test $i problem $id .......... 0.0/${points[$i]} - Run time error!${NC}"
			# TODO
			# cat error
		elif [ -f tle ]; then
			echo -e "${RED}Test $i problem $id .......... 0.0/${points[$i]} - TLE - $(cat tle)!${NC}"
		else
			./verif $name ${points[$i]}

			STATUS=$(cat output.verif)
			TIME=$(cat output.time)
			SCORE=$(cat score.verif)
			echo -e "${GREEN}Test $i problem $id .......... $SCORE/${points[$i]} - $STATUS - $TIME${NC}"
			total=$(bc <<< "$total + $SCORE")
			score=$(bc <<< "$score + $SCORE")
		fi

		if [ ! -z $DEBUG ]; then
			cp date.out  $OUT
		fi

		rm -f date.in date.out res.ok score.verif output.verif output.time \
		  error.time error.exec error expected.time tle time.err run.err sd run.out
	done

	echo -e "${YELLOW}==================>>>>Score: $score/$pmax<<<<=================${NC}"
}

if [[ "$1" = "h" || "$1" = "help" ]]; then
	echo -e "${BLUE}Usage:${NC}"
	echo "       ./check.sh                 # run the entire homework"
	echo "       ./check.sh task_id         # run only one problem (e.g. number or name)"
	echo "       ./check.sh cs              # run only the coding style check"
	exit 0
fi

TESTS_DIR=tests

# Check if Makefile exists
if [ ! -f Makefile ]; then
	echo -e "${RED}Makefile lipsa. STOP${NC}"
	echo -e "${YELLOW}===============>>>>>>>Total: $total/$MAX_POINTS<<<<<<<================${NC}"
	exit
fi

# Compile and check errors
make -f Makefile build &> out.make
cnt=$(cat out.make| grep failed | wc -l)

(g++ --version 2> /dev/null > tmp && cat tmp | head -1)  || (echo -e "${RED}Please install 'g++' :p!${NC}" && exit 1)
(gcc --version 2> /dev/null > tmp && cat tmp | head -1)  || (echo -e "${RED}Please install 'gcc' :p!${NC}" && exit 1)
rm -f tmp

# cat out.make
rm -f out.make
if [ $cnt -gt 0 ]; then
	echo -e "${RED}Erori de compilare. Verifica versiunea compilatorului. STOP${NC}"
	echo -e "${YELLOW}===============>>>>>>>Total: $total/$MAX_POINTS<<<<<<<===============${NC}"
	exit
fi

# Compile checker
make -f Makefile.Utils all $ONLINE_JUDGE &> /dev/null

# Display tests set
echo -e "${BLUE}	 		Run $TESTS_DIR					${NC}"

# Run tests - change functions test_*
test_homework $TEST_TO_RUN
check_readme

# Clean junk
make -f Makefile clean &> /dev/null
make -f Makefile.Utils clean &> /dev/null
rm -rf tmp

# Display result
echo -e "${YELLOW}==============>>>>>>>Total: $total/$MAX_POINTS<<<<<<<=============${NC}"
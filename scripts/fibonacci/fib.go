package main

import (
	"errors"
	"flag"
	"fmt"
	"os"

	"golang.org/x/text/language"
	"golang.org/x/text/message"
)

const MAX = 1_000_000

func main() {
	n := flag.Int("n", 10, "the Fibonacci number to calculate")
	flag.Parse()

	result, err := fibonacciArray(*n)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("fib(%d) = %d\n", *n, result)
}

func fibonacciArray(n int) ([]int, error) {
	p := message.NewPrinter(language.English)
	if n <= 0 {
		return nil, errors.New("must be a positive number")
	}
	if n >= MAX {
		return nil, errors.New(p.Sprintf("must be a number less than %d", MAX))
	}

	seq := make([]int, n+1)
	seq[0] = 0
	seq[1] = 1
	if n == 1 {
		return seq, nil
	}
	for i := 2; i <= n; i++ {
		seq[i] = seq[i-1] + seq[i-2]
	}
	return seq, nil
}

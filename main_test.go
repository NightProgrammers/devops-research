package main

import (
	"testing"
)

func TestAbc(t *testing.T) {
	t.Run("only a demo", func(t *testing.T) {
		if 1+1 != 2 {
			t.Fatal("computer is not computer!")
		}
	})
}

module Main where

import Text.Printf

main = do
  inp <- readFile "input.txt"
  let ints = read <$> lines inp
  let p1 = countInc ints
  let p2 = countInc2 ints
  printf "Part 1: %d\n" p1
  printf "Part 2: %d\n" p2

countInc :: [Int] -> Int 
countInc nums = length . filter id . zipWith (<) nums $ tail nums

countInc2 :: [Int] -> Int 
countInc2 nums = length . filter id . zipWith (<) nums $ tail (tail (tail nums))

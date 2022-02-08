module Main where

import Utils

main = do
  inp <- readFile "input.txt"
  benchme (calc) inp

calc :: String -> (Int,Int)
calc inp = (p1, p2) where
  ints = read <$> lines inp
  p1 = countInc ints
  p2 = countInc2 ints

countInc :: [Int] -> Int 
countInc nums = length . filter id . zipWith (<) nums $ tail nums

countInc2 :: [Int] -> Int 
countInc2 nums = length . filter id . zipWith (<) nums $ tail (tail (tail nums))

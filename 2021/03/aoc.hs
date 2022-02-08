module Main where

import Criterion.Main
import Criterion.Types (Config (..))
import Data.List (foldl', transpose)
import System.Environment
import Data.Maybe (isJust)
import Text.Printf
import Debug.Trace

main = do
  inp <- readFile "input.txt"
  aocBench <- isJust <$> lookupEnv "AoC_BENCH"
  if aocBench then do
    defaultMainWith defaultConfig{ timeLimit = 2.0 } [ bench "aoc" $ nf (calc) inp ]
  else do
    let (p1, p2) = calc inp
    printf "Part 1: %d\n" p1
    printf "Part 2: %d\n" p2


-- calc :: String -> (Int, Int)
calc inp = (p1, p2)
  where
    gamma = part1 $ lines inp
    p1 = toNum gamma * toNum [1 - a | a <- gamma]
    p2 = (toNumS . part2 (>=) 0 $ lines inp) * (toNumS . part2 (<) 0 $ lines inp)

toNumS :: String -> Int
toNumS l = toNum [if x == '1' then 1 else 0 | x <- l]

toNum :: [Int] -> Int
toNum = foldl' (\acc x -> acc * 2 + x) 0

part1 :: [String] -> [Int]
part1 l = [if a >= b then 1 else 0 | (a, b) <- part1' 0 l]
  where
    part1' :: Int -> [String] -> [(Int, Int)]
    part1' i l
      | i >= length (head l) = []
      | otherwise = [countCol i l] ++ part1' (i + 1) l

countCol :: Int -> [String] -> (Int, Int)
countCol i l = foldr (\b (o, z) -> if b !! i == '1' then (o + 1, z) else (o, z + 1)) (0, 0) l

part2 :: (Int -> Int -> Bool) -> Int -> [String] -> String
part2 p i l
  | i >= length (head l) = head l
  | length l == 1 = head l
  | otherwise = part2 p (i + 1) l'
  where
    l' = filter (\r -> r !! i == most) l
    most = if o `p` z then '1' else '0'
    (o, z) = countCol i l

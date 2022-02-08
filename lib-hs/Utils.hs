module Utils where

import Criterion.Main
import Criterion.Types (Config (..))
import Data.Maybe (isJust)
import System.Environment

-- benchme :: (String -> a) -> String -> a
benchme fn inp = do
  aocBench <- isJust <$> lookupEnv "AoC_BENCH"
  if aocBench then do
    defaultMainWith defaultConfig{ timeLimit = 2.0 } [ bench "aoc" $ nf (fn) inp ]
  else do
    let (p1, p2) = fn inp
    putStrLn ("Part 1: "  ++ show p1)
    putStrLn ("Part 2: "  ++ show p2)

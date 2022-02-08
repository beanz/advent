module Main where

import Utils

main = do
  inp <- readFile "input.txt"
  benchme (calc) inp

calc :: String -> (Int,Int)
calc inp = (p1, p2) where
  inst = parseLine <$> lines inp
  p1 = uncurry (*) $ moves1 inst
  p2 = uncurry (*) $ moves2 inst

data Instruction = Forward Int | Down Int | Up Int deriving (Show, Read, Eq)

parseLine :: String -> Instruction
parseLine line = case words line of
  "forward":n:_ -> Forward (read n :: Int)
  "up":n:_ -> Up (read n :: Int)
  "down":n:_ -> Down (read n :: Int)
  _ -> error "invalid instruction"

move :: Instruction -> (Int, Int) -> (Int,Int)
move (Forward n) (x,y) = (x+n, y)
move (Up n) (x,y) = (x, y-n)
move (Down n) (x,y) = (x, y+n)

moves1 :: [Instruction] -> (Int, Int)
moves1 = moves1' (0,0) where
  moves1' (x,y) [] = (x,y) 
  moves1' (x,y) (head:rest) = moves1' (move head (x, y)) rest

move2 :: Instruction -> (Int, Int, Int) -> (Int,Int, Int)
move2 (Forward n) (x,y,a) = (x+n, y+(a*n), a)
move2 (Up n) (x,y,a) = (x, y, a-n)
move2 (Down n) (x,y,a) = (x, y, a+n)

moves2 :: [Instruction] -> (Int, Int)
moves2 = moves2' (0,0,0) where
  moves2' (x,y,a) [] = (x,y) 
  moves2' (x,y,a) (head:rest) = moves2' (move2 head (x, y, a)) rest

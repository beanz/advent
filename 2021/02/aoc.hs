module Main where

import Text.Printf
import Graphics.X11.Xinerama (XineramaScreenInfo(xsi_height))

data Instruction = Forward Int | Down Int | Up Int deriving (Show, Read, Eq)

readInt :: String -> Int 
readInt s = read s :: Int

parseLine :: String -> Instruction
parseLine line = case words line of
  "forward":n:_ -> Forward (readInt n)
  "up":n:_ -> Up (readInt n)
  "down":n:_ -> Down (readInt n)
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

main = do
  inp <- readFile "input.txt"
  let inst = parseLine <$> lines inp
  let p1 = moves1 inst
  let p2 = moves2 inst
  printf "Part 1: %d\n" (uncurry (*) p1)
  printf "Part 2: %d\n" (uncurry (*) p2)


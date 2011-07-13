{-
 - Bot Trust (Google Code Jam 2011, Qualification round, problem A)
 -
 - Blue and Orange are friendly robots. An evil computer mastermind has locked them up in separate hallways to test them,
 - and then possibly give them cake.
 -
 - Each hallway contains 100 buttons labeled with the positive integers {1, 2, ..., 100}. Button k is always k meters from
 - the start of the hallway, and the robots both begin at button 1. Over the period of one second, a robot can walk one
 - meter in either direction, or it can press the button at its position once, or it can stay at its position and not
 - press the button. To complete the test, the robots need to push a certain sequence of buttons in a certain order. Both
 - robots know the full sequence in advance. How fast can they complete it? 
 -
 - The first line of the input gives the number of test cases, T. T test cases follow.
 - Each test case consists of a single line beginning with a positive integer N, representing the number of buttons that
 - need to be pressed. This is followed by N terms of the form "Ri Pi" where Ri is a robot color (always 'O' or 'B'), and
 - Pi is a button position. 
 -
 - Sample input & output:

3
4 O 2 B 1 B 2 O 4
3 O 5 O 8 B 100
2 B 2 B 1

Case #1: 6
Case #2: 100
Case #3: 4

-}
import Control.Monad
import Data.List

data Robot = O | B deriving (Show, Read, Eq)

main = do
  input <- getContents
  let cases = tail . lines $ input
      solutions = map solve cases
      output = zip [1..] solutions
  forM_ output (\(numCase, solution) -> putStrLn $ "Case #" ++ show numCase ++ ": " ++ show solution)

-- Solves a single case
solve :: String -> Int
solve = minTime 1 1 . parse

-- Parses the instructions for a single case
parse :: String -> [(Robot, Int)]
parse = parseSplitted . tail . words
  where parseSplitted [] = []
        parseSplitted (x1 : x2 : xs) = (read x1, read x2) : (parseSplitted xs)

-- Computes the minimum time given the current positions and the remaining instructions
minTime :: Int -> Int -> [(Robot, Int)] -> Int
minTime _ _ [] = 0
minTime currentO currentB instructions@((r, target) : nextInstructions)
  | (r == O && currentO == target) = 1 + minTime currentO moveB nextInstructions
  | (r == B && currentB == target) = 1 + minTime moveO currentB nextInstructions
  | otherwise                      = 1 + minTime moveO moveB instructions
  where moveO = move currentO $ nextPosition O
        moveB = move currentB $ nextPosition B
        move current (Just next) = current + signum (next - current)
        move current Nothing = current
        nextPosition robot = fmap snd $ find (\(r, p) -> r == robot) instructions

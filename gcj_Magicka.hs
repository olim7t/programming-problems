{-
 - Magicka (Google Code Jam 2011, Qualification round, problem B)
 -
 - As a wizard, you can invoke eight elements, which are the "base" elements. Each base element is a single character from
 - {Q, W, E, R, A, S, D, F}. When you invoke an element, it gets appended to your element list. For example: if you invoke
 - W and then invoke A, (we'll call that "invoking WA" for short) then your element list will be [W, A].
 -
 - We will specify pairs of base elements that combine to form non-base elements (the other 18 capital letters). For example,
 - Q and F might combine to form T. If the two elements from a pair appear at the end of the element list, then both elements
 - of the pair will be immediately removed, and they will be replaced by the element they form. In the example above, if the
 - element list looks like [A, Q, F] or [A, F, Q] at any point, it will become [A, T].
 -
 - We will specify pairs of base elements that are opposed to each other. After you invoke an element, if it isn't immediately
 - combined to form another element, and it is opposed to something in your element list, then your whole element list will be
 - cleared.
 -
 - Sample input & output:

5
0 0 2 EA
1 QRI 0 4 RRQR
1 QFT 1 QF 7 FAQFDFQ
1 EEZ 1 QE 7 QEEEERA
0 1 QW 2 QW

Case #1: [E, A]
Case #2: [R, I, R]
Case #3: [F, D, T]
Case #4: [Z, E, R, A]
Case #5: []

-}
import Control.Monad(forM_)
import Data.List(find, intercalate)
import qualified Data.Map as Map
import qualified Data.Set as Set

type Combinations = Map.Map (Char, Char) Char
type Oppositions = Set.Set (Char, Char)
type ElementList = String

main = do
  input <- getContents
  let cases = tail . lines $ input
      solutions = map solve cases
      output = zip [1..] solutions
  forM_ output (\(numCase, solution) -> putStrLn $ "Case #" ++ show numCase ++ ": " ++ format solution)

parse :: String -> (Combinations, Oppositions, ElementList)
parse s = let [rawCombs, rawOps, [elements]] = splitOnInts $ words s
        in (parseCombs rawCombs, parseOps rawOps, elements)
        where parseCombs = Map.fromList . map (\[a,b,c] -> ((a,b),c)) . mirrorLeadingChars
              parseOps = Set.fromList . map (\[a,b] -> (a,b)) . mirrorLeadingChars
              mirrorLeadingChars [] = []
              mirrorLeadingChars (w@(c1:c2:cs):ws) = w:(c2:c1:cs):(mirrorLeadingChars ws)

-- ["1", "foo", "bar", "2", "baz"] -> [["foo", "bar"], ["baz"]]
splitOnInts :: [String] -> [[String]]
splitOnInts = reverse . foldl processWord []
  where processWord groups word | isInt word = [] : groups
        processWord (group1:groups) word = (word:group) : groups
        isInt s = case reads s :: [(Int, String)] of
          [(_, "")] -> True
          _ -> False

solve :: String -> ElementList
solve input = reverse $ foldl addElement [] inputElements
  where (combinations, oppositions, inputElements) = parse input
        addElement [] e = [e]
        addElement processed@(p1:ps) e = case Map.lookup (e, p1) combinations of
          Just combined -> combined : ps
          Nothing -> case find (\p -> Set.member (e, p) oppositions) processed of
            Just _ -> []
            Nothing -> e : processed

format :: ElementList -> String
format s = '[' : formatTail s
  where formatTail [] = "]"
        formatTail (x:[]) = x : "]"
        formatTail (x:xs) = x : ',' : ' ' : (formatTail xs)

module Problems where

import Data.Maybe

-- Problem 1
myLast :: [a] -> Maybe a
myLast [] = Nothing
myLast [a] = Just a
myLast (h:t) = myLast t

-- Problem 2
myLastButOne :: [a] -> Maybe a
myLastButOne [] = Nothing
myLastButOne (h:m:[]) = Just h
myLastButOne (h:m:t) = myLastButOne (m:t)
myLastButOne (h:t) = myLastButOne t

-- Problem 3
elementAt :: [a] -> Int -> Maybe a
elementAt [] _ = Nothing
elementAt (h:t) 0 = Just h
elementAt (h:t) n = elementAt t (n-1)

-- Problem 4
myLength :: [a] -> Int
myLength [] = 0
myLength (h:t) = (myLength t) + 1

-- Problem 5
myRev :: [a] -> [a]
myRev [] = []
myRev (h:t) = (myRev t) ++ [h]

-- Problem 6
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = xs == (reverse xs)

isPalindrome' []  = True
isPalindrome' [_] = True
isPalindrome' xs  = (head xs) == (last xs) && (isPalindrome' $ init $ tail xs)

-- Problem 7
data NestedList a = Elem a | List [NestedList a]
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List x) = concatMap flatten x

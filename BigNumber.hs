module BigNumber (BigNumber, scanner, output, somaBN, subBN, mulBN, divBN, safeDivBN) where
import Prelude
import Data.Char (digitToInt, intToDigit)

type BigNumber = (Char , [Int])

--turns a number in a String to BigNumber
scanner :: String -> BigNumber
scanner a | head a == '-' = ('-', map digitToInt (drop 1 a))
          | otherwise = ('+', map digitToInt a)

--turns a BigNumber to a string
output :: BigNumber -> String
output a | fst a == '-' = '-' : map intToDigit (takeZeros(snd a))
         | otherwise = map intToDigit (takeZeros(snd a))

-- ensures every element in the list is only one digit long, if not, it separates them
somaCheck :: [Int] -> [Int]
somaCheck [x] | x < 10 = [x]
              | otherwise = [x `mod` 10, x `div` 10]
somaCheck (x:xs) | x < 10 = x : somaCheck xs
                 | otherwise = x `mod` 10 : somaCheck (head xs + x `div` 10 : drop 1 xs)

-- returns a list with the sum of both argument lists elements
somaLista :: [Int] -> [Int] -> [Int]
somaLista [] [] = []
somaLista (a:as) [] = a : somaLista as []
somaLista [] (b:bs) = b : somaLista [] bs
somaLista (a:as) (b:bs) = a + b : somaLista as bs

-- this auxiliar function ensures that after a subtraction no element of the list is negative
subCheck :: [Int] -> [Int]
subCheck [x] | x == 0 = []
             | x < 0 = [x + 10]
             | otherwise = [x]
subCheck (x:xs) | x < 0 = x + 10 : subCheck (head xs - 1 : drop 1 xs)
                | otherwise  = x : subCheck xs


-- returns a list with the result of the subtraction of the elements of the first list by the elements of the second
subLista :: [Int] -> [Int] -> [Int]
subLista [] [] = []
subLista (a:as) [] = a : subLista as []
subLista [] (b:bs) = b : subLista [] bs
subLista (a:as) (b:bs) = a - b : subLista as bs

-- appends a specified number n of elements of value 0 to the a list
addZeros :: [Int] -> Int -> [Int]
addZeros a 0 = a
addZeros a n = 0 : addZeros a (n-1)

-- removes all redundant zeros to the left
takeZeros :: [Int] -> [Int]
takeZeros [] = [0]
takeZeros (a:as)    | a == 0  = takeZeros as
                    | otherwise = a:as


mulAdd :: [[Int]] -> [Int]
mulAdd [] = [0]
mulAdd (x:xs) = somaCheck (somaLista (addZeros x (length xs)) (mulAdd xs))

mulLista :: [Int] -> [Int] -> [[Int]]
mulLista a = map (\b -> somaCheck (map (*b) a))

-- compares the values of the two lists with the same lenght.
-- returns 0 if the lists have the same value, 1 if the first list has a greater value and 2 if it is the second one
maiorsame :: BigNumber -> BigNumber -> Int
maiorsame (_, []) (_, []) = 0
maiorsame (a, b:bs) (c, d:ds) | b > d = 1
                              | b < d = 2
                              | otherwise = maiorsame (a, bs) (c, ds)

-- compares the values of the two lists with arbitrary lenghts.
--returns the list with greater value on it, if they are equal returns the first
maior :: BigNumber -> BigNumber -> BigNumber
maior a b | length (snd a) > length (snd b) = a
          | length (snd a) < length (snd b) = b
          | otherwise = if maiorsame a b == 1 || maiorsame a b == 0 then a else b

-- compares the values of the two lists with arbitrary lenghts.
-- returns 0 if the lists have the same value, 1 if the first list has a greater value and 2 if it is the second one
menor :: BigNumber -> BigNumber -> Int
menor a b | length (snd a) > length (snd b) = 1
          | length (snd a) < length (snd b) = 2
          | otherwise = maiorsame a b

-- takes an Int and separates all of its digits into a list
listSpliter :: Int -> [Int]
listSpliter 0 = []
listSpliter a = listSpliter (div a 10) ++ [mod a 10]

-- takes two BigNumbers and returns a list with the difference in value of the order of magnitude of the two
lengthDif :: BigNumber -> BigNumber -> [Int]
lengthDif a b   | menor a b == 2 =  [1]
                |otherwise  = aux (length (snd a) - length (snd b)) where
                    aux 0 = [1]
                    aux n = 1 : replicate (n-1) 0

-- takes two positive BigNumbers and calculates the quotient of the divison between them
divSub2 :: BigNumber -> BigNumber -> BigNumber
divSub2 a b = aux a b ('+',lengthDif a b) where
    aux a b ('+',[1])   | menor a b == 2 = ('+',[0])
                        | otherwise = somaBN ('+',[1]) (aux (subBN a b) b ('+',[1]))
    aux a b delta       | menor a (mulBN b delta) == 2 = aux a b ('+', init (snd delta))
                        | otherwise = somaBN delta (aux (subBN a (mulBN delta b)) b delta)

-- calculates the sum of two BigNumbers
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b | fst a == '+' && fst b == '+' = ('+', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
           | fst a == '-' && fst b == '-' = ('-', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
           | maior a b == a =  (fst (maior a b), reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b)))))
           | otherwise = (fst (maior a b), reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a)))))

-- calculates the difference of two BigNumbers
subBN :: BigNumber -> BigNumber -> BigNumber
subBN a b | fst a == '+' && fst b == '-' = ('+', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '-' && fst b == '+' = ('-', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '+' && fst b == '+' && maior a b == a = ('+', takeZeros (reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b))))))
          | fst a == '+' && fst b == '+' && maior a b == b = ('-', takeZeros (reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a))))))
          | fst a == '-' && fst b == '-' && maior a b == a = ('-', takeZeros (reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b))))))
          | fst a == '-' && fst b == '-' && maior a b == b = ('+', takeZeros (reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a))))))

-- calculates the product of two BigNumbers
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a b | fst a == fst b = ('+', reverse (mulAdd (reverse (mulLista (reverse (snd a)) (reverse (snd b))))))
          | otherwise = ('-', reverse (mulAdd (reverse (mulLista (reverse (snd a)) (reverse (snd b))))))

-- calculates the quotient and rest of the divison between two BigNumbers using divSub2
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN a b = let res = divSub2 a b in (res, subBN a (mulBN res b))

-- calculates the division between two BigNumbers and checks for cases of "divide by 0"
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN a b | output b == "0" = Nothing
              | otherwise = Just (divBN a b)
import Prelude
import Data.Char (digitToInt, intToDigit)

type BigNumber = (Char , [Int])

scanner :: String -> BigNumber
scanner a | head a == '-' = ('-', map digitToInt (drop 1 a)) 
          | otherwise = ('+', map digitToInt a)

output :: BigNumber -> String
output a | fst a == '-' = '-' : map intToDigit (snd a)
         | otherwise = map intToDigit (snd a)


somaCheck :: [Int] -> [Int]
somaCheck [x] | x < 10 = [x]
              | otherwise = [x `mod` 10, x `div` 10] 
somaCheck (x:xs) | x < 10 = x : somaCheck xs
                 | otherwise = x `mod` 10 : somaCheck (head xs + x `div` 10 : drop 1 xs)

somaLista :: [Int] -> [Int] -> [Int]
somaLista [] [] = []
somaLista (a:as) [] = a : somaLista as []
somaLista [] (b:bs) = b : somaLista [] bs
somaLista (a:as) (b:bs) = a + b : somaLista as bs

subCheck :: [Int] -> [Int]
subCheck [x] | x == 0 = []
             | x < 0 = [x + 10]
             | otherwise = [x]
subCheck (x:xs) | x < 0 = x + 10 : subCheck (head xs - 1 : drop 1 xs)
                | otherwise  = x : subCheck xs

subLista :: [Int] -> [Int] -> [Int]
subLista [] [] = []
subLista (a:as) [] = a : subLista as []
subLista [] (b:bs) = b : subLista [] bs
subLista (a:as) (b:bs) = a - b : subLista as bs

addZeros :: [Int] -> Int -> [Int]
addZeros a 0 = a
addZeros a n = 0 : addZeros a (n-1)

mulAdd :: [[Int]] -> [Int]
mulAdd [] = [0]
mulAdd (x:xs) = somaCheck (somaLista (addZeros x (length xs)) (mulAdd xs))

mulLista :: [Int] -> [Int] -> [[Int]]
mulLista a = map (\b -> somaCheck (map (*b) a)) 

maiorsame :: BigNumber -> BigNumber -> Int
maiorsame (_, []) (_, []) = 1
maiorsame (a, b:bs) (c, d:ds) | b > d = 1
                              | b < d = 2
                              | otherwise = maiorsame (a, bs) (c, ds) 

maior :: BigNumber -> BigNumber -> BigNumber
maior a b | length (snd a) > length (snd b) = a
          | length (snd a) < length (snd b) = b
          | otherwise = if maiorsame a b == 1 then a else b

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b | fst a == '+' && fst b == '+' = ('+', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
           | fst a == '-' && fst b == '-' = ('-', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
           | maior a b == a =  (fst (maior a b), reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b)))))
           | otherwise = (fst (maior a b), reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a)))))

subBN :: BigNumber -> BigNumber -> BigNumber
subBN a b | fst a == '+' && fst b == '-' = ('+', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '-' && fst b == '+' = ('-', reverse (somaCheck (somaLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '+' && fst b == '+' && maior a b == a = ('+', reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '+' && fst b == '+' && maior a b == b = ('-', reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a)))))
          | fst a == '-' && fst b == '-' && maior a b == a = ('-', reverse (subCheck (subLista (reverse (snd a)) (reverse (snd b)))))
          | fst a == '-' && fst b == '-' && maior a b == b = ('+', reverse (subCheck (subLista (reverse (snd b)) (reverse (snd a)))))

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a b | fst a == fst b = ('+', reverse (mulAdd (reverse (mulLista (reverse (snd a)) (reverse (snd b))))))
          | otherwise = ('-', reverse (mulAdd (reverse (mulLista (reverse (snd a)) (reverse (snd b))))))




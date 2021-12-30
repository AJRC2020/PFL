import Prelude
import Distribution.Compat.CharParsing (integral)
import BigNumber


-- recursive definition of the fibonacci sequence, starting from the base cases 0 and 1
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec(n-2)

-- dynamic definition of the fibonacci sequence, making use of previous values in order to not repeat calculations
fibLista :: Int -> Int
fibLista n = go n (0, 1)
    where
        go n (a, b) | n == 0 = a
                    | otherwise = go (n-1) (b, a + b)

-- definition of an infinit list containing the elements of the fibonacci sequence
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- returns the element of index n from the fibonacci sequence list
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fromIntegral  (fibs !! fromIntegral n)

-- recursive definition of the fibonacci sequence in BigNumber
fibRecBN :: Integral a => a -> BigNumber
fibRecBN 0 = ('+',[0])
fibRecBN 1 = ('+',[1])
fibRecBN n = somaBN a b where
    a = fibRecBN(n-1)
    b = fibRecBN(n-2)

-- dynamic definition of the fibonacci sequence in BigNumber, making use of previous values in order to not repeat calculations
fibListaBN :: Integral a => a -> BigNumber
fibListaBN n = aux n (('+',[0]), ('+',[1])) where
    aux n (a, b)    | n == 0 = a
                    | otherwise = aux (n-1) (b, somaBN a b)

-- returns the element of index n from the BigNumber fibonacci sequence list
fibListaInfinitaBN :: Integral a => a -> BigNumber
fibListaInfinitaBN n = aux !! fromIntegral n where
    aux = ('+',[0]) : ('+',[1]) : zipWith somaBN aux (tail aux)
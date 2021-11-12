import Prelude
import Distribution.Compat.CharParsing (integral)

fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec(n-2)

fibLista :: (Integral a) => a -> a
fibLista n = go n (0, 1)
    where
        go n (a, b) | n == 0 = a
                    | otherwise = go (n-1) (b, a + b)

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fromIntegral  (fibs !! fromIntegral n)
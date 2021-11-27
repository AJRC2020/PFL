import Prelude
import Distribution.Compat.CharParsing (integral)
import BigNumber

fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec(n-2)

fibLista :: Int -> Int
fibLista n = go n (0, 1)
    where
        go n (a, b) | n == 0 = a
                    | otherwise = go (n-1) (b, a + b)

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fromIntegral  (fibs !! fromIntegral n)

fibRecBN :: Integral a => a -> BigNumber
-- fibRecBN :: Integer -> BigNumber
fibRecBN 0 = ('+',[0])
fibRecBN 1 = ('+',[1])
fibRecBN n = somaBN a b where
    a = fibRecBN(n-1)
    b = fibRecBN(n-2)

fibListaBN :: Integral a => a -> BigNumber
fibListaBN n = aux n (('+',[0]), ('+',[1])) where
    aux n (a, b)    | n == 0 = a
                    | otherwise = aux (n-1) (b, somaBN a b)


fibListaInfinitaBN :: Integral a => a -> BigNumber
fibListaInfinitaBN n = aux !! fromIntegral n where
    aux = ('+',[0]) : ('+',[1]) : zipWith somaBN aux (tail aux)
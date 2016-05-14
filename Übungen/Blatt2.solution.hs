-- # Übungsblatt 2
--
-- ## Throat-Clearing
--
-- a.k.a. Imports, damit der Code funktioniert.

import Control.Monad
import Data.Functor
import Data.Monoid

-- ## Functor
--
-- Sie haben in der Vorlesung die Typklasse `Functor` kennengelernt. Zur Erinnerung:
--
--     class Functor f where
--       fmap :: (a -> b) -> f a -> f b
--
-- Nehmen sie an, sie hätten folgende Datentypen gegeben, für die alle eine `Functor`-Instanz existiert und eindeutig ist:

data Identity a = Identity { unIdentity :: a }

instance Functor Identity where
        fmap f (Identity a) = Identity (f a)

data Vielleicht a = Etwas a
                  | Nichts

instance Functor Vielleicht where
        fmap f (Etwas a) = Etwas (f a)
        fmap f Nichts    = Nichts

data EntwederOder b a = Entweder a
                      | Oder b

instance Functor (EntwederOder c) where
        fmap f (Entweder a) = Entweder (f a)
        fmap _ (Oder b)     = Oder b

data GameVector b a = V3 a a a
                    | VStrange [a]
                    | Neighbours [GameVector b a]
                    | EntwederOder b (GameVector b a)

instance Functor (GameVector c) where
        fmap f (V3 x y z) = V3 (f x) (f y) (f z)
        fmap f (VStrange l) = VStrange (f <$> l)
        fmap f (Neighbours l) = Neighbours (fmap f <$> l)
        fmap f (EntwederOder b v) = EntwederOder b (f <$> v)

-- Schreiben sie hierzu die jeweiligen `Functor`-Instanzen.
--
-- ## Besser und allgemeiner
--
-- Vereinfachen und verallgemeinern sie folgenden Ausdrücke so weit wie möglich und geben die sie dadurch entstehenden Typsignaturen an.
-- Bedenken sie, dass wenn sie auf eine Typklasse abstrahieren, sie die gesamten Gesetze der Typklasse benutzen können.
--
-- Kann die Funktion nachher mehr als vorher?
--
-- *Bonus*: Hat sich an der Laufzeit etwas verändert?

mystery1 :: [[a]] -> [[a]]
mystery1 = map (++[])

-- List is Functor => fmap instead of map
mystery1' :: Functor f => f [a] -> f [a]
mystery1' = fmap (++[])

-- List is a Monoid => ++ == <> && [] == mempty
mystery1'' :: (Functor f, Monoid m) => f m -> f m
mystery1'' = fmap (<> mempty)

-- Monoid-Law: (<> mempty) == id
mystery1''' :: Functor f => f a -> f a
mystery1''' = fmap id

-- Functor-Law: fmap id == id
mystery1'''' :: a -> a
mystery1'''' = id

mystery2 :: (Eq a) => a -> a -> a -> Bool
mystery2 x y z
  | x == y || y == z = True
  | otherwise        = False

mystery3 :: (MonadPlus f, Eq a) => (a -> a) -> a -> f a -> f a
mystery3 f a l = mfilter (==a) (f <$> l)

mystery3' :: Eq a => (a -> a) -> a -> [a] -> [a]
mystery3' f a l = filter (==a) (f <$> l)
   --      post a l'
   -- where
   --   l' = map f l
   --   post a (x:xs)
   --       | a == x    = x : post a xs
   --       | otherwise =     post a xs
   --   post _ [] = []

mystery4 :: (Int -> Bool)
         -> Vielleicht (EntwederOder String Int)
         -> Vielleicht (EntwederOder String Bool)
mystery4 f (Etwas (Entweder a)) = Etwas . Entweder . f $ a
mystery4 _ (Etwas (Oder b))     = Etwas (Oder b)
mystery4 _  Nichts              = Nichts

mystery4'' :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
mystery4'' f ve = fmap (fmap f) ve

mystery4' :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
mystery4' = fmap . fmap

-- ## Bonus
--
-- Es gibt von dem bekannten Spiel 2048 eine Haskell-Implementation für die Kommandozeile in unter 100 Zeilen. Diese ist zu finde unter
-- https://github.com/gregorulm/h2048/blob/master/h2048.hs
--
-- Sie können diesen Code mit `GHC` kompilieren oder im `ghci` ausführen (`main` ist die Start-Funktion).
--
-- Was für Prinzipielle Vorgehenspunkte können sie erkennen?
-- Eine kleine Erklärung gibt es im Blog der Erstellers: http://gregorulm.com/2048-in-90-lines-haskell/
--
-- Keine Angst, sie müssen dies noch nicht verstehen, aber es soll verdeutlichen, wie viel man mit extrem wenig erreichen kann. Viele der Abgabeprojekte werden in dieser Größenordnung liegen (aber meist noch so etwas wie ein GUI o.ä. benötigen). Versuchen sie einfach den Code kaputtzuspielen (z.b. Tasten ändern, Siegbedingung ändern, Cheats einbauen, ...).
--
-- Viel Spass beim Spielen! :)

main = putStrLn "compiles"

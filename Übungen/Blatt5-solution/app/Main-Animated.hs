module Main where

import Parser
import GUI
import Types
import Data.ByteString as BS
import Data.Array
import Data.Time
import Data.Word
import Graphics.Gloss
import Data.Monoid

datafile :: String
datafile = "time_ip.csv"

mainAnimate :: IO ()
mainAnimate = do
        df <- BS.readFile datafile
        let pd = ipBuckets <$> parseData df
        case pd of
          Right pd' -> animate (InWindow "Animation" (800,600) (100,200)) white (animateGrid 240 200 pd')
          Left err  -> print $ "parsing Error:" <> err

main :: IO ()
main = mainAnimate

ipBuckets :: [Data] -> Array (Word8,Word8,Int) Int
ipBuckets d = accumArray (+) 0 ((0,0,0),(15,15,23)) (f <$> d)
        where
                f (Data _ (TimeOfDay h m _) (IPv4 a _ _ _)) = ((a `div` 16, a `mod` 16, h), 1)

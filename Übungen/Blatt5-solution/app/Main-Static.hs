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

mainStatic :: IO ()
mainStatic = do
        df <- BS.readFile datafile
        let pd = hourBuckets <$> parseData df
        case pd of
          Right pd' -> display (InWindow "Bar Chart" (800,600) (100,200)) white (drawBar 240 200 pd')
          Left err  -> print $ "parsing Error:" <> err

main :: IO ()
main = mainStatic

hourBuckets :: [Data] -> Array Int Int
hourBuckets d = accumArray (+) 0 (0,23) (f <$> d)
        where
                f (Data _ (TimeOfDay h _ _) _) = (h,1)

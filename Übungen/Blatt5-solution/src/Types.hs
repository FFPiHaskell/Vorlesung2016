module Types where

import Data.Word
import Data.Time

data Data = Data
          { date :: Day
          , time :: TimeOfDay
          , ip   :: IPv4
          }
          deriving (Show, Eq)

data IPv4 = IPv4 Word8 Word8 Word8 Word8
        deriving (Show, Eq)

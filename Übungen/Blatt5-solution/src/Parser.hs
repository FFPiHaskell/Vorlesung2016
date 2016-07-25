module Parser 
        
       (parseData)

       where

import qualified Data.ByteString as BS
import Data.Attoparsec.ByteString
import Data.Attoparsec.ByteString.Char8 (isHorizontalSpace, char, endOfLine, decimal, digit)
import Data.Time (Day(..), TimeOfDay(..), makeTimeOfDayValid, fromGregorianValid)
import Types


parseData :: BS.ByteString -> Either String [Data]
parseData = parseOnly parserData

parserData :: Parser [Data]
parserData = many' parseDatapoint


parseDatapoint :: Parser Data
parseDatapoint = do
        skipWhile isHorizontalSpace
        d <- parseDay
        char 'T'
        t <- parseTime
        char 'Z'
        skipWhile isHorizontalSpace
        char ','
        skipWhile isHorizontalSpace
        ip <- parseIP
        skipWhile isHorizontalSpace
        endOfLine
        return $ Data d t ip

parseDay :: Parser Day
parseDay = do
        y <- count 4 digit
        char '-'
        m <- count 2 digit
        char '-'
        d <- count 2 digit
        case fromGregorianValid (read y) (read m) (read d) of
          (Just d) -> return d
          Nothing  -> fail "Incorrect Date"


parseTime :: Parser TimeOfDay
parseTime = do
        h <- count 2 digit
        char ':'
        m <- count 2 digit
        char ':'
        s <- count 2 digit
        case makeTimeOfDayValid (read h) (read m) (read s) of
          (Just t) -> return t
          Nothing  -> fail "Incorrect Time"

parseIP :: Parser IPv4
parseIP = do
        a <- decimal
        char '.'
        b <- decimal
        char '.'
        c <- decimal
        char '.'
        d <- decimal
        return $ IPv4 a b c d


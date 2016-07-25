module GUI where

import Data.Array
import Graphics.Gloss
import Data.Word

type Height = Int
type Width = Int

drawBar :: Width -> Height -> Array Int Int -> Picture
drawBar w h a = Pictures $ draw <$> [0..num]
        where
                num = u - l
                (l, u) = bounds a
                w' :: Float
                w' = fromIntegral w / fromIntegral num
                h' :: Float
                h' = fromIntegral h / fromIntegral (maximum $ elems a)
                draw :: Int -> Picture
                draw i = Translate (w'*i') 0 $ -- translate the whole bar
                         Pictures [ Color blue $ Polygon [(0,0), (0, h''), (w', h''), (w', 0)] -- draw bar
                                  , Translate 0 (-10) $ Scale 0.05 0.05 $ Text (show i) -- draw caption
                                  ]
                        where
                                i' = fromIntegral i
                                h'' = fromIntegral (a!i) * h'

animateGrid :: Width -> Height -> Array (Word8, Word8, Int) Int -> Float -> Picture
animateGrid w h d f = Pictures $ draw <$> [0..l1] <*> [0..l2]
        where
              (_, (l1, l2, t)) = bounds d
              maxVal :: Float
              maxVal = fromIntegral . maximum . elems $ d
              draw :: Word8 -> Word8 -> Picture
              draw x y = Translate (w'*fromIntegral x) (h'*fromIntegral y) $
                         Pictures [ Color (mixColors val (maxVal-val) red green) $ rectangleSolid w' h'
                                  , Scale 0.05 0.05 . Text . show . round $ val
                                  ]
                                          where
                                                  val = fromIntegral $ d!(x,y,f')
              w' :: Float
              w' = fromIntegral w / fromIntegral l1
              h' :: Float
              h' = fromIntegral h / fromIntegral l2
              f' = floor f `mod` t


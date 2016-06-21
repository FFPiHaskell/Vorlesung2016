import Data.Monoid
import Graphics.Gloss
import Graphics.Gloss.Data.Color (makeColor, red)

main :: IO ()
main = animate (InWindow "Spin around" (500,500) (100,100))
               (makeColor 0.9 0.9 0.9 1)
               (\time -> 
                Pictures [ Color red $ ThickCircle 500 1000
                         , Rotate (time/60*360)
                           $ Text
                           $ show (round time) <> " Seconds"
                         ])

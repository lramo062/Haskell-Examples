{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import qualified Data.ByteString.Lazy as B
-- import Network.HTTP.Conduit (simpleHttp)
import Data.Aeson
import Data.Text
import GHC.Generics

data Person =
  Person { firstName  :: !Text
         , lastName   :: !Text
         , age        :: Int
         , likesPizza :: Bool
           } deriving (Show,Generic)

instance FromJSON Person
instance ToJSON Person

-- jsonURL :: String
-- jsonURL = "http://daniel-diaz.github.io/misc/pizza.json"

-- getJSON :: IO B.ByteString
-- getJSON = simpleHttp jsonURL

main = do

  -- creating JSON data
  let person1 = Person "Lester" "Ramos" 21 True
  let person2 = Person "Caty" "Gonzalez" 21 True
  let person3 = Person "Adam" "Tahoun" 23 True
  let json = fmap encode [person1, person2, person3]

  -- parsing the JSON data back to an Object
  let parsedJson = mapM decode json :: Maybe [Person]
  print parsedJson

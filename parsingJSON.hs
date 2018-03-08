{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import Data.Aeson
import Data.Text
import GHC.Generics
import Data.Maybe

data Person =
  Person { firstName  :: !Text
         , lastName   :: !Text
         , age        :: Int
         , likesPizza :: Bool
           } deriving (Show,Generic)

instance FromJSON Person
instance ToJSON Person

jsonURL :: String
jsonURL = "http://daniel-diaz.github.io/misc/pizza.json"

getJSON :: IO B.ByteString
getJSON = simpleHttp jsonURL

under25YO = (\x -> (age x) < 25)

main = do

  -- creating JSON data
  -- let person1 = Person "Lester" "Ramos" 21 True
  -- let person2 = Person "Caty" "Gonzalez" 21 True
  -- let person3 = Person "Adam" "Tahoun" 23 True
  -- let json = fmap encode [person1, person2, person3]
  -- print json

  -- parsing the JSON data back to an Object
  -- let parsedJson = mapM decode json :: Maybe [Person]
  -- print parsedJson

  -- fetching JSON data (using show to turn the ByteString to a String and then encode)
  response <- getJSON
  let json = encode $ show response
  let parsedResponse = decode response :: Maybe [Person]
  let youngPeople = Prelude.filter under25YO $ fromJust parsedResponse
  print youngPeople
  

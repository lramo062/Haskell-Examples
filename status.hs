{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as BS
import Network.HTTP.Client
import Data.Aeson
import Data.Text
import GHC.Generics
import Data.Maybe

-- define necessary data types
data Metric = Metric { metric_status :: !Text } deriving (Show,Generic) 
data Group = Group { slug :: !Text, status :: Metric } deriving (Show,Generic)

instance FromJSON Metric
instance ToJSON Metric
instance FromJSON Group
instance ToJSON Group

request_url :: String
request_url = "http://bakery-server.apps.mia.ulti.io/graphql?"

request_method :: BS.ByteString
request_method = "POST"

-- helper functions
buildRequest :: String -> RequestBody -> IO Request
buildRequest url body = do
  nakedRequest <- parseRequest url
  return (nakedRequest { method = request_method, requestBody = body })

send :: String -> RequestBody -> IO ()
send url s = do
  manager <- newManager defaultManagerSettings
  request <- buildRequest url s
  response <- httpLbs request manager
  print (responseBody response)
  -- let Just obj = decode (responseBody response)
  -- print (obj :: Object)

-- entry point
main = do
  send request_url  "--data { query { groups { slug, metrics { status }}}}"
  print "TEst"
  -- creating JSON data
  -- let group1 = Group "group1" $ Metric "red"
  -- let group2 = Group "group2" $ Metric "green"
  -- let group3 = Group "group3" $ Metric "red"
  -- let json = fmap encode [group1, group2, group3]
  -- print json

  -- parsing the JSON data back to an Object
  -- let parsedJson = mapM decode json :: Maybe [Group]
  -- print parsedJson

  -- fetching JSON data (using show to turn the ByteString to a String and then encode)
  -- response <- getJSON
  -- let json = encode $ show response
  -- let parsedResponse = decode response :: Maybe [Person]
  -- let youngPeople = Prelude.filter under25YO $ fromJust parsedResponse
  -- print youngPeople
  

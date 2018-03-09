{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import qualified Data.ByteString.Lazy.Char8 as L8
import Data.ByteString.Internal as BS
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status  (statusCode)
import qualified Data.HashMap.Strict as M
import Data.Aeson
import Data.Text
import GHC.Generics
import Data.Maybe
import Data.Typeable

-- define necessary data types
data Metric = Metric { metric_status :: !Text } deriving (Show,Generic) 
data Group = Group { slug :: !Text, status :: Metric } deriving (Show,Generic)

instance FromJSON Metric
instance FromJSON Group

request_url :: String
request_url = "URL_GOES_HERE"

request_method :: BS.ByteString
request_method = "POST"

request_query :: String
request_query = "query {groups {slug metrics { status } } }"

request_headers = [("Content-Type", "application/json; charset=utf-8")]

(^?) :: Value -> Text -> Maybe Value
(^?) (Object obj) k = M.lookup k obj
(^?) _ _ = Nothing
  
-- entry point
main :: IO ()
main = do
    manager <- newManager tlsManagerSettings
    -- Create the request
    let requestObject = object
            [ "query" .= request_query
            ]
    initialRequest <- parseRequest request_url
    let request = initialRequest
            { method = request_method
            , requestBody = RequestBodyLBS $ encode requestObject
            , requestHeaders = request_headers }
    response <- httpLbs request manager
    putStrLn $ "The status code was: "
            ++ show (statusCode $ responseStatus response)
    let json = decode (responseBody response) :: Maybe Value
    let groups = (fromJust (fromJust json ^? "data") ^? "groups")
    print groups
    
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
  

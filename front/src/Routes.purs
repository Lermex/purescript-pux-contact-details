module App.Routes where

import Data.Functor ((<$), (<$>))
import Data.Maybe (fromMaybe)
import Control.Alt ((<|>))
import Control.Apply ((<*), (*>))
import Prelude (($))
import Pux.Router (end, router, int, lit)

data Route = Home | User Int | NotFound

match :: String -> Route
match url = fromMaybe NotFound $ router url $
  Home <$ end
  <|>
  User <$> (lit "users" *> int) <* end

module App.User where

import Prelude
import Data.Argonaut (class DecodeJson, decodeJson, (.?))

newtype User = User
  { email :: String
  , name  :: String }

instance decodeJsonUser :: DecodeJson User where
  decodeJson json = do
    obj <- decodeJson json
    email <- obj .? "email"
    name  <- obj .? "name"
    pure $ User { email: email, name: name }

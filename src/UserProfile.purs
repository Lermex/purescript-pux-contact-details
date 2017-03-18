module App.UserProfile where

import Data.Semigroup ((<>))
import Prelude hiding (div)
import Data.Maybe
import Data.Either
import Pux.Html (Html, img, h2, div, span, button, text)
import Pux.Html.Attributes (src)
import Gravatar as Gravatar
import Pux (EffModel, noEffects)
import Network.HTTP.Affjax (AJAX, get)
import Control.Monad.Aff (attempt)
import Data.Argonaut (decodeJson)
-- import Pux.Html.Events (onClick)

import App.User

data Action = RequestUser Int | ReceiveUser (Either String User)

type State = {
  displayedUser :: Either String User }

init :: State
init = {displayedUser: Left "No user yet"}

update :: Action -> State -> EffModel State Action (ajax :: AJAX)
update (RequestUser i) state = 
  { state: state {displayedUser = Left "Requesting user"}
  , effects: [ do
      res <- attempt $ get ("http://localhost:5000/users/" <> show i)
      let decode r = decodeJson r.response :: Either String User
      pure $ ReceiveUser (either (Left <<< show) decode res)
    ]
  }
update (ReceiveUser x) state = 
  noEffects $ state {displayedUser = x}

{-
view :: State -> Html Action
view state =
  div
    []
    [ button [ onClick (const Increment) ] [ text "Increment" ]
    , span [] [ text (show state) ]
    , button [ onClick (const Decrement) ] [ text "Decrement" ]
    ]
-}

view :: State -> Html Action
view state = case state.displayedUser of
  Left err -> text err
  Right (User user) ->
    div
      []
      [ h2 [] [ text user.name ]
      , text user.email
      , img [ src (Gravatar.url user.email) ] []
      ]

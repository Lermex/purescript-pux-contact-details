module App.Layout where

import App.Counter as Counter
import App.UserProfile as UserProfile
import App.NotFound as NotFound
import App.Routes as Route
import App.Routes (Route)

import Pux (EffModel, noEffects, mapState, mapEffects)
import Network.HTTP.Affjax (AJAX, get)

import Prelude hiding (div)
import Data.Maybe (Maybe(..))
import Data.Map as Map
import Data.Map (Map)
import Pux.Html (Html, img, div, h1, h2, p, text, nav, ul, li)
import Pux.Router (link)
import Data.Argonaut (class DecodeJson, decodeJson, (.?))


data Action
  = CounterChild (Counter.Action)
  | UserProfileChild (UserProfile.Action)
  | PageView Route

type State =
  { route       :: Route
  , count       :: Counter.State
  , userProfile :: UserProfile.State }

init :: State
init =
  { route: Route.NotFound
  , count: Counter.init
  , userProfile: UserProfile.init }

update :: forall eff. Action -> State -> EffModel State Action (ajax :: AJAX | eff)
update (PageView route) state =
  noEffects $ state { route = route }
update (CounterChild action) state =
  noEffects $ state { count = Counter.update action state.count }
update (UserProfileChild action) state = do
  mapEffects UserProfileChild $
  mapState (\x -> state { userProfile = x }) $
    UserProfile.update action state.userProfile

view :: State -> Html Action
view state =
  div
    []
    [ navigation
    , h1 [] [ text "Pux Starter App" ]
    , p [] [ text "Change src/Layout.purs and watch me hot-reload." ]
    , case state.route of
        Route.Home ->
          map CounterChild $ Counter.view state.count
        Route.User n ->
          map UserProfileChild $ UserProfile.view state.userProfile
        Route.NotFound ->
          NotFound.view state
    ]

navigation :: Html Action
navigation =
  nav
    []
    [ ul
      []
      [ li [] [ link "/" [] [ text "Home" ] ]
      , li [] [ link "/users" [] [ text "Users" ] ]
      , li [] [ link "/users?sortBy=age" [] [ text "Users sorted by age." ] ]
      , li [] [ link "/users/123" [] [ text "User 123" ] ]
      , li [] [ link "/foobar" [] [ text "Not found" ] ]
      ]
    ]

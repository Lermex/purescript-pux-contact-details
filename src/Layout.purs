module App.Layout where

import App.Counter as Counter
import App.NotFound as NotFound
import App.Routes (Route(..))
import Prelude (($), map)
import Data.Maybe (Maybe(..))
import Data.Map as Map
import Data.Map (Map)
import Pux.Html (Html, img, div, h1, h2, p, text, nav, ul, li)
import Pux.Router (link)

data Action
  = Child (Counter.Action)
  | PageView Route

type User =
  { email :: String
  , name  :: String }

type State =
  { route :: Route
  , count :: Counter.State
  , users :: Map Int User }

init :: State
init =
  { route: NotFound
  , count: Counter.init
  , users: Map.singleton 123 { email: "yom@artyom.me", name: "Artyom" } }

update :: Action -> State -> State
update (PageView route) state = state { route = route }
update (Child action) state = state { count = Counter.update action state.count }

view :: State -> Html Action
view state =
  div
    []
    [ navigation
    , h1 [] [ text "Pux Starter App" ]
    , p [] [ text "Change src/Layout.purs and watch me hot-reload." ]
    , case state.route of
        Home -> map Child $ Counter.view state.count
        User n -> case Map.lookup n state.users of
          Just user -> viewUser user
          Nothing   -> text "User not found"
        NotFound -> NotFound.view state
    ]

viewUser :: User -> Html Action
viewUser user =
  div
    []
    [ h2 [] [ text user.name ]
    , text user.email
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

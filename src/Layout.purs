module App.Layout where

import App.Counter as Counter
import App.NotFound as NotFound
import App.Routes (Route(Home, NotFound))
import Prelude (($), map)
import Pux.Html (Html, div, h1, p, text, nav, ul, li)
import Pux.Router (link)

data Action
  = Child (Counter.Action)
  | PageView Route

type State =
  { route :: Route
  , count :: Counter.State }

init :: State
init =
  { route: NotFound
  , count: Counter.init }

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
        NotFound -> NotFound.view state
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

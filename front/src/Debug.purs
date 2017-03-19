module Debug where

import Prelude
import Data.Unit

foreign import log :: forall a. a -> Unit

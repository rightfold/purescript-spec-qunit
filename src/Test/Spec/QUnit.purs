module Test.Spec.QUnit
  ( QUNIT
  , runQUnit
  ) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (kind Effect, Eff)
import Data.Foldable (traverse_)
import Prelude
import Test.Spec (Group(..), Spec, collect)

foreign import data QUNIT :: Effect

runQUnit
  :: ∀ eff
   . Spec (qunit :: QUNIT | eff) Unit
  -> Eff (qunit :: QUNIT | eff) Unit
runQUnit = traverse_ registerGroup <<< collect

registerGroup
  :: ∀ eff
   . Group (Aff (qunit :: QUNIT | eff) Unit)
  -> Eff (qunit :: QUNIT | eff) Unit
registerGroup (It only name test) =
  (if only then ffiOnly else ffiTest) name test
registerGroup (Pending name) = ffiSkip name
registerGroup (Describe only name groups) =
  -- TODO: only
  ffiModule name (traverse_ registerGroup groups)

foreign import ffiModule
  :: ∀ eff
   . String
  -> Eff (qunit :: QUNIT | eff) Unit
  -> Eff (qunit :: QUNIT | eff) Unit

foreign import ffiTest
  :: ∀ eff
   . String
  -> Aff (qunit :: QUNIT | eff) Unit
  -> Eff (qunit :: QUNIT | eff) Unit

foreign import ffiOnly
  :: ∀ eff
   . String
  -> Aff (qunit :: QUNIT | eff) Unit
  -> Eff (qunit :: QUNIT | eff) Unit

foreign import ffiSkip
  :: ∀ eff
   . String
  -> Eff (qunit :: QUNIT | eff) Unit

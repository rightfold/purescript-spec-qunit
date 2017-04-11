module Test.Main where

import Control.Monad.Aff (delay)
import Control.Monad.Eff (Eff)
import Data.Time.Duration (Milliseconds(..))
import Prelude
import Test.Spec (SpecEffects, describe, it, pending)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QUnit (QUNIT, runQUnit)

main :: Eff (SpecEffects (qunit :: QUNIT)) Unit
main = runQUnit do
  describe "test" $
    describe "nested" do
      it "works" $
        (1 + 1) `shouldEqual` 2
      pending "is pending"

  describe "test" $
    describe "other" do
      it "breaks" $ 1 `shouldEqual` 2

  describe "async" do
    it "works" $ do
      expected <- 2 <$ delay (Milliseconds 1000.0)
      (1 + 1) `shouldEqual` expected
    it "and can fail" do
      expected <- 3 <$ delay (Milliseconds 1000.0)
      (1 + 1) `shouldEqual` expected

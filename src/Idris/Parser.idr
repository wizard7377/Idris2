module Idris.Parser

import Core.Options
import Core.Metadata
import Idris.Syntax
import Idris.Syntax.Traversals
import public Idris.Grammar.Source
import TTImp.TTImp

import public Libraries.Text.Parser
import Data.Either
import Libraries.Data.IMaybe
import Data.List
import Data.List.Quantifiers
import Data.List1
import Data.Maybe
import Data.So
import Data.Nat
import Data.SnocList
import Data.String
import Libraries.Utils.String
import Libraries.Data.WithDefault

import Idris.Parser.Let
import public Idris.Parser.Basic
import public Idris.Parser.Source
import public Idris.Parser.Repl
%default covering


%hide Prelude.(>>)
%hide Prelude.(>>=)
%hide Core.Core.(>>)
%hide Core.Core.(>>=)
%hide Prelude.pure
%hide Core.Core.pure
%hide Prelude.(<*>)
%hide Core.Core.(<*>)


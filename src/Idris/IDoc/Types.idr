module Idris.IDoc.Types

import Core.Name
record Page where
  constructor MkPage
  title : Maybe String
  path : Namespace

data TextStyle = DItalic | DBold | DUnderline | DCode | DHighlight String | DMath
mutual
  data DLink : Type where
    DUrl : (url : String) -> (desc : Maybe IDoc) -> DLink
    DItem : (item : Name) -> (desc : Maybe IDoc) -> DLink
    DPage : (page : Page) -> (desc : Maybe IDoc) -> DLink
    DInternal : (id : String) -> (desc : Maybe IDoc) -> DLink
  data IDoc : Type where
    DText : List TextStyle -> String -> IDoc
    DConcat : List IDoc -> IDoc
    DLinked : DLink -> IDoc
data DClause : Type where
  Expositition : (doc : IDoc) -> DClause





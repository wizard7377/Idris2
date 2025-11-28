# Explicit Omega Multiplicity Syntax

- [x] I have read [CONTRIBUTING.md](https://github.com/idris-lang/Idris2/blob/main/CONTRIBUTING.md).
- [x] I have checked that there is no existing PR/issue about my proposal.

## Summary

Add explicit omega multiplicity syntax using `*`, such that `(* x : a) -> b` is equivalent to `(x : a) -> b`. This provides a way to explicitly annotate unrestricted usage when desired, mirroring the existing explicit annotations for erased (`0`) and linear (`1`) multiplicities.

## Motivation

Currently, Idris2 supports explicit multiplicity annotations:
- `0` for erased (compile-time only, cannot be used at runtime)
- `1` for linear (must be used exactly once)

The default multiplicity (omega/unrestricted) has no explicit syntax - it is simply the absence of a multiplicity annotation. While this works well in practice, there are scenarios where explicit annotation of unrestricted multiplicity improves code clarity:

1. **Documentation purposes**: When teaching or documenting quantitative type theory concepts, having explicit syntax for all three multiplicities makes examples more uniform and educational.

2. **Consistency**: Having explicit syntax for all multiplicities (`0`, `1`, and `*`) creates a complete and symmetric notation system.

3. **Readability in mixed contexts**: In code that uses various multiplicities, being able to explicitly mark unrestricted arguments can improve readability by making the intent clear.

## The proposal

Introduce `*` as an explicit syntax for omega (unrestricted) multiplicity in the parser. This is purely a syntactic addition with no semantic changes - `(* x : a) -> b` would parse identically to `(x : a) -> b`.

### Examples

```idris
-- Current syntax (implicit omega)
foo : (x : Nat) -> (y : Nat) -> Nat

-- Proposed explicit syntax
foo : (* x : Nat) -> (* y : Nat) -> Nat

-- Mixed multiplicities become more readable
bar : (0 unused : Type) -> (1 consume : Resource) -> (* keep : Nat) -> Nat

-- Lambda expressions
\* x => x + 1

-- Let bindings
let * y = 5 in y * 2
```

### Technical implementation

The implementation requires only a modification to the `multiplicity` parser in `src/Idris/Parser.idr`. Currently, the parser handles `0`, `1`, and defaults to `top` (omega):

```idris
multiplicity : OriginDesc -> EmptyRule RigCount
multiplicity fname
    = case !(optional $ decorate fname Keyword intLit) of
        (Just 0) => pure erased
        (Just 1) => pure linear
        Nothing => pure top
        _ => fail "Invalid multiplicity (must be 0 or 1)"
```

The proposed change would add handling for the `*` symbol by first attempting to parse it before falling back to the current behavior:

```idris
multiplicity : OriginDesc -> EmptyRule RigCount
multiplicity fname
    = (decoratedSymbol fname "*" $> top)
  <|> case !(optional $ decorate fname Keyword intLit) of
        (Just 0) => pure erased
        (Just 1) => pure linear
        Nothing => pure top
        _ => fail "Invalid multiplicity (must be 0, 1, or *)"
```

This change is minimal and localized to the parser - no changes to the type theory, elaboration, or other parts of the compiler are required.

## Alternatives considered

1. **Using `ω` (omega symbol)**: While mathematically accurate, this would require Unicode input which is less accessible for many users. The `*` symbol is more universally available on keyboards.

2. **Using a keyword like `many` or `unrestricted`**: This would be more verbose and inconsistent with the numeric syntax used for `0` and `1`.

3. **Status quo**: Keeping the implicit-only syntax for omega is a valid option, but offering explicit syntax provides additional flexibility without breaking any existing code.

## Conclusion

Adding `*` as explicit omega multiplicity syntax is a minimal, backwards-compatible enhancement that improves the expressiveness and consistency of Idris2's quantitative type annotations. The implementation is straightforward, requiring only a small parser modification, and the feature would be valuable for documentation, teaching, and code clarity purposes.

# foma.hs

Haskell bindings for the [Foma](https://en.wikipedia.org/wiki/Foma_(software)) library.

## Installation

You must have [Foma](https://code.google.com/p/foma/) installed.

```
cabal install foma
```

## Example

```haskell
import Language.Foma

main = do
   fsm <- fsmReadBinaryFile "../TRmorph/trmorph.fst"
   let handle = applyInit fsm
   print (applyUp handle "okudum")
```

## License

[MIT](https://github.com/joom/foma.hs/blob/master/LICENSE)

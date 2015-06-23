{-# LANGUAGE ForeignFunctionInterface #-}

-- | Simple Haskell bindings for Foma.
--
-- Here's a simple example on how to use it.
--
-- @
-- import "Language.Foma"
--
-- main = do
--    fsm <- "fsmReadBinaryFile" "../TRmorph/trmorph.fst"
--    let handle = 'applyInit' fsm
--    'print' ('applyUp' handle "okudum")
-- @
module Language.Foma
  ( FSM ()
  , ApplyHandle ()
  , fsmReadBinaryFile
  , applyInit
  , applyClear
  , applyDown
  , applyUp
  ) where

import Control.Monad
import Foreign.C
import Foreign.Ptr
import System.IO.Unsafe (unsafePerformIO)

-- | The type for a finite state machine. Wrapper for a pointer.
newtype FSM = FSM (Ptr ())
-- | The low level handle. Wrapper for a pointer.
newtype ApplyHandle = ApplyHandle (Ptr ())

foreign import ccall unsafe "fomalib.h fsm_read_binary_file"
  fsmReadBinaryFile' :: CString -> IO FSM

-- | The function to read the binary file with.
fsmReadBinaryFile :: FilePath -> IO FSM
fsmReadBinaryFile = newCString >=> fsmReadBinaryFile'

-- | To be called before applying words.
foreign import ccall unsafe "fomalib.h apply_init"
  applyInit :: FSM -> ApplyHandle

-- | Frees memory alloced by applyInit.
foreign import ccall unsafe "fomalib.h apply_clear"
  applyClear :: ApplyHandle -> IO ()

foreign import ccall unsafe "fomalib.h apply_down"
  applyDown' :: ApplyHandle -> CString -> CString

-- | Words entered are applied against the network on the top of the stack.
applyDown :: ApplyHandle -> String -> String
applyDown h s = unsafePerformIO $ fmap (applyDown' h) (newCString s) >>= peekCString

foreign import ccall unsafe "fomalib.h apply_up"
  applyUp' :: ApplyHandle -> CString -> CString

-- | Words entered are applied against the network on the top of the stack in inverse direction.
applyUp :: ApplyHandle -> String -> String
applyUp h s = unsafePerformIO $ fmap (applyUp' h) (newCString s) >>= peekCString

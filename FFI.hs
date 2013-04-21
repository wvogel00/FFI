module FFI where

import Foreign.StablePtr
import Foreign.C.String

data Token = Play Int | Repeat Int | Stop
type Commands = [Token]

foreign export ccall hGetCommands :: CString -> IO (StablePtr Commands)
hGetCommands s = peekCString s >>= newStablePtr.parse.lines

parse [] = []
parse (str:strs)
	| take 4 str == "play" = Play (read $ drop 5 str):parse strs
	| take 6 str == "repeat" = Repeat (read $ drop 7 str):parse strs
	| take 4 str == "stop" = Stop:parse strs

foreign export ccall hTakeToken :: StablePtr Commands -> Int -> IO (StablePtr Token)
hTakeToken comm n = deRefStablePtr comm >>= \c -> newStablePtr (c!!n)

foreign export ccall hIsStop :: StablePtr Token -> IO Int
hIsStop token = deRefStablePtr token >>= return.f where
	f Stop = 1
	f _ = 0

foreign export ccall hIsPlay :: StablePtr Token -> IO Int
hIsPlay token = deRefStablePtr token >>= return.f where
	f (Play n) = n
	f _ = -1

foreign export ccall hIsRepeat :: StablePtr Token -> IO Int
hIsRepeat token = deRefStablePtr token >>= return.f where
	f (Repeat n) = n
	f _ = -1

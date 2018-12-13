data RE a
    = Sym a
    | Empty
    | RE a :+: RE a
    | RE a :|: RE a
    | Rep (RE a)
    | Rep1 (RE a)
    deriving (Show)


optional :: RE a -> RE a
optional r = r :|: Empty


-- (a|b)*
abstar = Rep (Sym 'a' :|: Sym 'b')

-- aa+
twoas = Sym 'a' :+: Rep1 (Sym 'a')

match ::(Eq a) => RE a -> [a] -> Bool
match r l = any (null . snd) (fmatches r True l)
    -- if we got at least one match with no leftovers, then the string
    -- matches the RE


-- first attempt at a helper function
matchhelp :: (Eq a)
    => RE a        -- regular expression to match
    -> [a]         -- input string
    -> (Bool, [a]) -- whether some prefix matched, and the leftovers after matching
matchhelp Empty l = (True, l)
matchhelp (Sym a) [] = (False, [])
matchhelp (Sym a) (b:bs)
    | a == b = (True, bs)
    | otherwise = (False, [])
matchhelp (r :+: s) list = (m1 && m2, l2)
    where
    (m1, l1) = matchhelp r list
    (m2, l2) = matchhelp s l1
matchhelp (r :|: s) list = (m1 || m2, if m1 then l1 else l2)
    where
    (m1, l1) = matchhelp r list
    (m2, l2) = matchhelp s list



-- second attempt at a helper function
matches :: (Eq a)
    => RE a   -- regular expression to match
    -> [a]    -- input string
    -> [[a]]  -- all possible leftovers following a successful match
              -- empty list means no successes
matches Empty l = [l]
matches (Sym a) (b:bs) | a == b = [bs]
matches (Sym a) l = []
matches (r :|: s) l = matches r l ++ matches s l
matches (r :+: s) l =
--        [ l2 | l1 <- matches r l, l2 <- matches s l1 ]
         concatMap (matches s) (matches r l)
matches (Rep r) l = l :
    concatMap (matches (Rep r)) (matches r l)
matches (Rep1 r) l =
    concatMap (matches (Rep r)) (matches r l)

-- [ l2 | l1 <- matches r l, l2 <- matches (Rep r) l1 ]


-- (a|e)a
re_aea = (Sym 'a' :|: Empty) :+: Sym 'a'

-- matchhelp re_aea "a" = (False,"")
-- matches re_aea "a"   = [""]
--
-- matchhelp matches the a against the first Sym 'a', then isn't able to match
-- the second one. matches tries both alternatives, and discards those that fail


-- third attempt at a helper function
-- this version is more complicated, but it avoids producing infinitely
-- many results
fmatches :: (Eq a)
    => RE a   -- regular expression to match
    -> Bool   -- is matching an empty string allowed?
    -> [a]    -- input string
    -> [(Bool, [a])] -- list of possible results, if any
        -- each result includes
        -- 1. whether the match consumed any input
        -- 2. the leftover symbols not consumed by the match

-- Empty matches any string without consuming input, but only when
-- we allow an empty match
fmatches Empty True  l = [(False, l)]
fmatches Empty False l = []

-- Sym a matches and consumes input if the next input symbol equals a
fmatches (Sym a) _ (b:bs) | a == b = [(True, bs)]
fmatches (Sym a) _ _ = []

-- r :|: s combines all the ways r and s can successfully match the input
fmatches (r :|: s) allowEmpty l =
    fmatches r allowEmpty l ++ fmatches s allowEmpty l

-- r :+: s checks whether s matches whatever is left after matching r
fmatches (r :+: s) allowEmpty l =
    [ (c1 || c2, l2) |
        (c1, l1) <- fmatches r True l,
        (c2, l2) <- fmatches s (allowEmpty || c1) l1 ]
    -- r is always free to match an empty string, but s must consume input
    -- if an empty match is not allowed and r did not consume input

-- use helper functions to match r repeatedly
fmatches (Rep r) True  l = fmatchRep0 r l
fmatches (Rep r) False l = fmatchRep1 r l

-- match r one or more times; only the first match of r can be empty
fmatches (Rep1 r) allowEmpty l =
    [ (c1 || c2, l2) |
        (c1, l1) <- fmatches r allowEmpty l,
        (c2, l2) <- fmatchRep0 r l1 ]


-- Matching R* or R+ can result in infinitely many possible matches if
-- R can match an empty string. To avoid this, these helper functions always
-- require R to consume at least one input symbol.

-- match zere or more (non-empty) strings matched by r
fmatchRep0 r l = (False, l) : fmatchRep1 r l

-- match one or more (non-empty) strings matched by r
fmatchRep1 r l =
    [ (True, l2) |
        (_, l1) <- fmatches r False l,
        (_, l2) <- fmatchRep0 r l1 ]


-- this is the version that was defined in class

-- fmatches (Rep r) allowEmpty l
--     | allowEmpty = (False, l) : leftovers
--     | otherwise  = leftovers
--     where
--     leftovers = [ (True, l2) |
--         (c1, l1) <- fmatches r False l,
--         (c2, l2) <- fmatches (Rep r) True l1 ]


-- a**
doublestar = Rep (Rep (Sym 'a'))

-- matches doublestar "a" = ["a", "a", "a", ...]
-- fmatches doublestar True "a" = [(False, "a"), (True, "")]
--
-- matches gets stuck listing infinitely many ways for a** to consume no input
-- fmatches only allows one way to consume no input
--
-- thus,
-- fmatches (doublestar :+: Sym 'b') True "ab" = [(True,"")]
-- matches  (doublestar :+: Sym 'b') = <infinite loop>


letter = foldr1 (:|:) (map Sym ['a'..'z'])
digit = foldr1 (:|:) (map Sym ['0'..'9'])
alphanum = letter :|: digit

username = alphanum :+: Rep (Sym '.' :|: alphanum)
domain = Rep1 alphanum :+: Rep1 (Sym '.' :+: Rep1 alphanum)

e_mail = username :+: Sym '@' :+: domain

--
-- matches (Sym 'a' :+: Sym 'b') "ab"
--
--     matches (Sym 'a') "abcb"
--     ["bcb"]
--     map (matches (Sym 'b') "bcb") ["bcb"]
--     [["cb"]]
--     concat
--     ["cb"]
--




xyz = (Sym 'x' :|: Empty) :+: (Sym 'y' :|: Sym 'z')
module Project where
	data RE a            -- regular expressions over an alphabet defined by 'a'
		= Empty          -- empty regular expression
		| Sym a          -- match the given symbol
		| RE a :+: RE a  -- concatenation of two regular expressions
		| RE a :|: RE a  -- choice between two regular expressions
		| Rep (RE a)     -- zero or more repetitions of a regular expression
		| Rep1 (RE a)    -- one or more repetitions of a regular expression
		deriving (Show)


	matchEmpty :: RE a -> Bool
	matchEmpty Empty = True
		where Empty = Empty
	matchEmpty (Sym x) = False
	matchEmpty (x :+: y) = (matchEmpty x) && (matchEmpty y)
	matchEmpty (x :|: y) = (matchEmpty x) || (matchEmpty y)
	matchEmpty (Rep x) = True
	matchEmpty (Rep1 x) = matchEmpty x


	firstMatches :: RE a -> [a]
	firstMatches Empty = []
		where Empty = Empty
	firstMatches (Sym x) = [x]
	firstMatches (x :+: y)
		|matchEmpty x == False = firstMatches x
		|matchEmpty x == True = (firstMatches x) ++ (firstMatches y)
	firstMatches (x :|: y) = (firstMatches x) ++ (firstMatches y)
	firstMatches (Rep x) = firstMatches x
	firstMatches (Rep1 x) = firstMatches x
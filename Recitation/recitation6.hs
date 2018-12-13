--reverse list 
rever [] = []
rever (x:xs) = rever xs ++ [x]

--replicate 
repl n x
	| n <= 0 = []
	| otherwise = x : repl (n-1) x 


--zip 
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys 

zipW _ [] = []
zipW [] _ = []
zipW (x:xs) (y:ys) = (x+y) : zipW xs ys

zipW2 _ _ [] = []
zipW2 _ [] _ = []
zipW2 f (x:xs) (y:ys) = f x y : zipW2 f xs ys 


cart :: [a] -> [b] -> [(a,b)]
cart xs ys = [(x,y) | x <- xs, y<- ys]



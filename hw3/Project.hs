module Project where 
	data Tree a = Leaf a | Fork (Tree a) (Tree a) deriving (Show, Eq, Ord)
	data BST a  = Tip | Bin (BST a) a (BST a) deriving (Show, Eq, Ord)

	cart :: [a] -> [b] -> [(a,b)]
	cart as bs = [(a,b) | a <- as, b <- bs]
	

	stddev :: [Double] -> Double 
	stddev [] = 0.0
	stddev xs = sqrt $ sqrsum / len - (sum xs / len) ^ 2
	    where len = fromIntegral $ length xs
	          sqrsum = (sum $ map (^2) xs)


	height :: Tree a -> Int 
	height (Leaf _ ) 	     = 0
	height (Fork left right) = 1 + max (height left) (height right)


	minLeaf :: Ord a => Tree a -> a
	minLeaf (Leaf a ) = a
	minLeaf (Fork left right ) = min (minLeaf left) (minLeaf right)
	

	inorder :: Tree a -> [a]
	inorder (Leaf a) = [a] 
	inorder (Fork left right) = (inorder left) ++ (inorder right)

	
	contains :: Ord a => a -> BST a -> Bool
	contains _ Tip = False
	contains x (Bin left a right)
		| x == a = True
		| x < a  = contains x left
		| x > a  = contains x right 

	
	insert :: Ord a => a -> BST a -> BST a
	insert x Tip = Bin Tip x Tip 
	insert x (Bin left a right)
		| x == a = Bin left a right
		| x < a  = Bin (insert x left) a right
		| x > a  = Bin left a (insert x right)

	
	delete :: Ord a => a -> BST a -> BST a
	delete _ Tip = Tip
	delete x (Bin left a right)
		| x < a = Bin (delete x left) a right 
		| x > a = Bin left a (delete x right)
	delete _ (Bin Tip _ Tip) = Tip
	delete _ (Bin left _ Tip) = left
	delete _ (Bin Tip _ right) = right


factorial 0 = 1
factorial n = n * factorial (n-1)


fib 0 = 0
fib 1 = 1 
fib n = fib(n-2) + fib(n-1)

len [] = 0
len(_:xs) = 1 + len xs

sum' [] = 0
sum' (x:xs) = x + sum' xs

-- maximum [1,2,3] -> 3
--use : max x y -> the max of the two 

maximum' [] = error " "
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs) 
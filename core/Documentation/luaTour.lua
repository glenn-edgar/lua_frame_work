-- consoleStream(30000,"<start>","<end>" )
-- <start>           
-- Lua Comment

--[[

This is a lua block comment

--]]

 -- basic lua types
 print("\r\n")
 print( type("Hello world"),"\r")  -- string
 print( type(10*3),"\r")         -- number
 print( type(print),"\r")          -- function
 print( type(true ),"\r")          -- boolean
 print( type( nil ),"\r")          -- nil -> lua's form on NULL
 print( type( { 5 } ),"\r")         -- table 

 -- defining functions
 a = 5
 b = 3
 print(a+b)

 -- defining lambda type function 
 a = function( i, j ) print(i,j,"\r") end
 -- calling lua function
 a(5,6)

 -- multiple returns can take place
 function test(i,j) 
   print("this is a function creation test",i,j, "\r");
   return 1,2 -- multiple return
  end

 a, b = test(1,2)

 print( "mulitiple return",a,b,"\r")

-- showing effect of local varable

 function localVar()
    local i = 0
    i = i+1
    print("local function's i ",i,"\r");
 end

--localVar()

--
--
-- Control Structures
--
--

print("While loop test \r")
-- while
  a = 10
-- note 0 and NULL are not the same value 
while a ~= 0  do
  print("while a ",a,"\r")
  a = a -1
end

print("For loop test \r")
-- for -- note the difference in index setup with c
 for i = 0, 10, 1 do
  print(i,"\r")
 end


print("for with break test \r")
-- for with a break statement
   for i = 0, 10,1 do
     if i > 5 then break end
       print(i,"\r")
   end

print("if-then-elseif-else logic ")

a = 5
if a == 2 then
  print("then part \r")
elseif a == 5 then
  print("elseif part \r")
else
  print("else part \r")
end

print("repeat block testing ")
a = 0
repeat
   print(a,"\r")
   a = a+1
until a == 5

    
--- list operations
print("list operations \r")

list = { 1,2,4,5,6,7,8,9,10}
print("list start at 1",list[1],"\r")

-- iterate over  in list


for i,v in ipairs( list ) do
  print(i,v,"\r")
end

   
--- table operations
print("table operations \r")

table = { [1]=1,[2]=2,[4]= 4,[5]=5,[6]=6,[7]=7,[8]=8,[9]=9,[10] = 10}
print("table index 7",list[7],"\r")

-- iterate over  in list


for i,v in pairs( list ) do
  print(i,v,"\r")
end


-- example of unpack command
-- allows a list to be unrolled for function calls
print(unpack{10,20,30 })

print("\r\n defining C type printf statement \r")

function  printf( format, ... )
  print( string.format( format, unpack( arg )))
end

printf(" String %s number %d \r\n"," test string",1 )


print("done with lua tour ")
   




-- stream ends after this entry

--<end> 





                          

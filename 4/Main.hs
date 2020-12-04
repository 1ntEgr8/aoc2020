import System.IO
import Data.List
import Data.Char
import Text.ParserCombinators.ReadP


type Passport = [(String,String)]


-- 1. read until encounter colon
-- 2. read until encounter space or newline
-- 3. if newline, end; otherwise go to step 1

parseKey = munch (\c -> c /= ':')

parseColon = char ':'

parseValue = munch (\c -> c /= ' ' && c /= '\n')

parseKv = do
    key <- parseKey
    _ <- parseColon
    value <- parseValue
    next <- look
    case next of
        "" -> return '\n' 
        _ -> get 
    return (key,value)


parseKvs :: ReadP [(String,String)]
parseKvs = manyTill parseKv eof


getKvs :: String -> [(String,String)]
getKvs s = case res of
            [] -> []
            (x:_) -> fst x
    where
        res = readP_to_S parseKvs s

expectedKeys = ["byr","iyr","eyr","hgt","hcl","ecl","pid"]

checkRange x start end = x >= start && x <= end

eyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

checkHgt s = checkUnits && checkValue 
    where 
        n = length s
        units = take 2 (drop (n-2) s)
        checkUnits = units == "cm" || units == "in"
        value = read (take (n-2) s) :: Int
        checkValue = 
            case units of
                "cm" -> checkRange value 150 193
                "in" -> checkRange value 59 76
                _ -> False
            
checkPid pid = checkLength && checkChars
    where
        checkLength = (length pid) == 9
        checkChars = and (map isDigit pid)

checkHcl hcl = checkLength && checkHash && checkValues
    where
        checkLength = (length hcl) == 7
        checkHash = hcl !! 0 == '#'
        isHexAlpha x = x `elem` ['a'..'f']
        checkValues = and (map (\x -> (isDigit x) || (isHexAlpha x)) (drop 1 hcl))


isValidKey (k,s) = case k of
    "byr" -> checkRange (read s :: Int) 1920 2002
    "iyr" -> checkRange (read s :: Int) 2010 2020
    "eyr" -> checkRange (read s :: Int) 2020 2030
    "hgt" -> checkHgt s 
    "hcl" -> checkHcl s
    "ecl" -> s `elem` eyeColors 
    "pid" -> checkPid s
    "cid" -> True
    _ -> False


validatePassport :: Passport -> Int
validatePassport p = if res == True then 1 else 0
    where
        keys = map fst p
        checkKeys = and (map (\x -> x `elem` keys) expectedKeys)
        checkValues = and (map isValidKey p)
        res = checkKeys && checkValues
        -- res = checkValues
        -- res = checkValues


processLine :: ([Passport],Int) -> String -> ([Passport],Int)
processLine ([],n) line = ([getKvs line],n)
processLine (p:ps,n) [] = ([]:p:ps,n+(validatePassport p))
processLine (p:ps,n) line = ((p++(getKvs line)):ps,n)


processLines :: [String] -> ([Passport],Int)
processLines = foldl processLine ([],0) 


main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let (p,numValid) = processLines ((lines contents) ++ [""])
    putStrLn (show numValid)
    -- putStrLn (show p)
    return numValid

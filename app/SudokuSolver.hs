module SudokuSolver where

import Control.Monad (guard)
import Data.List (delete)
import Data.Maybe (listToMaybe)

type SudokuGrid = [[Int]]
type Coord = (Int, Int)

solveSudoku :: SudokuGrid -> [SudokuGrid]
solveSudoku grid = case nextEmpty grid of
    Nothing    -> [grid]
    Just coord -> [solution | n <- [1..9], isValid n coord grid, solution <- solveSudoku (insert n coord grid)]

nextEmpty :: [[Int]] -> Maybe (Int, Int)
nextEmpty grid = listToMaybe $ do
    row <- [0..8]
    col <- [0..8]
    guard (grid !! row !! col == 0)
    return (row, col)

isValid :: Int -> Coord -> SudokuGrid -> Bool
isValid n (row, col) grid = notInRow && notInColumn && notInSquare
  where
    notInRow = n `notElem` (grid !! row)
    notInColumn = n `notElem` (transpose grid !! col)
    notInSquare = n `notElem` ([grid !! r !! c | r <- squareRange row, c <- squareRange col])

insert :: Int -> Coord -> SudokuGrid -> SudokuGrid
insert n (row, col) grid = rowsBefore ++ [colsBefore ++ [n] ++ colsAfter] ++ rowsAfter
  where
    (rowsBefore, rowAtCoord:rowsAfter) = splitAt row grid
    (colsBefore, _:colsAfter) = splitAt col rowAtCoord

transpose :: SudokuGrid -> SudokuGrid
transpose ([]:_) = []
transpose grid = map head grid : transpose (map tail grid)

squareRange :: Int -> [Int]
squareRange x = [base..base + 2]
  where base = 3 * (x `div` 3)

module Main where

import System.Environment (getArgs)
import System.FilePath (splitExtension)
import qualified SudokuSolver

main :: IO ()
main = do
  args <- getArgs
  case args of
    [inputFilePath] -> do
      input <- readFile inputFilePath
      let inputGrid = parseCsv input
          outputGrids = SudokuSolver.solveSudoku inputGrid
          outputFilePath = generateOutputFilePath inputFilePath
          output = unlines $ map toCsv outputGrids
      writeFile outputFilePath output
    _ -> putStrLn "Usage: sudoku-solver <input-file>"

parseCsv :: String -> SudokuSolver.SudokuGrid
parseCsv input = map (map read . words) $ lines input

toCsv :: SudokuSolver.SudokuGrid -> String
toCsv grid = unlines $ map (unwords . map show) grid

generateOutputFilePath :: FilePath -> FilePath
generateOutputFilePath inputFilePath = prefix ++ "_solved" ++ suffix
  where
    (prefix, suffix) = System.FilePath.splitExtension inputFilePath

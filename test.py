import filecmp
import subprocess

EXEC_PATH = "./dist-newstyle/build/x86_64-linux/ghc-9.2.7/sudoku-solver-0.1.0.0/x/sudoku-solver/build/sudoku-solver/sudoku-solver"

subprocess.run(["cabal", "build"])

for i in range(0, 49):
    subprocess.run([EXEC_PATH, "to-be-solved/sudoku_" + i.__str__()])

with open('./report.txt', 'w') as dest:
    dest.write('')

for i in range(0, 49):
    solved = "./to-be-solved/sudoku_" + i.__str__() + "_solved"
    reference = "./solved/sudoku_" + i.__str__()
    if not filecmp.cmp(solved, reference):
        with open(solved, 'r') as src:
            grid = src.read()
        with open('./report.txt', 'a') as dest:
            dest.write("Grid " + i.__str__())
            dest.write("\n")
            dest.write(grid)
            dest.write("\n")

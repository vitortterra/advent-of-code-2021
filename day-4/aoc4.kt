data class Board(
  val id: Int,
  val cells: Array<Array<BoardCell>>,
  var isActive: Boolean = true,
) 

data class BoardCell(
  val number: Int,
  var isMarked: Boolean = false,
)

data class NumberInstance(
  val boardId: Int,
  val row: Int,
  val col: Int,
)

data class Winner(
  val boardId: Int,
  val score: Int,
)

class Game {
  var boards = HashMap<Int, Board>()
  var numberInstances = HashMap<Int, List<NumberInstance>>()
  var winners = mutableListOf<Winner>()

  val isOver get() = boards.size == winners.size

  fun checkWinner(boardId: Int, row: Int, col: Int) : Int? {
    val board = boards[boardId]!!
    val nrows = board.cells.size
    val ncols = board.cells[0].size
    
    val colComplete = (0..(nrows-1)).all({
      i -> board.cells[i][col].isMarked
    })
    val rowComplete = (0..(ncols-1)).all({  
      j -> board.cells[row][j].isMarked
    })
    if (colComplete || rowComplete) {
      return board.id
    } 

    return null
  }

  fun drawNumber(number: Int) {
    numberInstances[number]?.forEach({
      val (boardId, row, col) = it
      val board = boards[boardId]!!

      if (board.isActive) {
        board.cells[row][col].isMarked = true

        val winnerBoardId = checkWinner(boardId, row, col)
        winnerBoardId?.let { 
          handleWinner(winnerBoardId = it, lastDrawn = number)
        }
      }
    })
  }

  fun preProcessBoards() {
    for ((boardId, board) in boards) {
      for ((i, row) in board.cells.withIndex()) {
        for ((j, cell) in row.withIndex()) {
          val empty = listOf<NumberInstance>()

          numberInstances[cell.number] = numberInstances.getOrPut(
              cell.number, 
              { empty }
          ) + NumberInstance(boardId, i, j)
        }
      }
    }
  }

  fun readBoards() {
    var boardId = 0
    var boardBuilder = mutableListOf<List<Int>>()

    while (true) {
      val line = readLine()
      when (line) {
        null -> {
          if (boardBuilder.isNotEmpty()) {
            buildBoard(boardBuilder, boardId)
          }
          break
        }

        "" -> {
          if (boardBuilder.isNotEmpty()) {
            buildBoard(boardBuilder, boardId)
            boardId++
          }
          boardBuilder = mutableListOf<List<Int>>()
        }

        else -> {
          val row = line
            .split(" ")
            .filter({ it.isNotBlank() })
            .map({ it.toInt() })

          boardBuilder.add(row)
        }
      }
    }
  }

  private fun buildBoard(boardBuilder: List<List<Int>>, boardId: Int) {
    val cells = boardBuilder
      .map({ 
        row -> row.map({ num -> BoardCell(num) }).toTypedArray() 
      })
      .toTypedArray()

    boards[boardId] = Board(boardId, cells)
  }

  private fun getScore(boardId: Int, lastDrawn: Int) : Int {
    val board = boards[boardId]!!
    var unmarkedSum = 0

    for (row in board.cells) {
      for (cell in row) {
        if (!cell.isMarked) {
          unmarkedSum += cell.number
        }
      }
    }   

    return unmarkedSum * lastDrawn
  }

  private fun handleWinner(winnerBoardId: Int, lastDrawn: Int) {
    val winner = Winner(
      boardId = winnerBoardId,
      score = getScore(winnerBoardId, lastDrawn),
    )

    winners.add(winner)
    boards[winnerBoardId]!!.isActive = false
  }
}

fun readInputNumbers() : List<Int> {
  return readLine()!!
    .split(",")
    .map({ it.toInt() })
}

fun main() {
  val inputNumbers = readInputNumbers()
  val game = Game()
 
  game.readBoards()
  game.preProcessBoards()
  
  for (number in inputNumbers) {
    game.drawNumber(number)
    if (game.isOver)
      break
  }

  println("Part 1: ${game.winners.first().score}")
  println("Part 2: ${game.winners.last().score}")
}

data class Board(
  val id: Int, 
  val numbers: Array<IntArray>, 
  val isMarked: Array<BooleanArray>
) 

data class NumberInstance(
  val boardId: Int,
  val row: Int,
  val column: Int,
)

class Game {
  var boards = HashMap<Int, Board>()
  var numberInstances = HashMap<Int, List<NumberInstance>>()
  private var lastDrawn : Int? = null

  fun checkWinner() : Int? {
    if (lastDrawn != null) {
      numberInstances[lastDrawn]?.forEach({
        val board = boards[it.boardId]!!
        val nrows = board.numbers.size
        val ncols = board.numbers[0].size
        
        val columnComplete = (0..(nrows-1)).all({
          i -> board.isMarked[i][it.column]
        })
        val rowComplete = (0..(ncols-1)).all({  
          j -> board.isMarked[it.row][j]
        })

        if (columnComplete || rowComplete) {
          return board.id
        }
      })
    }
    return null
  }

  fun getScore(boardId: Int) : Int {
    val board = boards[boardId]
    val ld = lastDrawn
    var unmarkedSum = 0

    if (board == null || ld == null)
      return 0

    for ((i, row) in board.numbers.withIndex()) {
      for ((j, num) in row.withIndex()) {
        if (!board.isMarked[i][j]) {
          unmarkedSum += num
        }
      }
    }   

    return unmarkedSum * ld
  }

  fun drawNumber(number: Int) {
    lastDrawn = number
    numberInstances[number]?.forEach({
      boards[it.boardId]!!.isMarked[it.row][it.column] = true
    })
  }

  fun preProcessBoards() {
    for ((boardId, board) in boards) {
      for ((i, row) in board.numbers.withIndex()) {
        for ((j, num) in row.withIndex()) {
          numberInstances[num] = numberInstances.getOrPut(
            num, 
            { listOf<NumberInstance>() }
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
    val numbers = boardBuilder
      .map({ row -> row.toIntArray() })
      .toTypedArray()

    val nrows = numbers.size
    val ncols = numbers[0].size
    val isMarked = Array(nrows, { BooleanArray(ncols) })

    boards[boardId] = Board(boardId, numbers, isMarked)
  }
}

fun readInputNumbers() : List<Int> {
  return readLine()!!
    .split(",")
    .map({ it.toInt() })
}

fun main() {
  var winnerBoardId: Int? = null
  val inputNumbers = readInputNumbers()
  val game = Game()
 
  game.readBoards()
  game.preProcessBoards()
  
  for (number in inputNumbers) {
    game.drawNumber(number)
    winnerBoardId = game.checkWinner()
    if (winnerBoardId != null)
      break
  }

  println(game.getScore(winnerBoardId!!))
}

const calcCaptures = (board, turn) => {
  let possibleCaptures = [];
  for (let row = 0; row < board.length; i++) {
    for (let col = 0; col < row.length; col++) {
      if (getTeam(board[row][col]) === 1 && turn === 1) {
        if (inRange(row - 2, col - 2)) {
          if (board[row - 2][col - 2] === '' && getTeam(board[row - 1][col - 1]) === 2) {
            possibleCaptures.push([row, col, row - 1, col - 1, row - 2, col - 2]);
          }
        }
        if (inRange(row - 2, col + 2)) {
          if (board[row - 2][col + 2] === '' && getTeam(board[row - 1][col + 1]) === 2) {
            possibleCaptures.push([row, col, row - 1, col + 1, row - 2, col + 2]);
          }
        }
        if (getRole(board[row][col]) === 2) {
          if (inRange(row + 2, col - 2)) {
            if (board[row + 2][col - 2] === '' && getTeam(board[row + 1][col - 1]) === 2) {
              possibleCaptures.push([row, col, row + 1, col - 1, row + 2, col - 2]);
            }
          }
          if (inRange(row + 2, col + 2)) {
            if (board[row + 2][col + 2] === '' && getTeam(board[row + 1][col + 1]) === 2) {
              possibleCaptures.push([row, col, row + 1, col + 1, row + 2, col + 2]);
            }
          }
        }
      } else if (getTeam(board[row][col]) === 2 && turn === 2) {
        if (inRange(row + 2, col - 2)) {
          if (board[row + 2][col - 2] === '' && getTeam(board[row + 1][col - 1]) === 2) {
            possibleCaptures.push([row, col, row + 1, col - 1, row + 2, col - 2]);
          }
        }
        if (inRange(row + 2, col + 2)) {
          if (board[row + 2][col + 2] === '' && getTeam(board[row + 1][col + 1]) === 2) {
            possibleCaptures.push([row, col, row + 1, col + 1, row + 2, col + 2]);
          }
        }
        if (getRole(board[row][col]) === 2) {
          if (inRange(row - 2, col - 2)) {
            if (board[row - 2][col - 2] === '' && getTeam(board[row - 1][col - 1]) === 2) {
              possibleCaptures.push([row, col, row - 1, col - 1, row - 2, col - 2]);
            }
          }
          if (inRange(row - 2, col + 2)) {
            if (board[row - 2][col + 2] === '' && getTeam(board[row - 1][col + 1]) === 2) {
              possibleCaptures.push([row, col, row - 1, col + 1, row - 2, col + 2]);
            }
          }
        }
      }
    }
  }
  
  return possibleCaptures;
};
  
const calcMoves = () => {
  // TODO
};
const calcCaptures = (board, turn) => {
  let possibleCaptures = [];
  for (let row = 0; row < board.length; row++) {
    for (let col = 0; col < board[row].length; col++) {
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
          if (board[row + 2][col - 2] === '' && getTeam(board[row + 1][col - 1]) === 1) {
            possibleCaptures.push([row, col, row + 1, col - 1, row + 2, col - 2]);
          }
        }
        if (inRange(row + 2, col + 2)) {
          if (board[row + 2][col + 2] === '' && getTeam(board[row + 1][col + 1]) === 1) {
            possibleCaptures.push([row, col, row + 1, col + 1, row + 2, col + 2]);
          }
        }
        if (getRole(board[row][col]) === 2) {
          if (inRange(row - 2, col - 2)) {
            if (board[row - 2][col - 2] === '' && getTeam(board[row - 1][col - 1]) === 1) {
              possibleCaptures.push([row, col, row - 1, col - 1, row - 2, col - 2]);
            }
          }
          if (inRange(row - 2, col + 2)) {
            if (board[row - 2][col + 2] === '' && getTeam(board[row - 1][col + 1]) === 1) {
              possibleCaptures.push([row, col, row - 1, col + 1, row - 2, col + 2]);
            }
          }
        }
      }
    }
  }
  
  return possibleCaptures;
};
  
const calcMoves = (board, turn) => {
  let possibleMoves = [];
  for (let row = 0; row < board.length; row++) {
    for (let col = 0; col < board[row].length; col++) {
      if (getTeam(board[row][col]) === 1 && turn === 1) {
        if (inRange(row - 1, col - 1)) {
          if (board[row - 1][col - 1] === '') {
            possibleMoves.push([row, col, row - 1, col - 1]);
          }
        }
        if (inRange(row - 1, col + 1)) {
          if (board[row - 1][col + 1] === '') {
            possibleMoves.push([row, col, row - 1, col + 1]);
          }
        }
        if (getRole(board[row][col]) === 2) {
          if (inRange(row + 1, col - 1)) {
            if (board[row + 1][col - 1] === '') {
              possibleMoves.push([row, col, row + 1, col - 1]);
            }
          }
          if (inRange(row + 1, col + 1)) {
            if (board[row + 1][col + 1] === '') {
              possibleMoves.push([row, col, row + 1, col + 1]);
            }
          }
        }
      } else if (getTeam(board[row][col]) === 2 && turn === 2) {
        if (inRange(row + 1, col - 1)) {
          if (board[row + 1][col - 1] === '') {
            possibleMoves.push([row, col, row + 1, col - 1]);
          }
        }
        if (inRange(row + 1, col + 1)) {
          if (board[row + 1][col + 1] === '') {
            possibleMoves.push([row, col, row + 1, col + 1]);
          }
        }
        if (getRole(board[row][col]) === 2) {
          if (inRange(row - 1, col - 1)) {
            if (board[row - 1][col - 1] === '') {
              possibleMoves.push([row, col, row - 1, col - 1]);
            }
          }
          if (inRange(row - 1, col + 1)) {
            if (board[row - 1][col + 1] === '') {
              possibleMoves.push([row, col, row - 1, col + 1]);
            }
          }
        }
      }
    }
  }
  
  return possibleMoves;
};

const calcFurtherCaptures = (board, row, col, turn) => {
  let possibleCaptures = [];

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
      if (board[row + 2][col - 2] === '' && getTeam(board[row + 1][col - 1]) === 1) {
        possibleCaptures.push([row, col, row + 1, col - 1, row + 2, col - 2]);
      }
    }
    if (inRange(row + 2, col + 2)) {
      if (board[row + 2][col + 2] === '' && getTeam(board[row + 1][col + 1]) === 1) {
        possibleCaptures.push([row, col, row + 1, col + 1, row + 2, col + 2]);
      }
    }
    if (getRole(board[row][col]) === 2) {
      if (inRange(row - 2, col - 2)) {
        if (board[row - 2][col - 2] === '' && getTeam(board[row - 1][col - 1]) === 1) {
          possibleCaptures.push([row, col, row - 1, col - 1, row - 2, col - 2]);
        }
      }
      if (inRange(row - 2, col + 2)) {
        if (board[row - 2][col + 2] === '' && getTeam(board[row - 1][col + 1]) === 1) {
          possibleCaptures.push([row, col, row - 1, col + 1, row - 2, col + 2]);
        }
      }
    }
  }

  return possibleCaptures;
};

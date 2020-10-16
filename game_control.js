// General array processing functions

const findElementInPosition = ([x, ...xs], position) => {
  if (position > 0) {
    return findElementInPosition(xs, position - 1);
  }
  
  return x;
};

const replaceElementInPosition = ([x, ...xs], position, replacement) => {
  if (position > 0) {
    return [x].concat(replaceElementInPosition(xs, position - 1, replacement));
  }
  
  return replacement.concat(xs);
};

const replaceCharInPosition = ([x, ...xs], position, replacement) => {
  // TODO: this returns an array instead of a string

  if (position > 0) {
    return [x].concat(replaceCharInPosition(xs, position - 1, replacement));
  }

  return [replacement].concat(xs).join('');
};

// Non playable piece-related functions

const findPiece = (board, row, col) => {
  const rowArray = findElementInPosition(board, row);

  return findElementInPosition(rowArray, col);
};

const replacePiece = (board, row, col, replacement) => {
  return replaceElementInPosition(
    board, 
    row, 
    replaceElementInPosition(findPiece(board, row), col, replacement)
  );
};

const findPieceInPile = (board, row, col, position) => {
  return findElementInPosition(findPiece(board, row, col), position);
};

const addTopPieceToPile = (board, origRow, origCol, destRow, destCol) => {
  return replacePiece(
    board, 
    destRow, 
    destCol, 
    findPiece(board, destRow, destCol).concat(findPieceInPile(board, origRow, origCol, 0))
  );
};

const removeTopPiece = (board, row, col) => {
  replacePiece(board, row, col, replaceCharInPosition(findPiece(board, row, col), 0, ''));
};

// Piece movements functions (final result)

const move = (board, origRow, origCol, destRow, destCol) => {
  return replacePiece(
    replacePiece(board, destRow, destCol, findPiece(board, origRow, origCol)), 
    origRow, 
    origCol, 
    ''
  );
};

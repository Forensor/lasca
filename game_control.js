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
  
  return [replacement].concat(xs);
};

const replaceCharInPosition = ([x, ...xs], position, replacement) => {
  if (position > 0) {
    return x + replaceCharInPosition(xs, position - 1, replacement);
  }

  return replacement + xs.join('');
};

// Non playable piece-related functions

const findPiece = (board, row, col) => {
  const rowArray = findElementInPosition(board, row);

  return findElementInPosition(rowArray, col);
};

const replacePiece = (board, row, col, replacement) => {
  const origRow = findElementInPosition(board, row);
  const replacedRow = replaceElementInPosition(origRow, col, replacement);

  return replaceElementInPosition(board, row, replacedRow);
};

const findPieceInPile = (board, row, col, position) => {
  const piece = findPiece(board, row, col);

  return findElementInPosition(piece, position);
};

const addTopPieceToPile = (board, origRow, origCol, destRow, destCol) => {
  const topPieceOfCaptured = findPieceInPile(board, origRow, origCol, 0);
  const pile = findPiece(board, destRow, destCol);
  const replacement = pile.concat(topPieceOfCaptured);

  return replacePiece(board, destRow, destCol, replacement);
};

const removeTopPiece = (board, row, col) => {
  const piece = findPiece(board, row, col);
  const pieceWithoutTop = replaceCharInPosition(piece, 0, '');

  return replacePiece(board, row, col, pieceWithoutTop);
};

// Piece movements functions (final result)

const move = (board, origRow, origCol, destRow, destCol) => {
  const origPiece = findPiece(board, origRow, origCol);
  const boardWithMovedPiece = replacePiece(board, destRow, destCol, origPiece);
  
  return replacePiece(boardWithMovedPiece, origRow, origCol, '');
};

const capture = (board, origRow, origCol, captRow, captCol, destRow, destCol) => {
  const boardWithTopPiecePassed = addTopPieceToPile(board, captRow, captCol, origCol, origRow);
  const boardWithTopPieceRemovedInCaptured = removeTopPiece(
    boardWithTopPiecePassed, 
    captRow, 
    captCol
  );
  
  return move(boardWithTopPieceRemovedInCaptured, origRow, origCol, destRow, destCol);
};

const unitTest = (func, expected) => {
  return func.toString() === expected.toString() ? 'PASSED' : 'FAILED';
};

const testArray = [['b', 'bb', 'bbb'], ['', '', ''], ['w', 'ww', 'www']];

console.log('findElementInPosition: ' + unitTest(findElementInPosition(['a', 'b'], 1), 'b'));
console.log('replaceElementInPosition: ' + unitTest(replaceElementInPosition(['a', 'b'], 1, 'a'), ['a', 'a']));
console.log('replaceCharInPosition: ' + unitTest(replaceCharInPosition('ab', 1, 'a'), 'aa'));
console.log('findPiece: ' + unitTest(findPiece(testArray, 0, 1), 'bb'));
console.log('replacePiece: ' + unitTest(replacePiece(testArray, 0, 1, 'aa'), [['b', 'aa', 'bbb'], ['', '', ''], ['w', 'ww', 'www']]));
console.log('findPieceInPile: ' + unitTest(findPieceInPile(testArray, 0, 1, 0), 'b'));
console.log('addTopPieceToPile: ' + unitTest(addTopPieceToPile(testArray, 0, 1, 2, 1), [['b', 'bb', 'bbb'], ['', '', ''], ['w', 'wwb', 'www']]));
console.log('removeTopPiece: ' + unitTest(removeTopPiece([['a', 'aa'], ['b', 'b']], 0, 1), [['a', 'a'], ['b', 'b']]));
console.log('move: ' + unitTest(move(testArray, 0, 0, 1, 0), [['', 'bb', 'bbb'], ['b', '', ''], ['w', 'ww', 'www']]));
console.log('capture: ' + unitTest(capture(testArray, 0, 0, 2, 0, 1, 0), [['', 'bb', 'bbb'], ['bw', '', ''], ['', 'ww', 'www']]));
console.log('promote: ' + unitTest(promote([['w', 'W', 'wb'], [''], [''], [''], [''], [''], ['b', 'B', 'bw']]), [['W', 'W', 'Wb'], [''], [''], [''], [''], [''], ['B', 'B', 'Bw']]));
console.log('record: ' + unitTest(record('a', 'b'), 'a b'));
console.log('getTeam: ' + unitTest(getTeam('www'), 1));
console.log('getRole: ' + unitTest(getRole('BBw'), 2));
console.log('inRange: ' + unitTest(inRange(-1, 5), false));
console.log('calcCaptures: ' + unitTest(calcCaptures([['W', '', ''], ['', 'b', ''], ['', '', '']], 1), [[0, 0, 1, 1, 2, 2]]));
console.log('calcMoves: ' + unitTest(calcMoves([['W', '', ''], ['', '', ''], ['', '', '']], 1), [[0, 0, 1, 1]]));
console.log('calcFurtherCaptures: ' + unitTest(calcFurtherCaptures([['W', '', ''], ['', 'b', ''], ['', '', '']], 0, 0, 1), [[0, 0, 1, 1, 2, 2]]));
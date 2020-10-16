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
console.log('findPiece: ' + unitTest(findPiece(testArray, 0, 1), 'bb'));
console.log('findPiece: ' + unitTest(findPiece(testArray, 0, 1), 'bb'));
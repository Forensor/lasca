const unitTest = (func, expected) => {
  return func.toString() === expected.toString() ? 'PASSED' : 'FAILED';
};

const testArray = [['b', 'bb', 'bbb'], ['', '', ''], ['w', 'ww', 'www']];

console.log('findElementInPosition: ' + unitTest(findElementInPosition(['a', 'b'], 1), 'b'));
console.log('replaceElementInPosition: ' + unitTest(replaceElementInPosition(['a', 'b'], 1, 'a'), ['a', 'a']));
console.log('replaceCharInPosition: ' + unitTest(replaceCharInPosition('ab', 1, 'a'), 'aa'));
'use strict';

const newGame = () => {
  const board = [
    ['b', '', 'b', '', 'b', '', 'b'], 
    ['', 'b', '', 'b', '', 'b', ''], 
    ['b', '', 'b', '', 'b', '', 'b'], 
    ['', '', '', '', '', '', ''], 
    ['w', '', 'w', '', 'w', '', 'w'], 
    ['', 'w', '', 'w', '', 'w', ''], 
    ['w', '', 'w', '', 'w', '', 'w']
  ];
  const turn = 1;
  const moveNumber = 1;
  const history = '';

  return newTurn(board, turn, moveNumber, history);
};

const newTurn = (board, turn, moveNumber, history) => {
  const possibleCaptures = calcCaptures(board, turn);
  if (possibleCaptures === []) {
    
  }
};
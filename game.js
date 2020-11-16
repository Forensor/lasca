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
  const pgn = '';
  const positions = ['bbbb/bbb/bbbb/3/wwww/www/wwww'];
  const winner = 0;

  return newTurn(board, turn, pgn, positions, winner);
};

const newTurn = (board, turn, pgn, positions, winner) => {
  const possibleCaptures = calcCaptures(board, turn);
  if (possibleCaptures) {}
  return;
};
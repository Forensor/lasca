let board = [
    ['b', '', 'b', '', 'b', '', 'b'], 
    ['', 'b', '', 'b', '', 'b', ''], 
    ['b', '', 'b', '', 'b', '', 'b'], 
    ['', '', '', '', '', '', ''], 
    ['w', '', 'w', '', 'w', '', 'w'], 
    ['', 'w', '', 'w', '', 'w', ''], 
    ['w', '', 'w', '', 'w', '', 'w']
];

let flipped = false;

let fen = 'bbbb/bbb/bbbb/3/wwww/www/wwww';

const coords = [
    ['a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7'], 
    ['a6', 'b6', 'c6', 'd6', 'e6', 'f6', 'g6'], 
    ['a5', 'b5', 'c5', 'd5', 'e5', 'f5', 'g5'], 
    ['a4', 'b4', 'c4', 'd4', 'e4', 'f4', 'g4'], 
    ['a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3'], 
    ['a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2'], 
    ['a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1']
];

const placeDivs = () => {
    document.getElementById('board').innerHTML = '';
    if (flipped) {
        for (let i = coords.length - 1; i >= 0; i--) {
            coords[i].forEach(coord => {
                document.getElementById('board').innerHTML += `<div id="${coord}" style="position: relative;"></div>`;
            });
        }
    } else {
        coords.forEach(row => {
            row.forEach(coord => {
                document.getElementById('board').innerHTML += `<div id="${coord}" style="position: relative;"></div>`;
            });
        });
    }
};

const renderBoard = () => {
    placeDivs();
    for (let row = 0; row < board.length; row++) {
        for (let col = 0; col < board[row].length; col++) {
            if (board[row][col] != '') {
                let overlay = board[row][col].length;
                board[row][col].split('').forEach(piece => {
                    if (piece == 'w') {
                        document.getElementById(coords[row][col]).innerHTML += `<img src="../img/pieces/wood1/ws.svg" style="position: absolute; z-index: ${overlay}; bottom: ${overlay * 8 - 8}px;" />`;
                    } else if (piece == 'W') {
                        document.getElementById(coords[row][col]).innerHTML += `<img src="../img/pieces/wood1/wo.svg" style="position: absolute; z-index: ${overlay}; bottom: ${overlay * 8 - 8}px;" />`;
                    } else if (piece == 'b') {
                        document.getElementById(coords[row][col]).innerHTML += `<img src="../img/pieces/wood1/bs.svg" style="position: absolute; z-index: ${overlay}; bottom: ${overlay * 8 - 8}px;" />`;
                    } else if (piece == 'B') {
                        document.getElementById(coords[row][col]).innerHTML += `<img src="../img/pieces/wood1/bo.svg" style="position: absolute; z-index: ${overlay}; bottom: ${overlay * 8 - 8}px;" />`;
                    }
                    overlay -= 1;
                });
            }
        }
    }
};

renderBoard();
document.getElementById('flip').addEventListener('click', () => {
    if (flipped == true) {
        flipped = false;
    } else if (flipped == false) {
        flipped = true;
    }
    renderBoard();
});
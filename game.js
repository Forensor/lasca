var selected = ""; //Will show which one is picked as coords
var posMoves = []; //Where you can move your selected piece
var posCaptures = []; //Which pieces can capture

var turn = 1; //1 = white, 2 = black
var nmoves = 1; //The number of moves each one is doing

//The array that will control game developing

var board = [
	2, 2, 2, 2,
	2, 2, 2,
	2, 2, 2, 2,
	0, 0, 0,
	1, 1, 1, 1,
	1, 1, 1,
	1, 1, 1, 1
];
var coords = [
	"a7", "c7", "e7", "g7",
	"b6", "d6", "f6",
	"a5", "c5", "e5", "g5",
	"b4", "d4", "f4",
	"a3", "c3", "e3", "g3",
	"b2", "d2", "f2",
	"a1", "c1", "e1", "g1"
];

function getIndex(arr, search){
	
	//Returns 1 index where it matches
	
	let index;
	for(let i = 0; i < arr.length; i++){
		if(arr[i] == search){
			index = i;
			break;
		}
	}
	return index;
}

function recordMove(orig, dest, tmove = 1){ //Origin piece, destination and type of move 1 = normal move, 2 = capture, 3 = promotion

	//Writes in history the move done

	let history = document.getElementById("history");
	if(tmove == 1 && turn == 1){
		history.innerHTML += nmoves.toString() + ". " + coords[orig] + "-" + coords[dest] + " ";
	}else if(tmove == 1 && turn == 2){
		history.innerHTML += coords[orig] + "-" + coords[dest] + " ";
	}else if(tmove == 2 && turn == 1){
		history.innerHTML += nmoves.toString() + ". " + coords[orig] + "x" + coords[dest] + " ";
	}else if(tmove == 2 && turn == 2){
		history.innerHTML += coords[orig] + "x" + coords[dest] + " ";
	}
}

function checkStatus(){ //Checks game status, turns, who won etc
	let status = document.getElementById("status");

	let w = false; //Checks if there are pieces remaining
	let b = false;
	for(let i = 0; i < board.length; i++){
		if(getTeam(board[i]) == 1){
			w = true;
			break;
		}
	}
	for(let i = 0; i < board.length; i++){
		if(getTeam(board[i]) == 2){
			b = true;
			break;
		}
	}
	//Check turn or who won
	if(w && !b){
		status.innerHTML = "White won";
		document.getElementById("history").innerHTML += "# White won";
	}else if(!w && b){
		status.innerHTML = "Black won";
		document.getElementById("history").innerHTML += "# Black won";
	}else if(turn == 1){
		status.innerHTML = "White turn";
	}else if(turn == 2){
		status.innerHTML = "Black turn";
	}
}

function setBoard(){
	
	//Sets board at starting position and loads it
	
	board = [
		2, 2, 2, 2,
		2, 2, 2,
		2, 2, 2, 2,
		0, 0, 0,
		1, 1, 1, 1,
		1, 1, 1,
		1, 1, 1, 1
	];
	selected = "";
	turn = 1;
	posMoves = [];
	posCaptures = [];
	nmoves = 1;
	let history = document.getElementById("history");
	history.innerHTML = "";
	renderBoard();
	checkStatus();
}

function renderBoard(){
	
	//Places pieces as board array leads
	
	for(let i = 0; i < board.length; i++){
		if(board[i] == 2){
			
			//Places black piece
			
			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 18px; margin: 0 auto;'></div>";
		}else if(board[i] == 1){
			
			//Places white piece
			
			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 18px; margin: 0 auto;'></div>";
		}else if(board[i] == 3){

			//Places white officer

			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 18px; margin: 0 auto;'><div style='background-color: #000; width: 5px; height: 5px; margin: auto;'></div></div>";
		}else if(board[i] == 4){

			//Places black officer

			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 18px; margin: 0 auto;'><div style='background-color: #fff; width: 5px; height: 5px; margin: auto;'></div></div>";
		}else if(Array.isArray(board[i])){
			
			//Places columns
			
			let checker = document.getElementById(coords[i]);
			for(let j = 0; j < board[i].length; j++){
				if(board[i][j] == 2){ //Black piece
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 18px; margin: 0 auto;'></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}
				}else if(board[i][j] == 1){ //White piece
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 18px; margin: 0 auto;'></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}
				}else if(board[i][j] == 3){ //White officer
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 18px; margin: 0 auto;'><div style='background-color: #000; width: 5px; height: 5px; margin: auto;'></div></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #000; width: 5px; height: 5px; margin: auto;'></div></div>";
					}
				}else if(board[i][j] == 4){ //Black officer
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 18px; margin: 0 auto;'><div style='background-color: #fff; width: 5px; height: 5px; margin: auto;'></div></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #fff; width: 5px; height: 5px; margin: auto;'></div></div>";
					}
				}
			}
		}else{ //Erases if 0
			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "";
		}
		let checker = document.getElementById(coords[i]);
		checker.setAttribute("style", "background-color: #fff;");
		checker.setAttribute("onclick", "selection('" + coords[i] + "')");
		checker.className = "c";
	}
}

function inBoundaries(index, arr){

	//Checks if index is in array or not

    let r;
    
    if(index >= 0 && index <= arr.length - 1){
        r = true;
    }else{
        r = false;
    }
    return r;
}

function getTeam(piece){

	//Gets team of piece 1 = white, 2 = black

	let team;
	if(piece == 1 || piece[0] == 1 || piece == 3 || piece[0] == 3){
		team = 1;
	}else if(piece == 2 || piece[0] == 2 || piece == 4 || piece[0] == 4){
		team = 2;
	}
	return team;
}

function getRole(piece){

	//Returns role of piece 1 = soldier, 2 = officer

	let r;
	if(piece == 1 || piece == 2 || piece[0] == 1 || piece[0] == 2){
		r = 1;
	}else if(piece == 3 || piece == 4 || piece[0] == 3 || piece[0] == 4){
		r = 2;
	}
	return r;
}

function movesTruthTable(c, d){ //Checker index and destination

	let r = false;

	if(d == -8){
		if(c == 0 || c == 1 || c == 2 || c == 3 || c == 4 || c == 5 || c == 6 || c == 7 || c == 11 || c == 14 || c == 18 || c == 21){
			r = false;
		}else{
			r = true;
		}
	}else if(d == -6){
		if(c == 0 || c == 1 || c == 2 || c == 3 || c == 4 || c == 5 || c == 6 || c == 10 || c == 13 || c == 17 || c == 20 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}else if(d == -4){
		if(c == 0 || c == 1 || c == 2 || c == 3 || c == 7 || c == 14 || c == 21){
			r = false;
		}else{
			r = true;
		}
	}else if(d == -3){
		if(c == 0 || c == 1 || c == 2 || c == 3 || c == 10 || c == 17 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}else if(d == 3){
		if(c == 0 || c == 7 || c == 14 || c == 21 || c == 22 || c == 23 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}else if(d == 4){
		if(c == 3 || c == 10 || c == 17 || c == 21 || c == 22 || c == 23 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}else if(d == 6){
		if(c == 0 || c == 4 || c == 7 || c == 11 || c == 14 || c == 18 || c == 19 || c == 20 || c == 21 || c == 22 || c == 23 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}else if(d == 8){
		if(c == 3 || c == 6 || c == 10 || c == 13 || c == 17 || c == 18 || c == 19 || c == 20 || c == 21 || c == 22 || c == 23 || c == 24){
			r = false;
		}else{
			r = true;
		}
	}
	return r;
}

function calcCaptures(){

	//Calculates if there are possible captures

	if(turn == 1){ //White pieces captures
		for(let i = 0; i < board.length; i++){
			let lufc = board[i - 8]; //LeftUpperFarCorner
			let rufc = board[i - 6]; //RightUpperFarCorner
			let luac = board[i - 4]; //LeftUpperAdyacentCorner
			let ruac = board[i - 3]; //RightUpperAdyacentCorner
			let ldac = board[i + 3]; //LeftDownAdyacentCorner
			let rdac = board[i + 4]; //...
			let ldfc = board[i + 6];
			let rdfc = board[i + 8];
			if(getTeam(board[i]) == 1 && getRole(board[i]) == 1){ //If it's a white piece or a white commanded column
				if(inBoundaries(i - 4, board) && getTeam(luac) == 2 && movesTruthTable(i, -4)){ //If it has a black piece at LeftUpperAdyacentCorner
					if(inBoundaries(i - 8, board) && lufc == 0 && movesTruthTable(i, -8)){ //If LeftUpperFarCorner is empty
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i - 3, board) && getTeam(ruac) == 2 && movesTruthTable(i, -3)){ //If black piece at ruac
					if(inBoundaries(i - 6, board) && rufc == 0 && movesTruthTable(i, -6)){ //If rufc empty
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
			}else if(getTeam(board[i]) == 1 && getRole(board[i]) == 2){ //If it's a white officer piece/column
				if(inBoundaries(i - 4, board) && getTeam(luac) == 2 && movesTruthTable(i, -4)){ //If it has a black piece at LeftUpperAdyacentCorner
					if(inBoundaries(i - 8, board) && lufc == 0 && movesTruthTable(i, -8)){ //If LeftUpperFarCorner is empty
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i - 3, board) && getTeam(ruac) == 2 && movesTruthTable(i, -3)){ //If black piece at ruac
					if(inBoundaries(i - 6, board) && rufc == 0 && movesTruthTable(i, -6)){ //If rufc empty...
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i + 3, board) && getTeam(ldac) == 2 && movesTruthTable(i, 3)){
					if(inBoundaries(i + 6, board) && ldfc == 0 && movesTruthTable(i, 6)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i + 4, board) && getTeam(rdac) == 2 && movesTruthTable(i, 4)){
					if(inBoundaries(i + 8, board) && rdfc == 0 && movesTruthTable(i, 8)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
			}
		}
	}else if(turn == 2){ //Black pieces captures
		for(let i = 0; i < board.length; i++){
			let lufc = board[i - 8]; //LeftUpperFarCorner
			let rufc = board[i - 6]; //RightUpperFarCorner
			let luac = board[i - 4]; //LeftUpperAdyacentCorner
			let ruac = board[i - 3]; //RightUpperAdyacentCorner
			let ldac = board[i + 3]; //LeftDownAdyacentCorner
			let rdac = board[i + 4]; //...
			let ldfc = board[i + 6];
			let rdfc = board[i + 8];
			if(getTeam(board[i]) == 2 && getRole(board[i]) == 1){
				if(inBoundaries(i + 4, board) && getTeam(rdac) == 1 && movesTruthTable(i, 4)){
					if(inBoundaries(i + 8, board) && rdfc == 0 && movesTruthTable(i, 8)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i + 3, board) && getTeam(ldac) == 1 && movesTruthTable(i, 3)){
					if(inBoundaries(i + 6, board) && ldfc == 0 && movesTruthTable(i, 6)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
			}else if(getTeam(board[i]) == 2 && getRole(board[i]) == 2){
				if(inBoundaries(i - 4, board) && getTeam(luac) == 1 && movesTruthTable(i, -4)){
					if(inBoundaries(i - 8, board) && lufc == 0 && movesTruthTable(i, -8)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i - 3, board) && getTeam(ruac) == 1 && movesTruthTable(i, -3)){
					if(inBoundaries(i - 6, board) && rufc == 0 && movesTruthTable(i, -6)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i + 3, board) && getTeam(ldac) == 1 && movesTruthTable(i, 3)){
					if(inBoundaries(i + 6, board) && ldfc == 0 && movesTruthTable(i, 6)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
				if(inBoundaries(i + 4, board) && getTeam(rdac) == 1 && movesTruthTable(i, 4)){
					if(inBoundaries(i + 8, board) && rdfc == 0 && movesTruthTable(i, 8)){
						if(!(posCaptures.includes(i))){
							posCaptures.push(i);
						}
					}
				}
			}
		}
	}
}

function move(checker, tmove = 1){ //Type 1 = normal move, 2 = capture, 3 = promotion

	//Moves selected piece at desired location

	let orig = getIndex(coords, selected);
	let dest = getIndex(coords, checker);
	recordMove(orig, dest, tmove);
	let element = document.getElementById(coords[dest]);
	if(getTeam(board[orig]) == 1 && (dest == 0 || dest == 1 || dest == 2 || dest == 3)){
		promote(orig);
	}else if(getTeam(board[orig]) == 2 && (dest == 21 || dest == 22 || dest == 23 || dest == 24)){
		promote(orig);
	}
	board[dest] = board[orig];
	board[orig] = 0;
	posMoves = [];
	posCaptures = [];
	selected = "";
	element.setAttribute("onclick", "selection('" + coords[dest] + "')");
	element.setAttribute("style", "background-color: white;");
	if(turn == 1){
		turn = 2;
	}else if(turn == 2){
		turn = 1;
		nmoves += 1;
	}
	checkStatus();
	renderBoard();
	calcCaptures();
}

function capture(checker){

	//Captures a piece from adyacent corner

	if(getIndex(coords, selected) - 8 == getIndex(coords, checker)){
		if(Array.isArray(board[getIndex(coords, selected) - 4])){ //If captured piece is an array add piece to your column and remove from captured
			if(Array.isArray(board[getIndex(coords, selected)])){
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) - 4][0]);
				board[getIndex(coords, selected) - 4].shift();
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) - 4][0]];
				board[getIndex(coords, selected) - 4].shift();
			}
			if(board[getIndex(coords, selected) - 4].length <= 1){ //If length of captured column is less or equal than 1 set to piece
				board[getIndex(coords, selected) - 4] = board[getIndex(coords, selected) - 4][0];
			}
		}else{
			if(Array.isArray(board[getIndex(coords, selected)])){ //If selected is a column
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) - 4]);
				board[getIndex(coords, selected) - 4] = 0;
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) - 4]];
				board[getIndex(coords, selected) - 4] = 0;
			}
		}
	}else if(getIndex(coords, selected) - 6 == getIndex(coords, checker)){
		if(Array.isArray(board[getIndex(coords, selected) - 3])){ //If captured piece is an array add piece to your column and remove from captured
			if(Array.isArray(board[getIndex(coords, selected)])){
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) - 3][0]);
				board[getIndex(coords, selected) - 3].shift();
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) - 3][0]];
				board[getIndex(coords, selected) - 3].shift();
			}
			if(board[getIndex(coords, selected) - 3].length <= 1){ //If length of captured column is less or equal than 1 set to piece
				board[getIndex(coords, selected) - 3] = board[getIndex(coords, selected) - 3][0];
			}
		}else{
			if(Array.isArray(board[getIndex(coords, selected)])){ //If selected is a column
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) - 3]);
				board[getIndex(coords, selected) - 3] = 0;
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) - 3]];
				board[getIndex(coords, selected) - 3] = 0;
			}
		}
	}else if(getIndex(coords, selected) + 6 == getIndex(coords, checker)){
		if(Array.isArray(board[getIndex(coords, selected) + 3])){ //If captured piece is an array add piece to your column and remove from captured
			if(Array.isArray(board[getIndex(coords, selected)])){
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) + 3][0]);
				board[getIndex(coords, selected) + 3].shift();
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) + 3][0]];
				board[getIndex(coords, selected) + 3].shift();
			}
			if(board[getIndex(coords, selected) + 3].length <= 1){ //If length of captured column is less or equal than 1 set to piece
				board[getIndex(coords, selected) + 3] = board[getIndex(coords, selected) + 3][0];
			}
		}else{
			if(Array.isArray(board[getIndex(coords, selected)])){ //If selected is a column
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) + 3]);
				board[getIndex(coords, selected) + 3] = 0;
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) + 3]];
				board[getIndex(coords, selected) + 3] = 0;
			}
		}
	}else if(getIndex(coords, selected) + 8 == getIndex(coords, checker)){
		if(Array.isArray(board[getIndex(coords, selected) + 4])){ //If captured piece is an array add piece to your column and remove from captured
			if(Array.isArray(board[getIndex(coords, selected)])){
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) + 4][0]);
				board[getIndex(coords, selected) + 4].shift();
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) + 4][0]];
				board[getIndex(coords, selected) + 4].shift();
			}
			if(board[getIndex(coords, selected) + 4].length <= 1){ //If length of captured column is less or equal than 1 set to piece
				board[getIndex(coords, selected) + 4] = board[getIndex(coords, selected) + 4][0];
			}
		}else{
			if(Array.isArray(board[getIndex(coords, selected)])){ //If selected is a column
				board[getIndex(coords, selected)].push(board[getIndex(coords, selected) + 4]);
				board[getIndex(coords, selected) + 4] = 0;
			}else{ //If selected is not a column create column and remove piece from captured
				board[getIndex(coords, selected)] = [board[getIndex(coords, selected)] ,board[getIndex(coords, selected) + 4]];
				board[getIndex(coords, selected) + 4] = 0;
			}
		}
	}
	move(checker, 2);
}

function showMoves(){

	let checker = getIndex(coords, selected);

	let lufc = board[checker - 8]; //LeftUpperFarCorner
	let rufc = board[checker - 6]; //RightUpperFarCorner
	let luac = board[checker - 4]; //LeftUpperAdyacentCorner
	let ruac = board[checker - 3]; //RightUpperAdyacentCorner
	let ldac = board[checker + 3]; //LeftDownAdyacentCorner
	let rdac = board[checker + 4]; //...
	let ldfc = board[checker + 6];
	let rdfc = board[checker + 8];

	//Will show which moves are available for selected checker

	if(posCaptures.length == 0){ //If there are no possible captures
		if(getTeam(board[checker]) == 1 && getRole(board[checker]) == 1){ //If white piece
			if(inBoundaries(checker - 4, board) && luac == 0 && movesTruthTable(checker, -4)){ //luac
				let element = document.getElementById(coords[checker - 4]);
				element.setAttribute("onclick", "move('" + coords[checker - 4] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker - 4);
			}
			if(inBoundaries(checker - 3, board) && ruac == 0 && movesTruthTable(checker, -3)){ //ruac
				let element = document.getElementById(coords[checker - 3]);
				element.setAttribute("onclick", "move('" + coords[checker - 3] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker - 3);
			}
		}else if(getTeam(board[checker]) == 2 && getRole(board[checker]) == 1){ //If black piece
			if(inBoundaries(checker + 4, board) && rdac == 0 && movesTruthTable(checker, 4)){ //rdac
				let element = document.getElementById(coords[checker + 4]);
				element.setAttribute("onclick", "move('" + coords[checker + 4] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker + 4);
			}
			if(inBoundaries(checker + 3, board) && ldac == 0 && movesTruthTable(checker, 3)){ //ldac
				let element = document.getElementById(coords[checker + 3]);
				element.setAttribute("onclick", "move('" + coords[checker + 3] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker + 3);
			}
		}else if(getRole(board[checker]) == 2){ //If officer
			if(inBoundaries(checker - 4, board) && luac == 0 && movesTruthTable(checker, -4)){ //luac
				let element = document.getElementById(coords[checker - 4]);
				element.setAttribute("onclick", "move('" + coords[checker - 4] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker - 4);
			}
			if(inBoundaries(checker - 3, board) && ruac == 0 && movesTruthTable(checker, -3)){ //ruac
				let element = document.getElementById(coords[checker - 3]);
				element.setAttribute("onclick", "move('" + coords[checker - 3] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker - 3);
			}
			if(inBoundaries(checker + 4, board) && rdac == 0 && movesTruthTable(checker, 4)){ //rdac
				let element = document.getElementById(coords[checker + 4]);
				element.setAttribute("onclick", "move('" + coords[checker + 4] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker + 4);
			}
			if(inBoundaries(checker + 3, board) && ldac == 0 && movesTruthTable(checker, 3)){ //ldac
				let element = document.getElementById(coords[checker + 3]);
				element.setAttribute("onclick", "move('" + coords[checker + 3] + "')");
				element.setAttribute("style", "background-color: yellow");
				posMoves.push(checker + 3);
			}
		}
	}else if(posCaptures.includes(checker)){ //Showing capturing moves
		if(getTeam(board[checker]) == 1 && getRole(board[checker]) == 1 && posCaptures.includes(checker)){ //If white piece
			if(inBoundaries(checker - 4, board) && getTeam(luac) == 2 && movesTruthTable(checker, -4)){ //luac
				if(inBoundaries(checker - 8, board) && lufc == 0 && movesTruthTable(checker, -8)){
					let element = document.getElementById(coords[checker - 8]);
					element.setAttribute("onclick", "capture('" + coords[checker - 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 8);
				}
			}
			if(inBoundaries(checker - 3, board) && getTeam(ruac) == 2 && movesTruthTable(checker, -3)){ //ruac
				if(inBoundaries(checker - 6, board) && rufc == 0 && movesTruthTable(checker, -6)){
					let element = document.getElementById(coords[checker - 6]);
					element.setAttribute("onclick", "capture('" + coords[checker - 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 6);
				}
			}
		}else if(getTeam(board[checker]) == 2 && getRole(board[checker]) == 1){ //If black piece
			if(inBoundaries(checker + 4, board) && getTeam(rdac) == 1 && movesTruthTable(checker, 4)){ //rdac
				if(inBoundaries(checker + 8, board) && rdfc == 0 && movesTruthTable(checker, 8)){
					let element = document.getElementById(coords[checker + 8]);
					element.setAttribute("onclick", "capture('" + coords[checker + 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 8);
				}
			}
			if(inBoundaries(checker + 3, board) && getTeam(ldac) == 1 && movesTruthTable(checker, 3)){ //ldac
				if(inBoundaries(checker + 6, board) && ldfc == 0 && movesTruthTable(checker, 6)){
					let element = document.getElementById(coords[checker + 6]);
					element.setAttribute("onclick", "capture('" + coords[checker + 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 6);
				}
			}
		}else if(getTeam(board[checker]) == 1 && getRole(board[checker]) == 2){ //If white officer
			if(inBoundaries(checker - 4, board) && getTeam(luac) == 2 && movesTruthTable(checker, -4)){ //luac
				if(inBoundaries(checker - 8, board) && lufc == 0 && movesTruthTable(checker, -8)){
					let element = document.getElementById(coords[checker - 8]);
					element.setAttribute("onclick", "capture('" + coords[checker - 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 8);
				}
			}
			if(inBoundaries(checker - 3, board) && getTeam(ruac) == 2 && movesTruthTable(checker, -3)){ //ruac
				if(inBoundaries(checker - 6, board) && rufc == 0 && movesTruthTable(checker, -6)){
					let element = document.getElementById(coords[checker - 6]);
					element.setAttribute("onclick", "capture('" + coords[checker - 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 6);
				}
			}
			if(inBoundaries(checker + 4, board) && getTeam(rdac) == 2 && movesTruthTable(checker, 4)){ //rdac
				if(inBoundaries(checker + 8, board) && rdfc == 0 && movesTruthTable(checker, 8)){
					let element = document.getElementById(coords[checker + 8]);
					element.setAttribute("onclick", "capture('" + coords[checker + 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 8);
				}
			}
			if(inBoundaries(checker + 3, board) && getTeam(ldac) == 2 && movesTruthTable(checker, 3)){ //ldac
				if(inBoundaries(checker + 6, board) && ldfc == 0 && movesTruthTable(checker, 6)){
					let element = document.getElementById(coords[checker + 6]);
					element.setAttribute("onclick", "capture('" + coords[checker + 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 6);
				}
			}
		}else if(getTeam(board[checker]) == 2 && getRole(board[checker]) == 2){ //If black officer
			if(inBoundaries(checker - 4, board) && getTeam(luac) == 1 && movesTruthTable(checker, -4)){ //luac
				if(inBoundaries(checker - 8, board) && lufc == 0 && movesTruthTable(checker, -8)){
					let element = document.getElementById(coords[checker - 8]);
					element.setAttribute("onclick", "capture('" + coords[checker - 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 8);
				}
			}
			if(inBoundaries(checker - 3, board) && getTeam(ruac) == 1 && movesTruthTable(checker, -3)){ //ruac
				if(inBoundaries(checker - 6, board) && rufc == 0 && movesTruthTable(checker, -6)){
					let element = document.getElementById(coords[checker - 6]);
					element.setAttribute("onclick", "capture('" + coords[checker - 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker - 6);
				}
			}
			if(inBoundaries(checker + 4, board) && getTeam(rdac) == 1 && movesTruthTable(checker, 4)){ //rdac
				if(inBoundaries(checker + 8, board) && rdfc == 0 && movesTruthTable(checker, 8)){
					let element = document.getElementById(coords[checker + 8]);
					element.setAttribute("onclick", "capture('" + coords[checker + 8] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 8);
				}
			}
			if(inBoundaries(checker + 3, board) && getTeam(ldac) == 1 && movesTruthTable(checker, 3)){ //ldac
				if(inBoundaries(checker + 6, board) && ldfc == 0 && movesTruthTable(checker, 6)){
					let element = document.getElementById(coords[checker + 6]);
					element.setAttribute("onclick", "capture('" + coords[checker + 6] + "')");
					element.setAttribute("style", "background-color: yellow");
					posMoves.push(checker + 6);
				}
			}
		}
	}
}

function selection(checker){
	
	//Picks checker you clicked and sets var 'selected' with that value
	
	let element = document.getElementById(checker); //Sets element as the div in the html
	let cIndex = getIndex(coords, checker); //Index in array of checker match
	if(selected == ""){
		
		//If nothing selected sets current checker as selected

		if(turn == 1){ //White turn selection
			if(board[cIndex] == 1 || board[cIndex] == 3){ //If it's white piece/officer
				selected = checker;
				element.setAttribute("style", "background-color: yellow;");
				showMoves();
			}else if(Array.isArray(board[cIndex])){
				if(board[cIndex][0] == 1 || board[cIndex][0] == 3){ //If it's white column/officer
					selected = checker;
					element.setAttribute("style", "background-color: yellow;");
					showMoves();
				}
			}
		}else if(turn == 2){ //Black turn selection
			if(board[cIndex] == 2 || board[cIndex] == 4){
				selected = checker;
				element.setAttribute("style", "background-color: yellow;");
				showMoves();
			}else if(Array.isArray(board[cIndex])){
				if(board[cIndex][0] == 2 || board[cIndex][0] == 4){
					selected = checker;
					element.setAttribute("style", "background-color: yellow;");
					showMoves();
				}
			}
		}
	}else if(selected == checker){
		
		//If current checker is the selected, unselects it
		
		selected = "";
		element.setAttribute("style", "background-color: white;");
		posMoves = [];
		renderBoard();
	}
}

function promote(checker){

	//Promotes piece or column commander to officer

	if(Array.isArray(board[checker])){
		if(getTeam(board[checker]) == 1){
			board[checker][0] = 3;
		}else if(getTeam(board[checker]) == 2){
			board[checker][0] = 4;
		}
	}else{
		if(getTeam(board[checker]) == 1){
			board[checker] = 3;
		}else if(getTeam(board[checker]) == 2){
			board[checker] = 4
		}
	}
}

//Document load
renderBoard();
checkStatus();
calcCaptures();

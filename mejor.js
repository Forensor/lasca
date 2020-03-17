var selected = ""; //Will show which one is picked as coords
var posMoves = []; //Where you can move your selected piece
var posCaptures = []; //Which pieces can capture

var turn = 1; //1 = white, 2 = black

//The array that will control game developing

var board = [
	2, 2, 2, 2,
	4, [2, 1, 1, 2], 2,
	0, 0, 0, 0,
	2, [4, 3, 2, 1], 0,
	1, 3, 1, 1,
	1, [1, 2, 2, 1], 1,
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
			index == i;
		}
	}
	return index;
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
	renderBoard();
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
						checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}
				}else if(board[i][j] == 1){ //White piece
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'></div>";
					}
				}else if(board[i][j] == 3){ //White officer
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #000; width: 5px; height: 5px; margin: auto;'></div></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #fff; border: 1px solid black; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #000; width: 5px; height: 5px; margin: auto;'></div></div>";
					}
				}else if(board[i][j] == 4){ //Black officer
					if(j == 0){
						checker.innerHTML = "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #fff; width: 5px; height: 5px; margin: auto;'></div></div>";
					}else{
						checker.innerHTML += "<div style='background-color: #000; border: 1px solid #333; width: 48px; height: 8px; margin: 0 auto;'><div style='background-color: #fff; width: 5px; height: 5px; margin: auto;'></div></div>";
					}
				}
			}
		}else{ //Erases if 0
			let checker = document.getElementById(coords[i]);
			checker.innerHTML = "";
		}
	}
}

function calcCaptures(){

	//Calculates if there are possible captures

	if(turn == 1){ //White pieces captures
		for(let i = 0; i < board.length; i++){
			if(board[i] == 1 || board[i][0] == 1){ //If it's a white piece or a white commanded column
				if(i == 24 || i == 20 || i == 17 || i == 13 || i == 10){ //If it is on one of the right side checkers
					if(((board[i - 4] == 2 || board[i - 4][0] == 2) || (board[i - 4] == 4 || board[i - 4][0] == 4)) && board[i - 8] == 0){ //If corner is black or black column or officer column or piece and other side is empty
						posCaptures.push(i);
					}
				}else if(i == 21 || i == 18 || i == 14 || i == 11 || i == 7){ //If it is one of the left side checkers
					if(((board[i - 3] == 2 || board[i - 3][0] == 2) || (board[i - 3] == 4 || board[i - 3][0] == 4)) && board[i - 6] == 0){ //If corner is black or black column or officer or black officer and other side is empty
						posCaptures.push(i);
					}
				}else if(!(i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6)){ //If not equal of anyone of that checkers
					if((((board[i - 4] == 2 || board[i - 4][0] == 2) || (board[i - 4] == 4 || board[i - 4][0] == 4)) && board[i - 8] == 0) || (board[i - 6] == 0 && ((board[i - 3] == 2 || board[i - 3][0] == 2) || (board[i - 3] == 4 || board[i - 3][0] == 4)))){ //If anyone of the corners has black piece and the other one is empty
						posCaptures.push(i);
					}
				}
			}else if(board[i] == 3 || board[i][0] == 3){ //If white officer column or piece

			}
		}
	}else if(turn == 2){ //Black pieces captures
		for(let i = 0; i < board.length; i++){
			if(board[i] == 0 || board[i] == 4 || board[i] == 7 || board[i] == 11 || board[i] == 14){ //If it is on one of the left side checkers
				if((board[i + 4] == 1 || board[i + 4][0] == 1) && board[i + 8] == 0){

				}
			}
		}
	}
}

function move(checker){
	let orig = getIndex(coords, selected);
	let dest = getIndex(coords, checker);
}

function selection(checker){
	
	//Picks checker you clicked and sets var 'selected' with that value
	
	let element = document.getElementById(checker); //Sets element as the div in the html
	if(selected == ""){
		
		//If nothing selected sets current checker as selected
		
		selected = checker;
		element.setAttribute("style", "background-color: yellow;");
	}else if(selected == checker){
		
		//If current checker is the selected, unselects it
		
		selected = "";
		element.setAttribute("style", "background-color: white;");
	}
}

//Document load
renderBoard();
calcCaptures();
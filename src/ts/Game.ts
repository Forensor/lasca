class Game {
    private _name: string;
    private _board: Piece[][];
    private _red: Player;
    private _blue: Player;
    private _turn: Team;
    private _pgn: string;
    private _numberOfMoves: number;

    constructor(name: string, red: Player, blue: Player) {
        this._name = name;
        this._board = [
            [Piece.Empty, Piece.Empty, Piece.Empty, Piece.Red, Piece.Empty, Piece.Empty],
            [Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty],
            [Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Blue],
            [Piece.Blue, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty],
            [Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty, Piece.Empty],
            [Piece.Empty, Piece.Empty, Piece.Red, Piece.Empty, Piece.Empty, Piece.Empty]
        ];
        this._red = red;
        this._blue = blue;
        this._turn = Team.Red;
        this._pgn = '';
        this._numberOfMoves = 0;
    }

    private incrementNumberOfMoves(): void {
        this._numberOfMoves += 1;
    }

    private recordMoveInPGN(notation: string): void {
        if (this._turn === Team.Red) {
            this._pgn += `${this._numberOfMoves}. ${notation} `;
        } else {
            this._pgn += `${notation} `;
        }
    }

    private changeTurn(): void {
        if (this._turn === Team.Red) {
            this._turn = Team.Blue;
        } else {
            this._turn = Team.Red;
        }
    }

    public move(notation: string): void {
        const origin: string = notation.substring(0, 1);
        const dest: string = notation.substring(2, 3);
        const arrow: string = notation.substring(5, 6);
        const oRow: number = COORDS.findIndex(row => row.includes(origin));
        const oCol: number = COORDS[oRow].findIndex(coord => coord === origin);
        const dRow: number = COORDS.findIndex(row => row.includes(dest));
        const dCol: number = COORDS[dRow].findIndex(coord => coord === dest);
        const aRow: number = COORDS.findIndex(row => row.includes(arrow));
        const aCol: number = COORDS[aRow].findIndex(coord => coord === arrow);

        this._board[dRow][dCol] = this._board[oRow][oCol];
        this._board[oRow][oCol] = Piece.Empty;
        this._board[aRow][aCol] = Piece.Fire;

        if (this._turn === Team.Red) {
            this.incrementNumberOfMoves();
        }

        this.recordMoveInPGN(notation);
        this.changeTurn();
    }
}
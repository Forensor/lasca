class Player {
    private _name: string;
    private _team: Team;

    constructor(name: string, team: Team) {
        this._name = name;
        this._team = team;
    }

    get name(): string {
        return this._name;
    }

    get team(): Team {
        return this._team;
    }
}
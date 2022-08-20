//
// Created by Matthew Abbott 19/8/22
//

{$mode objfpc}
{$m+}


program PascalChess;

uses
    Board, MoveRecorder, Engine, Print, MoveCalculator
type

    Game = Class (Print)
    private
        
    public
        constructor create();
        procedure setPlayerOne(name: string);
        procedure setPlayerTwo(name: string);
        procedure initialiseBoard();
        procedure initialiseBoardReverse();
        function recallMove(): boolean;
        procedure loadGame(fileName: string);
        function movePiece(xa, xb: integer; ca, cb: integer): boolean;
        function engineMove(): boolean;
        clientServerToggle, clientPort, playerSide = integer;
        serverPort = array[0 .. 3] of char;
        clientIP = string;
end;

var
    gameBoard: Board;
    rec: MoveRecorder;
    calc: MoveCalculator;
    moveEngine: Engine;

constructor Game.create();
begin

end;


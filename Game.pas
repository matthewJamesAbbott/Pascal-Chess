//
// Created by Matthew Abbott 19/8/22
//

{$mode objfpc}

unit Game;
interface

uses
    Board; //, MoveRecorder, Engine, Print, MoveCalculator;
type
    serverPort = array[0 .. 3] of char;
    TGame =  Object
    private
        
    public
        constructor create();
        procedure setPlayerOne(name: string);
        procedure setPlayerTwo(name: string);
        procedure initialiseBoard();{
        procedure initialiseBoardReverse();
        function recallMove(): boolean;
        procedure loadGame(fileName: string);
        function movePiece(xa, xb: integer; ca, cb: integer): boolean;
        function engineMove(): boolean;}
end;

var
    gameBoard: TBoard;{
    rec: TMoveRecorder;
    calc: TMoveCalculator;
    moveEngine: TEngine;}
    clientServerToggle, clientPort, playerSide : integer;
    clientIP : string;


implementation

constructor TGame.create();
begin
    gameBoard.create();
end;

procedure TGame.setPlayerOne(name: string);
begin

end;

procedure TGame.setPlayerTwo(name: string);
begin

end;

{
load string representations of pieces into 2D array board black bottom
take note that due to the way the terminal prints 0,0 in 
the array is 7,0 on the board so this initialises 'White Left Rook'
to square 8A
}

procedure TGame.initialiseBoard();
begin

    {
    load white pieces into 2D array starting at 8A
    finishing at 7H
    }

     gameBoard.setSquare(0,0,'White Left Rook');
     gameBoard.setSquare(0,1,'White Left Knight');
     gameBoard.setSquare(0,2,'White Left Bishop');
     gameBoard.setSquare(0,3,'White King');
     gameBoard.setSquare(0,4,'White Queen');
     gameBoard.setSquare(0,5,'White Right Bishop');
     gameBoard.setSquare(0,6,'White Right Knight');
     gameBoard.setSquare(0,7,'White Right Rook');

end;

end.

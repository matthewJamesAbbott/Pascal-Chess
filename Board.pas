//
// Created by Matthew Abbott 19/8/22.
//

{$mode objfpc}
{$m+}



program PascalChess;
type
               boardArray = array[0 .. 7,0 .. 7] of string;

    Board = class
    private

    public
        constructor create();
        procedure setSquare(x, y: integer; piece: string);

        function returnSquare(x, y: integer): string;
end;

var
    gameBoard : boardArray;

constructor Board.create();
begin

end;

procedure Board.setSquare(x, y: integer; piece: string);
begin
    gameBoard[x,y] := piece;
end;

function Board.returnSquare(x, y: integer): string;
begin
    returnSquare := gameBoard[x,y];
end;

begin
end.

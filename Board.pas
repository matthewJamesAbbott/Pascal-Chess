//
// Created by Matthew Abbott 19/8/22.
//

{$mode objfpc}



unit Board;
interface
type
    boardArray = array[0 .. 7,0 .. 7] of string;

    TBoard = Object
    private

    public
        constructor create();
        procedure setSquare(x, y: integer; piece: string);

        function returnSquare(x, y: integer): string;
end;

var
    gameBoard : boardArray;

implementation

constructor TBoard.create();
begin

end;

procedure TBoard.setSquare(x, y: integer; piece: string);
begin
    gameBoard[x,y] := piece;
end;

function TBoard.returnSquare(x, y: integer): string;
begin
    returnSquare := gameBoard[x,y];
end;

end.

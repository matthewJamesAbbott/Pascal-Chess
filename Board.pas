{$mode objfpc}
{$m+}

program Pascal-Chess;
type
    Board = class
    private
        board = array[8,8] of string;

    public
        constructor create();
        procedure setSquare(x, y: integer; piece: string);

        function returnSquare(x, y): string;
end;

constuctor Board.create();
begin

end;

procedure Board.setSquare(x, y: integer; piece: string);
begin
    board[x,y] := piece;
end;

function returnSquare(x, y): string;
begin
    returnSquare := board[x,y];
end;

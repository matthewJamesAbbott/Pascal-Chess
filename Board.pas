{$mode objfpc}
{$m+}

program Pascal-Chess;
type
    Board = class
    private
        array[8,8] of string;

    public
        constructor create();
        procedure setSquare(x, y: integer);

        function returnSquare(x, y): string;
end;



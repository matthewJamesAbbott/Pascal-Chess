//
// Created by Matthew Abbott 25/3/2023
//

{$mode objfpc}

unit BoardInterface;
interface
type
   IBoard = interface
      procedure setSquare(x, y: integer; piece: string);
      function returnSquare(x, y: integer): string;
end;

implementation

end.

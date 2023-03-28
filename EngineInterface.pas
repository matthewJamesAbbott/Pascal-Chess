//
// Created bu Matthew Abbott 27/3/2023
//

{$mode objfpc}
{$H+}

unit EngineInterface;

interface

uses Board, BoardInterface; 
type
   IntegerArray = array of integer;
   IEngineInterface = interface
      function resolveMove(gameBoard: IBoard; computerSide: integer): IntegerArray; virtual;abstract;

end;

implementation

end.

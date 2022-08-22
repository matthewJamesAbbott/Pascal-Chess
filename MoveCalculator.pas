//
// Created by Matthew Abbott 21/8/22
//

{$mode objfpc}

unit MoveCalculator;
interface

uses
Board;
type

    integerArray = array of integer;
    node = ^NodeRec;
    NodeRec = record
        x, y, squareRank: integer;
        next: node;
    end;
    TMoveCalculator = Object

    private
        procedure addNode( inputX, inputY, inputSquareRank: integer );{
        function returnVector(): integerArray;
        function returnWeightedVector(): integerArray;}


    public
        constructor Create();{
        function castleCheck(side: integer): boolean;
        function enPassantCheck(side: integer): integer;
        function possibleSquares2DArray(x, y, side: integer; moveBoard: TBoard): integerArray;
        function checkCalculator(x, y, side: integer; moveBoard: TBoard);
        function checkMateTest(x, y, side: integer; moveBoard: TBoard);
        function evaluatePiece(x, y, side: integer; moveBoard: TBoard);}

   end;
var
    head, tail: node;

implementation

constructor TMoveCalculator.Create();
begin

end;

procedure TMoveCalculator.addNode(inputX, inputY, inputSquareRank: integer);
var temp, newNode: node;
begin
    new(newNode);
    newNode^.x := inputX;
    newNode^.y := inputY;
    newNode^.squareRank := inputSquareRank;
    newNode^.next := nil;
    if head = nil then
            head := newNode
    else
        begin
            temp := head;
            while temp^.next <> nil do
            begin
                temp := temp^.next;
            end;
            temp^.next := newNode;

        end;
end;

end.

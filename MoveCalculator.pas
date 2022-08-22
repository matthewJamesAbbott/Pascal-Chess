//
// Created by Matthew Abbott 21/8/22
//

{$mode objfpc}

unit MoveCalculator;
interface

uses
Board,Sysutils;
type

    integerArray = array of integer;
    node = ^NodeRec;
    NodeRec = record
        x, y, squareRank: integer;
        next: node;
    end;
    TMoveCalculator = Object

    private
        procedure addNode( inputX, inputY, inputSquareRank: integer );
        function returnVector(): string;
        function returnWeightedVector(): string;


    public
        constructor Create();{
        function castleCheck(side: integer): boolean;
        function enPassantCheck(side: integer): integer;
        function possibleSquares2DArray(x, y, side: integer; moveBoard: TBoard): integerArray;
        function checkCalculator(x, y, side: integer; moveBoard: TBoard);
        function checkMateTest(x, y, side: integer; moveBoard: TBoard);}
        function evaluatePiece(inputX, inputY, side: integer; moveBoard: TBoard): integer;

   end;

const
    PAWN = 2;
    KNIGHT = 3;
    BISHOP = 4;
    ROOK = 5;
    QUEEN = 9;
    KING = 10;
    EMPTY = 0;
    BLACK = 0;
    WHITE = 1;

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

{
    serialise possibleSquares list into string moveVector
}

function TMoveCalculator.returnVector(): string;
var temp: node;
    moveVector, concat1: string;

begin
    moveVector := '';
    temp := head;
    while temp <> nil do
        begin
            concat1 := moveVector;
            moveVector := concat(concat1,inttostr(temp^.x),inttostr(temp^.y));
            temp := temp^.next;
        end;
    returnVector := moveVector;
end;

{
    serialise possibleSquares list into string moveVector with piece weights included
}

function TMoveCalculator.returnWeightedVector(): string;
var temp: node;
    moveVector, concat1: string;

begin
    moveVector := '';
    temp := head;
    while temp <> nil do
        begin
            concat1 := moveVector;
            moveVector := concat(concat1,inttostr(temp^.x),inttostr(temp^.y),inttostr(temp^.squareRank));
            temp := temp^.next;
        end;
    returnWeightedVector := moveVector;
end;

{
    evaluate square on moveBoard for piece rank
}

function TMoveCalculator.evaluatePiece(inputX, inputY, side: integer; moveBoard: TBoard): integer;
begin
    if side = 1 then
        begin
            if moveBoard.returnSquare(inputX, inputY) = 'Black Left Knight' then
                    evaluatePiece := KING;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Right Knight' then
                    evaluatePiece := KING;
        end;
end;
end.

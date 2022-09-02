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
    gameFile: TextFile;
    rLine: string;

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
    assignfile(gameFile, 'Chess.txt');
    rewrite(gameFile);
    if side = 1 then
        begin
            if moveBoard.returnSquare(inputX, inputY) = 'Black Pawn' then
                begin
                    evaluatePiece := PAWN;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Left Knight' then
                begin
                    evaluatePiece := KNIGHT;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Right Knight' then
                begin
                    evaluatePiece := KNIGHT;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Left Bishop' then
                begin
                    evaluatePiece := BISHOP;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Right Bishop' then
                begin
                    evaluatePiece := BISHOP;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Left Rook' then
                begin
                    evaluatePiece := ROOK;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Right Rook' then
                begin
                    evaluatePiece := ROOK;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black Queen' then
                begin
                    evaluatePiece := QUEEN;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Black King' then
                begin
                    evaluatePiece := KING;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'Empty' then
                begin
                    evaluatePiece := EMPTY;
                end;
        end
        
    else
        begin
            if moveBoard.returnSquare(inputX, inputY) = 'White Pawn' then
                begin
                    evaluatePiece := PAWN;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Left Knight' then
                begin
                    evaluatePiece := KNIGHT;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Right Knight' then
                begin
                    evaluatePiece := KNIGHT;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Left Bishop' then
                begin
                    evaluatePiece := BISHOP;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Right Bishop' then
                begin
                    evaluatePiece := BISHOP;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Left Rook' then
                begin
                    evaluatePiece := ROOK;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Right Rook' then
                begin
                    evaluatePiece := ROOK;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White Queen' then
                begin
                    evaluatePiece := QUEEN;
                end;
            if moveBoard.returnSquare(inputX, inputY) = 'White King' then
                begin
                    evaluatePiece := KING;
                end;
        end;
end;

{
    check if king or left rook has been moved
    by looking through past moves in Chess.txt
    return false if king or left rook has been moved
    else return true to allow castle move to continue
}


function TMoveCalculator.castleCheck(side: integer): boolean;

var
    rLine: string;

begin
    rewrite(gameFile, 'Chess.txt');
    while 1 <> 0 do
        begin
            readln(gameFile, rLine);
            if (rLine = '') then
                begin
                    break;
                end;
            if side = WHITE then
                begin
                    if pos('(0,3') <> 0 then
                        begin
                            closefile(gameFile);
                            castleCheck := false
                        end
                        else if pos('(0,0') <> 0 then
                            begin
                                closefile(gameFile);
                                castleCheck := false;
                            end;
                end
                else if side = BLACK then
                    begin
                        if pos('(7,3') <> 0 then
                            begin
                                closefile(gameFile);
                                castleCheck := false
                            end
                            else if pos('(7,0') <> 0 then
                                begin
                                    closefile(gameFile);
                                    castleCheck := false
                                end
                    end;
                closefile(gameFile);
                castleCheck := false;
                            
        end;
end;

function TMoveCalculator.enpassantCheck(side: integer): integer;

var
    rLine, tempString: string;
    turn,x,y,xa,ya: integer;

begin
    rewrite(gameFile, 'Chess.txt');
    while 1 <> 0 do
        begin
            readln(gameFile, rLine);
            if pos('[') = 0 then 
                begin
                    turn := strtoint(copy(rLine,2,2);
                end;
            if rLine = nil then
                break;
        end;
        closefile(gameFile);
        rewrite(gameFile, 'Chess.txt');
        while 1 <> 0 do
            begin
                readln(gameFile, rLine);
                tempString := concat('[',inttostr(turn)); 
                if pos(tempString) = 0 then
                    begin
                        readln(gameFile, rLine);
                        break;
                    end;
            end;
        if rLine <> '' then
            begin
                x := copy(rLine,2,1);
                y := copy(rLine,4,1);
                xa := copy(rLine,6,1);
                ya := copy(rLine,8,1);
                if side = BLACK then
                    begin
                        if x = 1 then
                            begin
                                if xa = 3 then
                                    begin
                                        if y = ya then
                                            begin
                                                enpassantCheck := y;
                                            end;
                                    end;
                            end;
                    end;
                if side = WHITE then
                    begin
                        if x = 6 then
                            begin
                                if xa = 4 then
                                    begin
                                        if y = ya then
                                            begin
                                                enpassantCheck := y;
                                            end;
                                    end;
                            end;
                    end;
            end;
            enpassant := 10;
        
end;
end.

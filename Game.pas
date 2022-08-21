//
// Created by Matthew Abbott 19/8/22
//

{$mode objfpc}

unit Game;
interface

uses
    Board,Sysutils; //, MoveRecorder, Engine, Print, MoveCalculator;
type
    serverPort = array[0 .. 3] of char;
    TGame =  Object
    private
        
    public
        constructor create();
        procedure setPlayerOne(name: string);
        procedure setPlayerTwo(name: string);
        procedure initialiseBoard();
        procedure initialiseBoardReverse();
        function recallMove(): boolean;{
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
    clientIP,rLine,rTurn,piece: string;
    i, e, turn, position, start, stringLength: integer;
    gameFile: TextFile;

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
    for i:=0 to 9 do
        begin
            gameBoard.setSquare(1,i,'White Pawn');
        end;

    {
        load string representations of empty space into
        2D array starting at 6A finishing at 3H
    }

    for e:=2 to 5 do
        begin
            gameBoard.setSquare(e,i,'Empty');
        end;
    gameBoard.setSquare(7,0,'Black Left Rook');
    gameBoard.setSquare(7,1,'Black Left Knight');
    gameBoard.setSquare(7,2,'Black Left Bishop');
    gameBoard.setSquare(7,3,'Black King');
    gameBoard.setSquare(7,4,'Black Queen');
    gameBoard.setSquare(7,5,'Black Right Bishop');
    gameBoard.setSquare(7,6,'Black Right Knight');
    gameBoard.setSquare(7,7,'Black Right Rook');

    {
        load string representations of pieces into 2D array board white bottom
        take note that due to the way the terminal prints 0,0 in
        the array is 7,0 on the board so this intialises 'Black Left Rook'
        to square 8A
    }

end;

procedure TGame.initialiseBoardReverse();
begin
    {
        load black pieces into 2D array starting at 8A
        finishing at 7H
    }

    gameBoard.setSquare(0,0,'Black Left Rook');
    gameBoard.setSquare(0,1,'Black Left Knight');
    gameBoard.setSquare(0,2,'Black Left Bishop');
    gameBoard.setSquare(0,3,'Black King');
    gameBoard.setSquare(0,4,'Black Queen');
    gameBoard.setSquare(0,5,'Black Right Bishop');
    gameBoard.setSquare(0,6,'Black Right Knight');
    gameBoard.setSquare(0,7,'Black Right Rook');
    for i := 0 to 7 do
        begin
            gameBoard.setSquare(1,i,'Black Pawn');
        end;

    {
        load string representations of empty space into
        2D array starting at 6A finishing at 3H
    }

    for e := 2 to 5 do
        begin
            for i := 0 to 7 do
                begin
                    gameBoard.setSquare(e,i,'Empty');
                end;
        end;

    {
        load white pieces into 2D array starting at 2A
        finishing at 1H
        notice pawns in reverse order from black
    }

    for i := 0 to 7 do
        begin
            gameBoard.setSquare(6,i,'White Pawn');
        end;
    gameBoard.setSquare(7,0,'White Left Rook');
    gameBoard.setSquare(7,1,'White Left Knight');
    gameBoard.setSquare(7,2,'White Left Bishop');
    gameBoard.setSquare(7,3,'White King');
    gameBoard.setSquare(7,4,'White Queen');
    gameBoard.setSquare(7,5,'White Right Bishop');
    gameBoard.setSquare(7,6,'White Right Knight');
    gameBoard.setSquare(7,7,'White Right Rook');

    {
        read and parse move history from Chess.txt for board layour
        of last move reset game to board layout giving the user
        the next turn
    }
    
end;

function TGame.recallMove(): boolean;
begin
    assignfile(gameFile, 'Chess.txt');
    rewrite(gameFile);
    while 1 <> 0 do
        begin
            readln(gameFile, rLine);
            if (rLine = '') then
                begin
                    break;
                end;
            if (Pos ('[',rLine) <> 0) then
                begin
                    rTurn := copy(rLine, 2,2);
                    turn := StrToInt(rTurn);
                end;
        end;

    closefile(gameFile);
    {
        continue extracting lines of text from Chess.txt parsing them
        for string representations of the pieces
        then inserting string representation into correct position in 2D array board
    }
    rewrite(gameFile);
    for i := 0 to 7 do
        begin
            position := 0;
            start := 0;
            readln(gameFile, rLine);
            for e := 0 to 7 do
                begin
                    position := pos(',', rLine);
                    stringLength := position - start;
                    piece := copy(rLine, start, stringLength);
                    start := position + 1;
                    if piece = 'wlR' then
                        begin
                            gameBoard.setSquare(e, i, 'White Left Rook');
                        end;
                    if piece = 'wlN' then
                        begin
                            gameBoard.setSquare(e, i, 'White Left Knight');
                        end;
                    if piece = 'wlB' then
                        begin
                            gameBoard.setSquare(e, i, 'White Left Bishop');
                        end;
                    if piece = 'wK' then 
                        begin
                            gameBoard.setSquare(e, i, 'White King');
                        end;
                    if piece = 'wQ' then
                        begin
                            gameBoard.setSquare(e, i, 'White Queen');
                        end;
                    if piece = 'wrB' then
                        begin
                            gameBoard.setSquare(e, i, 'White Right Bishop');
                        end;
                    if piece = 'wrN' then
                        begin
                            gameBoard.setSquare(e, i, 'White Right Knight');
                        end;
                    if piece = 'wrR' then
                        begin
                            gameBoard.setSquare(e, i, 'White Right Rook');
                        end;
                    if piece = 'wP' then
                        begin
                            gameBoard.setSquare(e, i, 'White Pawn');
                        end;
                    if piece = 'blR' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Left Rook');
                        end;
                    if piece = 'blN' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Left Knight');
                        end;
                    if piece = 'blB' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Left Bishop');
                        end;
                    if piece = 'bK' then
                        begin
                            gameBoard.setSquare(e, i, 'Black King');
                        end;
                    if piece = 'bQ' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Queen');
                        end;
                    if piece = 'brB' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Right Bishop');
                        end;
                    if piece = 'brN' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Right Knight');
                        end;
                    if piece = 'brR' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Right Rook');
                        end;
                    if piece = 'bP' then
                        begin
                            gameBoard.setSquare(e, i, 'Black Pawn');
                        end;
                    if piece = 'X' then
                        begin
                            gameBoard.setSquare(e, i, 'Empty');
                        end;
                end;
        end;
    closefile(gameFile);
    recallMove := true;
end;
end.

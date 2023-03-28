//
// Created by Matthew Abbott 28/8/22
//

{$mode objfpc}
{$M+}

unit HeapNode;

interface

type
    outArray = array [0 .. 2] of integer;
    
    THeapNode = class
    private
        x, y, squareRank: integer;
        next: THeapNode;

    public
        constructor create();
        procedure setNext(inputNode: THeapNode);
        function getNext: THeapNode;
        procedure setData(xInput, yInput, squareRankInput: integer);
        function getData: outArray;
    end;

implementation

constructor THeapNode.create();
begin
    next := nil;
end;


procedure THeapNode.setNext(inputNode: THeapNode);
begin
    next := inputNode;
end;

function THeapNode.getNext: THeapNode;
begin
    getNext := next;
end;

procedure THeapNode.setData(xInput, yInput, squareRankINput: integer);
begin
    x := xInput;
    y := yInput;
    squareRank := squareRankInput;
end;

function THeapNode.getData:outArray;

var
   returnArray: array [0 .. 2] of integer;
begin
   returnArray[0] := x;
   returnArray[1] := y;
   returnArray[2] := squareRank;
   result := returnArray;
end;
end.

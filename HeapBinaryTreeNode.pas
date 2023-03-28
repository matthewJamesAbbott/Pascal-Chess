//
// Created by Matthew Abbott 31/8/22
//

{$mode objfpc}
{$M+}

unit HeapBinaryTreeNode;


interface


type
    PHeapBinaryTreeNode = ^THeapBinaryTreeNode;
    THeapBinaryTreeNode = class
    private
        rank, x, y, xa, ya, nodeNumber: integer;
        leftChild, rightChild: THeapBinaryTreeNode;

    public
        constructor create();
        procedure setLeftChild(inputNode: THeapBinaryTreeNode);
        function getLeftChild: THeapBinaryTreeNode;
        procedure setRightChild(inputNode: THeapBinaryTreeNode);
        function getRightChild: THeapBinaryTreeNode;
	procedure setRank(inputData: integer);
        procedure setX(inputData: integer);
	procedure SetY(inputData: integer);
	procedure SetXa(inputData: integer);
	procedure SetYa(inputData: integer);
	function getRank: integer;
        function getX: integer;
	function getY: integer;
	function getXa: integer;
	function getYa: integer;
	function getLeftChildPtr: PHeapBinaryTreeNode;
	function getRightChildPtr: PHeapBinaryTreeNode;
        procedure setNodeNumber(inputNumber: integer);
        function getNodeNumber: integer;
    end;

implementation

constructor THeapBinaryTreeNode.create();
begin
    leftChild := nil;
    rightChild := nil;
end;

procedure THeapBinaryTreeNode.setLeftChild(inputNode: THeapBinaryTreeNode);
begin
    leftChild := inputNode;
end;

procedure THeapBinaryTreeNode.setRightChild(inputNode: THeapBinaryTreeNode);
begin
    rightChild := inputNode;
end;

function THeapBinaryTreeNode.getLeftChild: THeapBinaryTreeNode;
begin
    getLeftChild := leftChild;
end;

function THeapBinaryTreeNode.getRightChild: THeapBinaryTreeNode;
begin
    getRightChild := rightChild;
end;

procedure THeapBinaryTreeNode.setRank(inputData: integer);
begin
    Rank := inputData;
end;

procedure THeapBinaryTreeNode.setX(inputData: integer);
begin
    x := inputData;
end;

procedure THeapBinaryTreeNode.setY(inputData: integer);
begin
    y := inputData;
end;

procedure THeapBinaryTreeNode.setXa(inputData: integer);
begin
    xa := inputData;
end;

procedure THeapBinaryTreeNode.setYa(inputData: integer);
begin
    ya := inputData;
end;

function THeapBinaryTreeNode.getRank: integer;
begin
    result := Rank;
end;

function THeapBinaryTreeNode.getX: integer;
begin
    result := x;
end;

function THeapBinaryTreeNode.getY: integer;
begin
    result := y;
end;

function THeapBinaryTreeNode.getXa: integer;
begin
    result := xa;
end;

function THeapBinaryTreeNode.getYa: integer;
begin
    result := ya;
end;

function THeapBinaryTreeNode.getLeftChildPtr: PHeapBinaryTreeNode;
begin
    result := @leftChild;
end;

function THeapBinaryTreeNode.getRightChildPtr: PHeapBinaryTreeNode;
begin
    result := @rightChild;
end;


function THeapBinaryTreeNode.getNodeNumber: integer;
begin
    getNodeNumber := nodeNumber;
end;

procedure THeapBinaryTreeNode.setNodeNumber(inputNumber: integer);
begin
    nodeNumber := inputNumber;
end;
end.



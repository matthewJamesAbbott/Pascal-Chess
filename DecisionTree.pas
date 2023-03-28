//
// Created by Matthew Abbott 18/10/22
//

{$mode objfpc}

unit DecisionTree;
interface

uses
   Classes, Board, BoardInterface, MoveCalculator, HeapBinaryTreeNode, HeapBinaryTree, HeapLinkedList, HeapNode, EngineInterface;
type

   integerArray = array of integer;
   PHeapBinaryTreeNode = ^THeapBinaryTreeNode;
   TDecisionTree = class(TInterfacedObject, IEngineInterface)

   public
      procedure weightedTreeSearch(localRoot: PHeapBinaryTreeNode; base: integer);
      procedure unweightedTreeSearch(localRoot: PHeapBinaryTreeNode);
      constructor create();
      function resolveMove(gameBoard: IBoard; computerSide: integer): integerArray;
end;

const
   SIDE = 'White';
   PAWN = 2;
   KNIGHT = 3;
   BISHOP = 4;
   ROOK = 5;
   QUEEN = 9;
   KING = 10;
   EMPTY = 0;
   MIN = 0;
   MAX = 10;
   Black = 0;
   White = 1;

var
   returnVector: integerArray;

implementation

constructor TDecisionTree.create();
begin
end;

procedure TDecisionTree.weightedTreeSearch(localRoot: PHeapBinaryTreeNode; base: integer);

   
begin
   if localRoot <> nil then
   begin
      weightedTreeSearch(localRoot^.getLeftChildPtr(), base);
      if localRoot^.getRank = base then
      begin
         setLength(returnVector, length(returnVector) + 4);
	 returnVector[length(returnVector)-4] := localRoot^.getX;
	 returnVector[length(returnVector)-3] := localRoot^.getY;
	 returnVector[length(returnVector)-2] := localRoot^.getXa;
	 returnVector[length(returnVector)-1] := localRoot^.getYa;
      end;
      weightedTreeSearch(localRoot^.getRightChildPtr(), base);
   end;
end;

procedure TDecisionTree.unweightedTreeSearch(localRoot: PHeapBinaryTreeNode);
begin
   if localRoot <> nil then
   begin
      unweightedTreeSearch(localRoot^.getLeftChildPtr());
      if localRoot^.getRank >= 0 then
      begin
	 setLength(returnVector, length(returnVector) + 4);
         returnVector[length(returnVector)-4] := localRoot^.getX;
	 returnVector[length(returnVector)-3] := localRoot^.getY;
	 returnVector[length(returnVector)-2] := localRoot^.getXa;
	 returnVector[length(returnVector)-1] := localRoot^.getYa;
      end;
      unweightedTreeSearch(localRoot^.getRightChildPtr());
   end;
end;

function TDecisionTree.resolveMove(gameBoard: IBoard; computerSide: integer): integerArray;

var
   moveTree: THeapBinaryTree;
   stepper: PHeapBinaryTreeNode;
   calc: TMoveCalculator;
   list: THeapLinkedList;
   testBoard: IBoard;
   moveVector: integerArray;
   kingX, kingY, test, choice, base, playerSide, externalIterator, internalIterator, jIterator, tempX, tempY, tempRank: integer;
   compSideColour, compKing: string;
   moveArray: array of integer;

begin
   moveTree := THeapBinaryTree.create();
   calc := TMoveCalculator.create();

   if computerSide = BLACK then
   begin
      playerSide := WHITE;
      compSideColour := 'Black';
      compKing := 'Black King'
   end
   else
   begin
      playerside := BLACK;
      compSideColour := 'White';
      compKing := 'White King';
   end;

   for externalIterator := 0 to 7 do
   begin
      for internalIterator := 0 to 7 do
      begin
         if pos(compSideColour, gameBoard.returnSquare(externalIterator, InternalIterator)) > 0 then
         begin
            list := calc.possibleSquares2DArray(externalIterator, internalIterator, gameBoard, computerSide);
            setLength(moveVector, 0);
	    if list <> nil then
            begin
               moveVector := list.returnWeightedVector();
	       list.Free;
	    end;
	    jIterator := 0;
	    while jIterator < length(moveVector) do
            begin
	       tempX := moveVector[jIterator];
	       tempY := moveVector[jIterator+1];
	       tempRank := moveVector[jIterator+2];
	       if tempRank > base then
	          base := tempRank;
               if base >= 0 then
	       begin
	          if base <= 10 then
	          begin
	             moveTree.addTreeNode(tempRank, externalIterator, internalIterator, tempX, tempY);
               jIterator := jIterator + 3;
	          end;
	       end;
            end;
         end;
      end;
   end;
   stepper := @moveTree.root;
   weightedTreeSearch(stepper, base);
   choice := 0;
   if length(returnVector) >= 4 then
   begin
      test := round(length(returnVector) / 4);
      choice := random(test);
      choice := choice * 4;
   end;
   testBoard := TBoard.create();
   testBoard := gameBoard;
   testBoard.setSquare(returnVector[choice+2], returnVector[choice+3], testBoard.returnSquare(returnVector[choice], returnVector[choice+1]));
   testBoard.setSquare(returnVector[choice], returnVector[choice+1], 'Empty');
   for externalIterator := 0 to 7 do
   begin
      for internalIterator := 0 to 7 do
      begin
         if testBoard.returnSquare(externalIterator, internalIterator) = compKing then
         begin
            kingX := externalIterator;
	    kingY := internalIterator;
	 end;
      end;
   end;
   if calc.checkCalculator(kingX, KingY, testBoard, computerSide) <> true then
   begin
      for jIterator := 0 to high(moveArray) do
         moveArray[jIterator] := returnVector[choice+jIterator];
   end
   else
   begin
      stepper := @moveTree.root;
      setLength(returnVector, 0);
      unweightedTreeSearch(stepper);

      while externalIterator < length(returnVector) do
      begin
         testBoard := gameBoard;
	 testBoard.setSquare(returnVector[externalIterator+2], returnVector[externalIterator+3], testBoard.returnSquare(returnVector[externalIterator], returnVector[externalIterator+1]));
         testBoard.setSquare(returnVector[externalIterator], returnVector[externalIterator+1], 'Empty');
	 for internalIterator := 0 to 7 do
         begin
            for jIterator := 0 to 7 do
            begin
               if testBoard.returnSquare(internalIterator, jIterator) = compKing then
               begin
                  kingX := internalIterator;
		  kingY := jIterator;
               end;
            end;
	 end;
	 if calc.checkCalculator(kingX, kingY, testBoard, computerSide) <> true then
         begin
            for jIterator := 0 to high(moveArray) do
            begin
               moveArray[jIterator] := returnVector[externalIterator+jIterator];
	       break;
	    end;
	 end;
         externalIterator := externalIterator+4;
      end;
   end;

   moveTree.Free;
   setLength(returnVector, 0);
   result := moveArray;
end;

end.

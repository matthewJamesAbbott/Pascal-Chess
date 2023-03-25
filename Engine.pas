//
// Created by Matthew Abbott 18/10/22
//

{$mode objfpc}

unit Engine;
interface

uses
Board,MoveCalculator,HeapTreeNode,HeapTree;
type

	integerArray = array of integer;

	TEngine = Object

		public
			constructor Create();
			procedure moveVector(localRoot: HeapTreeNode, base: integer);
			procedure secondGuess(localRoot: HeapTreeNode);
			function resolveMove():
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

var	

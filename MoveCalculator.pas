//
// Created by Matthew Abbott 21/8/22
//

{$mode objfpc}

unit MoveCalculator;
interface

uses
Board,BoardInterface,HeapLinkedList,Sysutils;
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
      constructor Create();
	function castleCheck(side: integer): boolean;
	function enPassantCheck(side: integer): integer;
	function possibleSquares2DArray(x, y: integer;moveBoard: IBoard; side: integer): THeapLinkedList;
	function checkCalculator(x, y: integer; moveBoard: IBoard;side: integer): Boolean;
	function checkMateTest(gameBoard: IBoard; side: integer): Boolean;
	 function evaluatePiece(inputX, inputY: integer; moveBoard: IBoard; side: integer): integer;

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

      function TMoveCalculator.evaluatePiece(inputX, inputY: integer; moveBoard: IBoard; side: integer): integer;
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
	 Assign(gameFile, 'Chess.txt');
	 rewrite(gameFile);
	 while 1 <> 0 do
	 begin
	    readln(gameFile, rLine);
	    if (rLine = '') then
	    begin
	       break;
	    end;
	    if side = WHITE then
	    begin
	       if pos('(0,3', rLine) <> 0 then
	       begin
		  closefile(gameFile);
		  castleCheck := false
	       end
	    else if pos('(0,0', rLine) <> 0 then
	    begin
	       closefile(gameFile);
	       castleCheck := false;
	    end;
	    end
	 else if side = BLACK then
	 begin
	    if pos('(7,3', rLine) <> 0 then
	    begin
	       closefile(gameFile);
	       castleCheck := false
	    end
	 else if pos('(7,0', rLine) <> 0 then
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
	 rLine: string;
	 turn,x,y,xa,ya: integer;

      begin
	 Assign(gameFile, 'Chess.txt');
	 rewrite(gameFile);
	 while 1 <> 0 do
	 begin
	    readln(gameFile, rLine);
	    if pos('[', rLine) = 0 then 
	    begin
	       turn := strtoint(copy(rLine,2,2));
	    end;
	    if rLine = '' then
	       break;
	 end;
	 closefile(gameFile);
	 Assign(gameFile, 'Chess.txt');
	 rewrite(gameFile);
	 while 1 <> 0 do
	 begin
	    readln(gameFile, rLine);
//	    tempString := concat('[',inttostr(turn)); 
	    if pos({tempString} '[' + IntToStr(turn), rLine) = 0 then
	    begin
	       readln(gameFile, rLine);
	       break;
	    end;
	 end;
	 if rLine <> '' then
	 begin
	    x := StrToInt(copy(rLine,2,1));
	    y := StrToInt(copy(rLine,4,1));
	    xa := StrToInt(copy(rLine,6,1));
	    ya := StrToInt(copy(rLine,8,1));
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
	 enpassantCheck := 10;

      end;

      function TMoveCalculator.possibleSquares2DArray(x, y: integer; moveBoard: IBoard; side: integer): THeapLinkedList;

      var
	 piece, switchedPiece, opponentColour, playerColour: string;
	 list: THeapLinkedList;
	 xIterator, yIterator: integer;

      begin
	 piece := moveBoard.returnSquare(x,y);
	 if pos('Rook', piece) <> 0 then
	    switchedPiece := 'Rook'
	 else if pos('Knight', piece) <> 0 then
	    switchedPiece := 'Knight'
	 else if pos('Bishop', piece) <> 0 then 
	    switchedPiece := 'Bishop'
	 else if pos('Queen', piece) <> 0 then
	    switchedPiece := 'Queen'
	 else
	    switchedPiece := piece;

	 if side = BLACK then
         begin
	    opponentColour := 'White';
	    playerColour := 'Black'
	 end
         else
         begin
	    playerColour := 'White';
	    opponentColour := 'Black';
         end;
	 list := THeapLinkedList.create;

	 case(switchedPiece) of
	   'Rook':
	 begin
	    for xIterator := x + 1 to 7 do
	    begin
	       if moveBoard.returnSquare(xIterator,y) = 'Empty' then
		  list.addNode(xIterator, y, evaluatePiece(xIterator, y, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	       begin
		  list.addNode(xIterator, y, evaluatePiece(xIterator, y, moveBoard, side));
		  break
	       end
	    else if pos(playerColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	    begin
	       break;
	    end;
	    end;
	    for xIterator := x - 1 downto 0 do
	    begin
	       if moveBoard.returnSquare(xIterator,y) = 'Empty' then
		  list.addNode(xIterator, y, evaluatePiece(xIterator, y, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	       begin
		  list.addNode(xIterator, y, evaluatePiece(xIterator, y, moveBoard, side));
		  break
	       end
	    else if pos(playerColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	       break;
	    end;

	    for yIterator := y + 1 to 7 do
	    begin
	       if moveBoard.returnSquare(x,yIterator) = 'Empty' then
		  list.addNode(x, yIterator, evaluatePiece(x, yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       begin
		  list.addNode(x,yIterator, evaluatePiece(x,yIterator, moveBoard, side));
		  break
	       end
	    else if pos(playerColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       break;
	    end;

	    for yIterator := y - 1 downto 0 do
	    begin
	       if moveBoard.returnSquare(x,yIterator) = 'Empty' then
		  list.addNode(x, yIterator, evaluatePiece(x, yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       begin
		  list.addNode(x,yIterator, evaluatePiece(x,yIterator, moveBoard, side));
		  break
	       end
	    else if pos(playerColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       break;
	    end;
	    possibleSquares2DArray := list;
	 end;

	   'Knight':
	 begin
	    if x < 6 then
	    begin
	       if y < 7 then
	       begin
		  if moveBoard.returnSquare(x+2,y+1) = 'Empty' then
		  begin
		     list.addNode(x+2,y+1, evaluatePiece(x+2,y+1,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(x+2,y+1)) <> 0 then
	       begin
		  list.addNode(x+2,y+1, evaluatePiece(x+2,y+1,moveBoard,side))
	       end;
	       end;
	    end;
	    if x < 6 then
	    begin
	       if y > 0 then
	       begin
		  if moveBoard.returnSquare(x+2,y-1) = 'Empty' then
		  begin
		     list.addNode(x+2,y-1, evaluatePiece(x+2,y-1,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(x+2,y-1)) <> 0 then
	       begin
		  list.addNode(x+2,y-1, evaluatePiece(x+2,y-1,moveBoard,side));
	       end;
	       end;
	    end;

	    if x < 7 then
	    begin
	       if y < 6 then
	       begin
		  if moveBoard.returnSquare(x+1,y+2) = 'Empty' then
		  begin
		     list.addNode(x+1,y+2, evaluatePiece(x+1,y+2,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(x+1,y+2)) <> 0 then
	       begin
		  list.addNode(x+1,y+2, evaluatePiece(x+1,y+2,moveBoard,side));
	       end;
	       end;
	    end;
	    if x < 7 then
	    begin
	       if y > 1 then
	       begin
		  if moveBoard.returnSquare(x+1,y-2) = 'Empty' then
		  begin
		     list.addNode(x+1,y-2, evaluatePiece(x+1,y-2,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(x+1,y-2)) <> 0 then
	       begin
		  list.addNode(x+1,y-2, evaluatePiece(x+1,y-2,moveBoard,side));
	       end;
	       end;
	    end;

	    if x > 1 then
	    begin
	       if y < 7 then
	       begin
		  if moveBoard.returnSquare(x-2,y+1) = 'Empty' then
		  begin
		     list.addNode(x-2,y+1, evaluatePiece(x-2,y+1,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(x-2,y+1)) <> 0 then
		  list.addNode(x-2,y+1, evaluatePiece(x-2,y+1,moveBoard,side));
	       end;
	       end;
	       if x > 1 then
	       begin
		  if y > 0 then
		  begin
		     if moveBoard.returnSquare(x-2,y-1) = 'Empty' then
		     begin
			list.addNode(x-2,y-1, evaluatePiece(x-2,y-1,moveBoard,side))
		     end
		  else if pos(opponentColour, moveBoard.returnSquare(x-2,y-1)) <> 0 then
		  begin
		     list.addNode(x-2,y-1, evaluatePiece(x-2,y-1,moveBoard,side));
		  end;
		  end;
	       end;

	       if x > 0 then
	       begin
		  if y < 6 then
		  begin
		     if moveBoard.returnSquare(x-1,y+2) = 'Empty' then
		     begin
			list.addNode(x-1,y+2, evaluatePiece(x-1,y+2,moveBoard,side))
		     end
		  else if pos(opponentColour, moveBoard.returnSquare(x-1,y+2)) <> 0 then
		  begin
		     list.addNode(x-1,y+2, evaluatePiece(x-1,y+2,moveBoard,side));
		  end;
		  end;
		  if x > 0 then
		  begin
		     if y < 1 then
		     begin
			if moveBoard.returnSquare(x-1,y-2) = 'Empty' then
			begin
			   list.addNode(x-1,y-2, evaluatePiece(x-1,y-2,moveBoard,side))
			end
		     else if pos(opponentColour, moveBoard.returnSquare(x-1,y-2)) <> 0 then
		     begin
			list.addNode(x-1,y-2, evaluatePiece(x-1,y-2,moveBoard,side));
		     end;
		     end;
		  end;
		  possibleSquares2DArray := list;
	       end;
	    end;

	       'Bishop':
	    begin
	       yIterator := y+1;
	       for xIterator := x+1 to 7 do
	       begin
		  if yIterator > 7 then
		  begin
		     break;
		  end;
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		  begin
		     list.addNode(xIterator,yIterator,evaluatePiece(xIterator,yIterator,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator,moveBoard,side));
		  break
	       end

	       else if pos(playerColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  break;
	       end;
		  inc(yIterator);
	       end;

	       yIterator := y-1;
	       for xIterator := x+1 to 7 do
	       begin
		  if yIterator < 0 then
		  begin
		     break;
		  end;
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		  begin
		     list.addNode(xIterator,yIterator,evaluatePiece(xIterator,yIterator,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator,moveBoard,side));
		  break
	       end
	       else if pos(playerColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
		  break;
		  dec(yIterator);
	       end;

	       yIterator := y+1;
	       for xIterator := x-1 downto 0 do
	       begin
		  if yIterator > 7 then
		  begin
		     break;
		  end;
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		  begin
		     list.addNode(xIterator,yIterator,evaluatePiece(xIterator,yIterator,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator,moveBoard,side));
		  break
	       end
	       else if pos(playerColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
		  break;
		  inc(yIterator);
	       end;

	       yIterator := y-1;
	       for xIterator := x-1 downto 0 do
	       begin
		  if yIterator < 0 then
		  begin
		     break;
		  end;
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		  begin
		     list.addNode(xIterator,yIterator,evaluatePiece(xIterator,yIterator,moveBoard,side))
		  end
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator,moveBoard,side));
		  break
	       end
	       else if pos(playerColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
		  break;
		  dec(yIterator);
	       end;
	       possibleSquares2DArray := list;
	    end;
	       
	       'Queen':
	    begin
	       for xIterator := x+1 to 7 do
	       begin
		  if moveBoard.returnSquare(xiterator,y) = 'Empty' then
		  begin
		     list.addNode(xIterator,y,evaluatePiece(xIterator,yIterator,moveBoard,side))
		  end

	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	       begin
		  list.addNode(xIterator,y,evaluatePiece(xIterator,y,moveBoard,side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,y) <> 'Empty' then
		  break;
	       end;
	       for xIterator := x-1 downto 0 do
	       begin
		  if moveBoard.returnSquare(xIterator,y) = 'Empty' then
		  begin
		     list.addNode(xIterator,y,evaluatePiece(xIterator,y,moveBoard,side))
		  end

	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,y)) <> 0 then
	       begin
		  list.addNode(xIterator,y,evaluatePiece(xIterator,y,moveBoard,side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,y) <> 'Empty' then
		  break;
		  

	       end;

	       for yIterator := y+1 to 7 do
	       begin
		  if moveBoard.returnSquare(x,yIterator) = 'Empty' then
		  begin
		     list.addNode(x,yIterator,evaluatePiece(x,yIterator,moveBoard,side))
		  end

	       else if pos(opponentColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       begin
		  list.addNode(x,yIterator,evaluatePiece(x,yIterator,moveBoard,side));
		  break
	       end
	       else if moveBoard.returnSquare(x,yIterator) <> 'Empty' then
		  break;
	       end;

	       for yIterator := y-1 downto 0 do
	       begin
		  if moveBoard.returnSquare(x,yIterator) = 'Empty' then
		  begin
		     list.addNode(x,yIterator,evaluatePiece(x,yIterator,moveBoard,side))
		  end

	       else if pos(opponentColour, moveBoard.returnSquare(x,yIterator)) <> 0 then
	       begin
		  list.addNode(x,yIterator,evaluatePiece(x,yIterator,moveBoard,side));
		  break
	       end
	       else if moveBoard.returnSquare(x,yIterator) <> 'Empty' then
		  break;
	       end;

	       yIterator := y+1;
	       for xIterator := x+1 to 7 do
	       begin
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		     list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,yIterator) <> 'Empty' then
		  break;
		  inc(yIterator);
	       end;

	       yIterator := y-1;
	       for xIterator := x+1 to 7 do
	       begin
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		     list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,yIterator) <> 'Empty' then
		  break;
		  dec(yIterator);
	       end;

	       yIterator := y+1;
	       for xIterator := x-1 downto 0 do
	       begin
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		     list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,yIterator) <> 'Empty' then
		  break;
		  inc(yIterator);
	       end;


	       yIterator := y-1;
	       for xIterator := x-1 downto 0 do
	       begin
		  if moveBoard.returnSquare(xIterator,yIterator) = 'Empty' then
		     list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side))
	       else if pos(opponentColour, moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
	       begin
		  list.addNode(xIterator,yIterator, evaluatePiece(xIterator,yIterator, moveBoard, side));
		  break
	       end
	       else if moveBoard.returnSquare(xIterator,yIterator) <> 'Empty' then
		  break;
		  dec(yIterator);
	       end;
	       possibleSquares2DArray := list;
	    end;



	       'White King':
	    begin
	       if side = WHITE then
	       begin
		  if x < 7 then
		  begin
		     if moveBoard.returnSquare(x+1,y) = 'Empty' then
		     begin
			list.addNode(x+1,y, evaluatePiece(x+1,y, moveBoard, WHITE))
		     end
		  else if pos('Black', moveBoard.returnSquare(x+1,y)) <> 0 then
		  begin
		     list.addNode(x+1,y, evaluatePiece(x+1,y, moveBoard, WHITE));
		  end;
		  end;
		  if x > 0 then
		  begin
		     if moveBoard.returnSquare(x-1,y) = 'Empty' then
		     begin
			list.addNode(x-1,y, evaluatePiece(x-1,y, moveBoard, WHITE))
		     end
		  else if pos('Black', moveBoard.returnSquare(x-1,y)) <> 0 then
		  begin
		     list.addNode(x-1,y, evaluatePiece(x-1,y, moveBoard, WHITE));
		  end;
		  end;

		  if y < 7 then
		  begin
		     if moveBoard.returnSquare(x,y+1) = 'Empty' then
		     begin
			list.addNode(x,y+1, evaluatePiece(x,y+1, moveBoard, WHITE))
		     end
		  else if pos('Black', moveBoard.returnSquare(x,y+1)) <> 0 then
		  begin
		     list.addNode(x,y+1, evaluatePiece(x,y+1, moveBoard, WHITE));
		  end;
		  end;

		  if y > 0 then
		  begin
		     if moveBoard.returnSquare(x,y-1) = 'Empty' then
		     begin
			list.addNode(x,y-1, evaluatePiece(x,y-1, moveBoard, WHITE))
		     end
		  else if pos('Black', moveBoard.returnSquare(x,y-1)) <> 0 then
		  begin
		     list.addNode(x,y-1, evaluatePiece(x,y-1, moveBoard, WHITE));
		  end;
		  end;
		  if x < 7 then
		  begin
		     if y < 7 then
		     begin
			if moveBoard.returnSquare(x+1,y+1) = 'Empty' then
			begin
			   list.addNode(x+1,y+1, evaluatePiece(x+1,y+1, moveBoard, WHITE))
			end
		     else if pos('Black', moveBoard.returnSquare(x+1,y+1)) <> 0 then
		     begin
			list.addNode(x+1,y+1, evaluatePiece(x+1,y+1, moveBoard, WHITE))
		     end;
		     end;
		  end;

		  if x < 7 then
		  begin
		     if y > 0 then
		     begin
			if moveBoard.returnSquare(x+1,y-1) = 'Empty' then
			begin
			   list.addNode(x+1,y-1, evaluatePiece(x+1,y-1, moveBoard, WHITE))
			end
		     else if pos('Black', moveBoard.returnSquare(x+1,y-1)) <> 0 then
		     begin
			list.addNode(x+1,y-1, evaluatePiece(x+1,y-1,moveBoard, WHITE))
		     end;
		     end;
		  end;

		  if x > 0 then
		  begin
		     if y < 7 then
		     begin
			if moveBoard.returnSquare(x-1,y+1) = 'Empty' then
			begin
			   list.addNode(x-1,y+1, evaluatePiece(x-1,y+1, moveBoard, WHITE))
			end
		     else if pos('Black', moveBoard.returnSquare(x-1,y+1)) <> 0 then
		     begin
			list.addNode(x-1,y+1, evaluatePiece(x-1,y+1,moveBoard, WHITE))
		     end;
		     end;
		  end;

		  if x > 0 then
		  begin
		     if y > 0 then
		     begin
			if moveBoard.returnSquare(x-1,y-1) = 'Empty' then
			begin
			   list.addNode(x-1,y-1, evaluatePiece(x-1,y-1, moveBoard, WHITE))
			end
		     else if pos('Black', moveBoard.returnSquare(x-1,y-1)) <> 0 then
		     begin
			list.addNode(x-1,y-1, evaluatePiece(x-1,y-1,moveBoard, WHITE))
		     end;
		     end;
		  end;

		  if castleCheck(WHITE) = true then
		  begin
		     if moveBoard.returnSquare(0,1) = 'Empty' then
		     begin
			if moveBoard.returnSquare(0,2) = 'Empty' then
			   list.addNode(x,y-2,1);
		     end;
		  end;

		  


	       end;
	       

	       possibleSquares2DArray := list;
	    end;

	       'White Pawn':
	    begin
	       if side = WHITE then
	       begin
		  if x < 7 then
		  begin
		     if moveBoard.returnSquare(x+1,y) = 'Empty' then
		     begin
			list.addNode(x+1,y, evaluatePiece(x+1,y,moveBoard,WHITE));
		     end;
		     if y < 7 then
		     begin
			if pos('Black', moveBoard.returnSquare(x+1,y+1)) <> 0 then
			begin
			   list.addNode(x+1,y+1,evaluatePiece(x+1,y+1,moveBoard,WHITE));
			end;
		     end;
		     if y > 0 then
		     begin
			if pos('Black', moveBoard.returnSquare(x+1,y-1)) <> 0 then
			begin
			   list.addNode(x+1,y-1,evaluatePiece(x+1,y-1,moveBoard,WHITE));
			end;
		     end;
		     if x = 1 then
		     begin
			if moveBoard.returnSquare(x+1,y) = 'Empty' then
			begin
			   if moveBoard.returnSquare(x+2,y) = 'Empty' then
			   begin
			      list.addNode(x+2,y, evaluatePiece(x+2,y,moveBoard,WHITE));
			   end;
			end;
		     end;
		  end;
	       end;
	       result := list;
            end;
	       'Black King':
	    begin
	       if side = BLACK then
	       begin
		  if x < 7 then
		  begin
		     if moveBoard.returnSquare(x+1,y) = 'Empty' then
		     begin
			list.addNode(x+1,y, evaluatePiece(x+1,y, moveBoard, BLACK))
		     end
		  else if pos('White', moveBoard.returnSquare(x+1,y)) <> 0 then
		  begin
		     list.addNode(x+1,y, evaluatePiece(x+1,y, moveBoard, BLACK));
		  end;
		  end;
		  if x > 0 then
		  begin
		     if moveBoard.returnSquare(x-1,y) = 'Empty' then
		     begin
			list.addNode(x-1,y, evaluatePiece(x-1,y, moveBoard, BLACK))
		     end
		  else if pos('White', moveBoard.returnSquare(x-1,y)) <> 0 then
		  begin
		     list.addNode(x-1,y, evaluatePiece(x-1,y, moveBoard, BLACK));
		  end;
		  end;

		  if y < 7 then
		  begin
		     if moveBoard.returnSquare(x,y+1) = 'Empty' then
		     begin
			list.addNode(x,y+1, evaluatePiece(x,y+1, moveBoard, BLACK))
		     end
		  else if pos('White', moveBoard.returnSquare(x,y+1)) <> 0 then
		  begin
		     list.addNode(x,y+1, evaluatePiece(x,y+1, moveBoard, BLACK));
		  end;
		  end;

		  if y > 0 then
		  begin
		     if moveBoard.returnSquare(x,y-1) = 'Empty' then
		     begin
			list.addNode(x,y-1, evaluatePiece(x,y-1, moveBoard, BLACK))
		     end
		  else if pos('White', moveBoard.returnSquare(x,y-1)) <> 0 then
		  begin
		     list.addNode(x,y-1, evaluatePiece(x,y-1, moveBoard, BLACK));
		  end;
		  end;
		  if x < 7 then
		  begin
		     if y < 7 then
		     begin
			if moveBoard.returnSquare(x+1,y+1) = 'Empty' then
			begin
			   list.addNode(x+1,y+1, evaluatePiece(x+1,y+1, moveBoard, BLACK))
			end
		     else if pos('White', moveBoard.returnSquare(x+1,y+1)) <> 0 then
		     begin
			list.addNode(x+1,y+1, evaluatePiece(x+1,y+1, moveBoard, BLACK))
		     end;
		     end;
		  end;

		  if x < 7 then
		  begin
		     if y > 0 then
		     begin
			if moveBoard.returnSquare(x+1,y-1) = 'Empty' then
			begin
			   list.addNode(x+1,y-1, evaluatePiece(x+1,y-1, moveBoard, BLACK))
			end
		     else if pos('White', moveBoard.returnSquare(x+1,y-1)) <> 0 then
		     begin
			list.addNode(x+1,y-1, evaluatePiece(x+1,y-1,moveBoard, BLACK))
		     end;
		     end;
		  end;

		  if x > 0 then
		  begin
		     if y < 7 then
		     begin
			if moveBoard.returnSquare(x-1,y+1) = 'Empty' then
			begin
			   list.addNode(x-1,y+1, evaluatePiece(x-1,y+1, moveBoard, BLACK))
			end
		     else if pos('White', moveBoard.returnSquare(x-1,y+1)) <> 0 then
		     begin
			list.addNode(x-1,y+1, evaluatePiece(x-1,y+1,moveBoard, BLACK))
		     end;
		     end;
		  end;

		  if x > 0 then
		  begin
		     if y > 0 then
		     begin
			if moveBoard.returnSquare(x-1,y-1) = 'Empty' then
			begin
			   list.addNode(x-1,y-1, evaluatePiece(x-1,y-1, moveBoard, BLACK))
			end
		     else if pos('White', moveBoard.returnSquare(x-1,y-1)) <> 0 then
		     begin
			list.addNode(x-1,y-1, evaluatePiece(x-1,y-1,moveBoard, BLACK))
		     end;
		     end;
		  end;

		  if castleCheck(BLACK) = true then
		  begin
		     if moveBoard.returnSquare(7,1) = 'Empty' then
		     begin
			if moveBoard.returnSquare(7,2) = 'Empty' then
			   list.addNode(x,y-2,1);
		     end;
		  end;

		  


	       end;
	       

	       possibleSquares2DArray := list;
	    end;

	       'Black Pawn':
	    begin
	       if side = BLACK then
	       begin
		  if x > 0 then
		  begin
		     if moveBoard.returnSquare(x-1,y) = 'Empty' then
		     begin
			list.addNode(x-1,y, evaluatePiece(x+1,y,moveBoard,BLACK));
		     end;
		     if y < 7 then
		     begin
			if pos('White', moveBoard.returnSquare(x+1,y+1)) <> 0 then
			begin
			   list.addNode(x+1,y+1,evaluatePiece(x+1,y+1,moveBoard,BLACK));
			end;
		     end;
		     if y > 0 then
		     begin
			if pos('White', moveBoard.returnSquare(x+1,y-1)) <> 0 then
			begin
			   list.addNode(x+1,y-1,evaluatePiece(x+1,y-1,moveBoard,BLACK));
			end;
		     end;
		     if x = 6 then
		     begin
			if moveBoard.returnSquare(x-1,y) = 'Empty' then
			begin
			   if moveBoard.returnSquare(x-2,y) = 'Empty' then
			   begin
			      list.addNode(x-2,y, evaluatePiece(x-2,y,moveBoard,BLACK));
			   end;
			end;
		     end;
		  end;
	       end;
	       result := list;
	    end;

	       'Empty':
	    begin
	       result := list;
	    end;

	    end;
    end;

	    function TMoveCalculator.checkMateTest(gameBoard: IBoard; side: integer): boolean;

	    var
	       testBoard: IBoard;
	       temp: THeapLinkedList;
	       kingX, kingy, iterator, xIterator, yIterator, xIterator2, yIterator2,  tempA, tempB: integer;
//	       moveVector: array[0..567] of integer;
	       returnedVector, piece: string;
	       


	    begin

	       if side = BLACK then
	       begin
		  for xIterator := 0 to 7 do
		  begin
		     for yIterator := 0 to 7 do
		     begin
			if pos('Black', gameBoard.returnSquare(xIterator,yIterator)) = 0 then
			begin
			   temp := possibleSquares2DArray(xIterator,yIterator,gameBoard,side);
			   returnedVector := temp.returnVector;
			   iterator := 0;
			   while iterator <> length(returnVector) -1 do
			   begin
			      testBoard := gameBoard;
			      tempA := ord(returnedVector[iterator]);
			      tempB := ord(returnedVector[iterator+1]);
			      piece := testBoard.returnSquare(xIterator,yIterator);
			      testBoard.setSquare(xIterator,yIterator, 'Empty');
			      testBoard.setSquare(tempA,tempB, piece);
			      for xIterator2 := 0 to 7 do
			      begin
				 for yIterator2 := 0 to 7 do
				 begin
				    if testBoard.returnSquare(xIterator2,yIterator2) = 'Black King' then
				    begin
				       kingX := xIterator2;
				       kingY := yIterator2;
				    end;
				 end;
			      end;
			      
			      if checkCalculator(kingX, kingY, testBoard, side) = false then
			      begin
				 checkMateTest := false;
			      end;
			      iterator := iterator + 2;
			   end;
			end;
		    end;
	        end;
              end
	       else
	       begin
		  for xIterator := 0 to 7 do
		  begin
		     for yIterator := 0 to 7 do
		     begin
			if pos('White', gameBoard.returnSquare(xIterator,yIterator)) = 0 then
			begin
			   temp := possibleSquares2DArray(xIterator,yIterator,gameBoard,side);
			   returnedVector := temp.returnVector;
			   for iterator := 0 to length(returnedVector) -1 do
			   begin
			      tempA := ord(returnedVector[iterator]);
			      tempB := ord(returnedVector[iterator+1]);
			      piece := testBoard.returnSquare(xIterator,yIterator);
			      testBoard.setSquare(xIterator,yIterator,'Empty');
			      testBoard.setSquare(tempA,tempB,piece);
			      for xIterator2 := 0 to 7 do
			      begin
				 for yIterator2 := 0 to 7 do
				 begin
				    if testBoard.returnSquare(xIterator2,yIterator2) = 'White King' then
				    begin
				       kingX := xIterator2;
				       kingy := yIterator2;
				    end;
				 end;
			      end;
			      if checkCalculator(kingX,kingY,testBoard,side) = false then
			      begin
				 checkMateTest := false;
			      end;
			   end;
			end;
		     end;
		  end;
	       end;
	       
	       result := true;
	    end;


	    function TMoveCalculator.checkCalculator(x,y: integer; moveBoard: IBoard;side: integer): boolean;

	    var
	       returnedVector: string;
	       temp: THeapLinkedList;
	       moveVector: array[0 .. 567] of integer;
	       opponentSide,xIterator,yIterator,iterator,puck,tempA,tempB: integer;

	    begin
	       opponentSide := BLACK;
	       if side = BLACK then
	       begin
		  opponentSide := WHITE;
		  puck := 0;
		  for xIterator := 0 to 7 do
		  begin
		     for yIterator := 0 to 7 do
		     begin
			if pos('White', moveBoard.returnSquare(xIterator, yIterator)) <> 0 then
			begin
			   temp := possibleSquares2DArray(xIterator, yIterator, moveBoard, opponentSide);
			   returnedVector := temp.returnVector;
			   for iterator := 0 to length(returnedVector) - 1 do
			   begin
			      moveVector[iterator+puck] := StrToInt(returnedVector[iterator]);
			   end;
			   puck += length(returnVector);
			end;
		     end;
		  end;
	       end
	    else
	    begin
	       puck := 0;
	       for xIterator := 0 to 7 do
	       begin
		  for yIterator := 0 to 7 do
		     begin
			if pos('Black', moveBoard.returnSquare(xIterator,yIterator)) <> 0 then
			   begin
			      temp := possibleSquares2DArray(xIterator,yIterator, moveBoard, opponentSide);
			      returnedVector := temp.returnVector;
			      for iterator := 0 to length(returnedVector) -1 do
				 begin
				    moveVector[iterator+puck] := StrToInt(returnedVector[iterator]);
				 end;
			      puck += length(returnVector);
			   end;
		     end;
	       end;
	    end;
	       iterator := 0;
	       while iterator <> puck*2 -1 do
		  begin
		     tempA := moveVector[iterator];
		     tempB := moveVector[iterator+1];
		     if x = tempA then
			begin
			   if y = tempB then
			      begin
				 writeln('check baby !!!');
				 checkCalculator := true
			      end;
			end;
			iterator := iterator +2;
		  end;
	       result := false;
	    end;
end.

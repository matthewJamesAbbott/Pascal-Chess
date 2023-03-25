//
// Created by Matthew Abbott 25/3/2023
//

{$mode objfpc}
{$H+}

unit NetworkInterface;
interface
type
   transferMessage = array[ 0 .. 3] of integer;
   INetworkInterface = interface
      procedure send(Message: array of integer); virtual;abstract;
      function receive(): transferMessage; virtual;abstract;
end;

implementation

end.

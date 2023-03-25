{$mode objfpc}
{$H+}

unit Mitigator;

interface

type
  IMitigator = interface
    procedure handleNetworkInput(const message: string);virtual;abstract;
    procedure handleUserInput(const message: string);virtual;abstract;
    // add more message handlers as needed
  end;

  TMitigator = class(TInterfacedObject, IMitigator)
  public
    procedure handleNetworkInput(const message: string);virtual;
    procedure handleUserInput(const message: string);virtual;
    // add more message handlers as needed
  end;

implementation

procedure TMitigator.handleNetworkInput(const message: string);
begin
   if (length(message) = 0) then
	   writeln('no message transfered');
   if (length(message) > 3) then
	   writeln('message transfered but too long');

  // do something with the message
end;

procedure TMitigator.handleUserInput(const message: string);
begin
  // do something with the message
end;

// add more message handlers as needed

end.


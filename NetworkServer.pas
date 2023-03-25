{$mode objfpc}
{$H+}

unit NetworkServer;

interface

uses
  Classes, SysUtils, blcksock in './synapse/blcksock.pas', sockets,
  synsock in './synapse/synsock.pas', SynaUtil in './synapse/synautil.pas',
  synachar in './synapse/synachar.pas', synafpc in './synapse/synafpc.pas',
  synacode in './synapse/synacode.pas', synaip in './synapse/synaip.pas',
  synaicnv in './synapse/synaicnv', NetworkInterface, Mitigator;

type
  transferMessage = array[0..3] of integer;

  TNetworkServer = class(TInterfacedObject, INetworkInterface)
  private
    FServerSocket: TTCPBlockSocket;
    FClientSocket: TTCPBlockSocket;
    FMitigator: TMitigator;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Send(Message: array of integer); virtual;
    function Receive(): transferMessage; virtual;
    procedure HandleMessage(Msg: string);
  end;

implementation

constructor TNetworkServer.Create();
begin
  inherited Create;
  FServerSocket := TTCPBlockSocket.Create;
  FServerSocket.CreateSocket;
  FServerSocket.Bind('127.0.0.1', '5000');
  FServerSocket.Listen;

  FClientSocket := TTCPBlockSocket.Create;
  FClientSocket.Socket := FServerSocket.Accept;

  if FClientSocket.LastError = 0 then
  begin
    writeln('Client connected: ', FClientSocket.GetRemoteSinIP);
  end
  else
  begin
    writeln('Error accepting client: ', FClientSocket.LastErrorDesc);
    FClientSocket.Free;
  end;

  FMitigator := TMitigator.Create;
end;

destructor TNetworkServer.Destroy();
begin
  FMitigator.Free;
  FClientSocket.Free;
  FServerSocket.Free;
  inherited Destroy;
end;

procedure TNetworkServer.Send(Message: array of integer);
begin
  FClientSocket.SendBuffer(@Message, Length(Message) * SizeOf(Integer));
end;

function TNetworkServer.Receive(): transferMessage;
var
  Size: integer;
begin
  Size := FClientSocket.RecvBuffer(@Result, SizeOf(transferMessage));
  if Size = 0 then
  begin
    writeln('Client disconnected');
    FClientSocket.CloseSocket;
    FClientSocket.Socket := FServerSocket.Accept;
  end;
end;

procedure TNetworkServer.HandleMessage(Msg: string);
begin
  FMitigator.handleNetworkInput(Msg);
end;

end.

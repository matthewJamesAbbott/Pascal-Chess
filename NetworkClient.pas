{$mode objcfpc}
{$H+}

unit NetworkClient;
interface

uses
      Classes, SysUtils, blcksock in './synapse/blcksock.pas', sockets, synsock in './synapse/synsock.pas',
   SynaUtil in './synapse/synutil.pas', synachar in './synapse/synachar.pas' ,
   synafpc in './synapse/synafpc.pas', synacode in './synapse/synacode.pas',
   synaip in './synapse/synaip.pas', synaicnv in './synapse/synaicnv.pas', NetworkInterface;


unit ubinaryfiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  f:file;
  tf:TextFile;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var a:integer;
    b:real;
begin
  //simple blockwrite
  a:=100;
  b:=123.456;
  AssignFile(f,'testfile.bnf');
  rewrite(f,1);
  blockwrite(f,a,sizeof(a));
  blockwrite(f,b,sizeof(b));
  CloseFile(f);
end;

procedure TForm1.Button2Click(Sender: TObject);
var stext:string;
    stext_sz:longint;
begin
  //1 - read data to string
  AssignFile(tf,'bigtext.txt');
  reset(tf);
  while not eof(tf) do
  begin
    readln(tf,stext);
  end;
  CloseFile(tf);

  if (FileExists('bigtext.bnf')) then DeleteFile('bigtext.bnf');

  //2 - let's write data from string to binary
  //2.1 - Init file
  AssignFile(f,'bigtext.bnf');
  rewrite(f,1);
  //2.2 - Write size of text data
  stext_sz:=sizeof(stext);
  blockwrite(f,stext_sz,sizeof(longint));
  //2.3 - Write the text
  blockwrite(f,stext,sizeof(stext));
  //2.4 - Job done
  CloseFile(f);

  //3 - remove all data
  stext:='';
  stext_sz:=0;

  //4 - Now, to read the data
  AssignFile(f,'bigtext.bnf');
  reset(f,1);

  BlockRead(f,stext_sz,sizeof(longint));
  BlockRead(f,stext,stext_sz);

  //5 - show off the result
  if (FileExists('bigtext_out.txt')) then DeleteFile('bigtext_out.txt');

  AssignFile(tf,'bigtext_out.txt');
  rewrite(tf);
  writeln(tf,stext);
  CloseFile(tf);

  Memo1.Text:=stext;

end;

end.


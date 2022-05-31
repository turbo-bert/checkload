program checkload;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  fphttpclient,
  opensslsockets,
  openssl,
  process,
{$IFDEF Darwin}
  unixtype,
{$ENDIF Darwin}
  StrUtils;


procedure line_sep();
begin
   WriteLn('==============================================================================');
end;

function sha512_file(filename:string): string;
const
  bs=8192;
var
  mdlength: integer;
  s: string;
  h: array [0..2048] of byte;
  hash_str: string;
  ibuf, obuf: array[0..bs-1] of char;
  mdctx: EVP_MD_CTX;
  i: integer;

  f: file of byte;
  c: longint; // counter for actually read bytes
  b: array[0..bs-1] of byte; // buffer
  bl: array[0..bs-1] of byte; // last buffer
  result_l: longint;
  size_actual: longint;
  full_blocks: longint;
  block_i: longint;
  tail_size: longint;
  
  iii: longint;
begin


AssignFile(f, filename);
reset(f, 1);
size_actual:=FileSize(f);
reset(f, bs);
full_blocks:=FileSize(f);
tail_size:=size_actual - (full_blocks*bs);


EVP_DigestInit(@mdctx, EVP_get_digestbyname('SHA512'));


for block_i:= 0 to full_blocks-1 do
    begin
      BlockRead(f, b, 1, result_l);
      c := c + result_l*bs;
      EVP_DigestUpdate(@mdctx, @b, bs);

    end;


if tail_size > 0 then
begin
  reset(f, 1);
  //memo1.Append('prep for tail READ');
  Seek(f, bs*full_blocks);
  BlockRead(f, bl, tail_size, result_l);
  c:=c + result_l;
  //memo1.Append('READ actual of tail is ' + inttostr(result));
      EVP_DigestUpdate(@mdctx, @bl, tail_size);

end;

closefile(f);

    EVP_DigestFinal(@mdctx, @h, @mdlength);
    SetLength(hash_str, 2*mdlength);
    BinToHex(@h, PChar(hash_str), mdlength);
    result :=LowerCase(hash_str);
end;


procedure curl_download(url : string; outfile:string);
    var
       client       : TFPHTTPClient;
       p         :  TProcess;
    begin
    //writeln('download ['+url+'] to ['+out_filename+']');
       p:=TProcess.Create(nil);
       p.Executable := 'curl';
       //p.Parameters.Add('-s');
       p.Parameters.Add('-L');
       p.Parameters.Add('-o');
       p.Parameters.Add(outfile);
       p.Parameters.Add(url);
       p.options := p.options + [poWaitOnExit];
       p.execute();
       p.free();
    end;




var
   f					      : Textfile;
   hash_line, file_line, url_line, dummy_line : string;
   hash_actual				      : string;
   count_errors				      : int64;
begin
   count_errors := 0;
//   line_sep();
    WriteLn('                      _               _    _                 _ ');
    WriteLn('                  ___| |__   ___  ___| | _| | ___   __ _  __| |');
    WriteLn('                 / __| |_ \ / _ \/ __| |/ / |/ _ \ / _` |/ _` |');
    WriteLn('                | (__| | | |  __/ (__|   <| | (_) | (_| | (_| |');
    WriteLn('                 \___|_| |_|\___|\___|_|\_\_|\___/ \__,_|\__,_|');
    WriteLn('                                                               ');
    WriteLn('CHECKLOAD CLI v0.1.0 2022 ROBERT DEGEN https://github.com/turbo-bert/checkload');
    WriteLn('                 THIS SOFTWARE COMES FREE AND WITHOUT WARRANTY');
   line_sep();
//   WriteLn('Loading checkload.txt...');

   if not FileExists('checkload.txt') then
      begin
   WriteLn('');
	 WriteLn('No file "checkload.txt" found, exiting.');
     WriteLn('');
     WriteLn('  +-------------------------------------------------+');
     WriteLn('  |                                                 |');
     WriteLn('  |     Want to create a new "checkload.txt" ?      |');
     WriteLn('  |     It should look like...                      |');
     WriteLn('  |                                                 |');
     WriteLn('  |         Line 1: <hex-lowercase-sha512>          |');
     WriteLn('  |         Line 2: <filename>                      |');
     WriteLn('  |         Line 3: <url>                           |');
     WriteLn('  |         Line 4: <empty-or-whatever>             |');
     WriteLn('  |         Line 5: Repeat like from Line 1         |');
     WriteLn('  |                 ...                             |');
     WriteLn('  |                                                 |');
     WriteLn('  +-------------------------------------------------+');
     WriteLn('');
	 halt(2);
      end;

   
   AssignFile(f, 'checkload.txt');
   Reset(f);
   while not eof(f) do
      begin
	 ReadLn(f, hash_line);
	 ReadLn(f, file_line);
	 ReadLn(f, url_line);
	 ReadLn(f, dummy_line);
//	 line_sep();
	 WriteLn('');
     WriteLn('Download Request for ['+file_line+']');
	 line_sep();
	 if FileExists('checkload_' + file_line) then
	    begin
	       WriteLn('-> File exists, rehashing...');
	       hash_actual := sha512_file('checkload_' + file_line);
	       if hash_actual <> hash_line then
		  begin
           WriteLn('-> Hash is ***NOT*** OK -------------------------- !!!!!!!!!!!!!!!!');
		     //WriteLn('WARNING: Illegal File, removing. You will have to manually start another run!');
		     DeleteFile('checkload_' + file_line);
		  end;
	    end
	 else
	    begin
	       curl_download(url_line, '.tmpfile');
	       hash_actual := sha512_file('.tmpfile');
	    end;
	 if hash_actual = hash_line then
	    begin
	       WriteLn('-> Hash is OK');
	       RenameFile('.tmpfile', 'checkload_' + file_line);
	    end
	 else
	    begin
	       WriteLn('-> Hash is ***NOT*** OK -------------------------- !!!!!!!!!!!!!!!!');
	       count_errors := count_errors + 1;
	    end;
      end;
   CloseFile(f);
   WriteLn('');
   WriteLn('Errors:' + inttostr(count_errors));
   if count_errors = 0 then
     begin
         halt(0);
     end
   else
     begin
         halt(1);
     end;
end.

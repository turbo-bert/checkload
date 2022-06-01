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
//   WriteLn('==============================================================================');
end;


function line1(filename	: string ): string;
var
      f	: Textfile;
   s	: string;
begin
   AssignFile(f, filename);
   Reset(f);
   ReadLn(f, s);
   CloseFile(f);
   result := s;
end;

function sha512_str(text:string): string;
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
begin
s := text;
StrPCopy(ibuf, s);
EVP_DigestInit(@mdctx, EVP_get_digestbyname('SHA512'));
EVP_DigestUpdate(@mdctx, @ibuf, length(s));
EVP_DigestFinal(@mdctx, @h, @mdlength);

SetLength(hash_str, 2*mdlength);
BinToHex(@h, PChar(hash_str), mdlength);

result :=LowerCase(hash_str);

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
  Seek(f, bs*full_blocks);
  BlockRead(f, bl, tail_size, result_l);
  c:=c + result_l;
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

procedure curl_download_silent(url : string; outfile:string);
    var
       client       : TFPHTTPClient;
       p         :  TProcess;
    begin
       p:=TProcess.Create(nil);
       p.Executable := 'curl';
       p.Parameters.Add('-s');
       p.Parameters.Add('-L');
       p.Parameters.Add('-o');
       p.Parameters.Add(outfile);
       p.Parameters.Add(url);
       p.options := p.options + [poWaitOnExit];
       p.execute();
       p.free();
    end;


procedure command_x();
var
      f: Textfile;
begin
   AssignFile(f, 'checkload-example.txt');
   Rewrite(f);

   WriteLn(f, '6eb1755256f4f77c84d8cda4a2087f62a5fe129d23c2b0674e1ec8eccc9282ca0fe5fe6320c11d9c1aeb0e91f47baee416ebef02f77d35982074e21229179236');
   WriteLn(f, 'firefox-installer-x64.exe');
   WriteLn(f, 'https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US');
   WriteLn(f, '');

   WriteLn(f, '6eb1755256f4f77c84d8cda4a2087f62a5fe129d23c2b0674e1ec8eccc9282ca0fe5fe6320c11d9c1aeb0e91f47baee416ebef02f77d35982074e21229179236');
   WriteLn(f, 'firefox-installer-x64.exe');
   WriteLn(f, 'https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US');
   WriteLn(f, '');
   
   CloseFile(f);
end;

procedure command_t();
var
      f,f2	    : Textfile;
   info	    : TSearchRec;
   filename : string;
   h	    : string;
   url_line :  string;
begin
   AssignFile(f, 'checkload-template.txt');
      AssignFile(f2, 'checkload-template-x.txt');
   Rewrite(f);
      Rewrite(f2);

   if FindFirst('*', faAnyFile, info)=0 then
      begin
	 repeat
	    filename := info.Name;
	    if filename = '.' then
	       continue;
	    if filename = '..' then
	       continue;
	    if DirectoryExists(filename) then
	       continue;
	    if filename.EndsWith('.checkload_url') then
	       continue;
	    h := sha512_file(filename);
	    WriteLn(f, h);
	    WriteLn(f, info.Name);
	    if FileExists(filename + '.checkload_url') then
	       begin
		  url_line := line1(filename + '.checkload_url');

		  // collect only explicit preset urls
		  WriteLn(f2, h);
		  WriteLn(f2, info.Name);
		  WriteLn(f2, url_line);
		  WriteLn(f2, '');

	       end
	    else
	       begin
		  url_line := 'https://127.0.0.1/' + info.Name;
	       end;
	    WriteLn(f, url_line);
	    WriteLn(f, '');
	 until FindNext(info) <> 0;
	 FindClose(info);
      end;
   
   CloseFile(f);
      CloseFile(f2);
end;




procedure show_help();
begin
   WriteLn('-------------------------------------------------------------------------------------------------');
   WriteLn('    You can use checkload for:');
   WriteLn('        ');
   WriteLn('        >> showing its own version information');
   WriteLn('           "checkload version"');
   WriteLn('        ');
   WriteLn('        >> downloading all files defined in "checkload.txt"');
   WriteLn('           "checkload run"');
   WriteLn('        ');
   WriteLn('        >> downloading all files defined in "checkload.txt" and see curl output');
   WriteLn('           "checkload run -v"');
   WriteLn('        ');
   WriteLn('        >> creating a file "checkload-example.txt" to understand the file format');
   WriteLn('           "checkload x"');
   WriteLn('        ');
   WriteLn('        >> creating a file "checkload-template.txt" from all files in the CWD');
   WriteLn('           "checkload t"');
   WriteLn('        ');
   WriteLn('        >> computing a sha512 digest from a file');
   WriteLn('           "checkload sha512 file <FILENAME>"');
   WriteLn('        ');
   WriteLn('        >> computing a sha512 digest from a string (<8192 chars)');
   WriteLn('           "checkload sha512 str <STRING>"');
   WriteLn('        ');
   WriteLn('        >> creating "no-checkload.bat" for execution on a system without checkload');
   WriteLn('           "checkload bat"');
   WriteLn('        ');
   WriteLn('-------------------------------------------------------------------------------------------------');
end;

procedure command_run(curl_silent : Boolean );
var
   f					      : Textfile;
   hash_line, file_line, url_line, dummy_line : string;
   hash_actual				      : string;
   count_errors				      : int64;
begin
   count_errors := 0;
   
   if not FileExists('checkload.txt') then
      begin
	 WriteLn('No file "checkload.txt" found, exiting.');
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
	       WriteLn('>> File exists, rehashing...');
	       hash_actual := sha512_file('checkload_' + file_line);
	       if hash_actual <> hash_line then
		  begin
           WriteLn('>> Hash is ***NOT*** OK -------------------------- !!!!!!!!!!!!!!!!');
		     //WriteLn('WARNING: Illegal File, removing. You will have to manually start another run!');
		     DeleteFile('checkload_' + file_line);
		  end;
	    end
	 else
	    begin
	       if curl_silent then
	             begin
			curl_download_silent(url_line, '.tmpfile');
		     end
		  else
		     begin
			curl_download(url_line, '.tmpfile');
		     end;
	       hash_actual := sha512_file('.tmpfile');
	    end;
	 if hash_actual = hash_line then
	    begin
	       WriteLn('>> Hash is OK');
	       RenameFile('.tmpfile', 'checkload_' + file_line);
	    end
	 else
	    begin
	       WriteLn('>> Hash is ***NOT*** OK -------------------------- !!!!!!!!!!!!!!!!');
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
end;

procedure command_bat();
var
   f,g					      : Textfile;
   hash_line, file_line, url_line, dummy_line : string;
begin
   if not FileExists('checkload.txt') then
      begin
	 WriteLn('No file "checkload.txt" found, exiting.');
	 halt(2);
      end;


   AssignFile(g, 'no-checkload.bat');
   Rewrite(g);
   
   AssignFile(f, 'checkload.txt');
   Reset(f);
   while not eof(f) do
      begin
	 ReadLn(f, hash_line);
	 ReadLn(f, file_line);
	 ReadLn(f, url_line);
	 ReadLn(f, dummy_line);
	 WriteLn(g, '@echo ** File Download *************************************');
	 WriteLn(g, 'curl -L -o "checkload_'+file_line+'" "'+url_line+'"');
	 WriteLn(g, '@echo ** Hash Definition ***********************************');
	 WriteLn(g, '@echo '+hash_line);
	 WriteLn(g, '@echo ** Hash Actual Download ******************************');
	 WriteLn(g, 'certutil -hashfile "'+file_line+'" sha512');
	 WriteLn(g, '@echo ******************************************************');
	 WriteLn(g, '');
      end;
   CloseFile(f);
   CloseFile(g);
end;


procedure command_version();
begin
   WriteLn('CHECKLOAD v1.0.0 (C) 2022 ROBERT DEGEN - FREEWARE');
end;


var
   arg_i    : longint;
   hash_out :  string;
begin
   if ParamCount = 0 then
      begin
	 halt(0);
      end
   else
      begin
	 if ParamStr(1) = 'x' then
	    begin
	       command_x();
	       halt(0);
	    end;
	 if ParamStr(1) = 't' then
	    begin
	       command_t();
	       halt(0);
	    end;
	 if ParamStr(1) = 'version' then
	    begin
	       command_version();
	       halt(0);
	    end;
	 if ParamStr(1) = 'bat' then
	    begin
	       command_bat();
	       halt(0);
	    end;
	 if (ParamStr(1) = 'help') or (ParamStr(1) = 'h') or (ParamStr(1) = '-h') or (ParamStr(1) = '/?') then
	    begin
	       show_help();
	       halt(0);
	    end;
	 if ParamStr(1) = 'run' then
	    begin
	       if (ParamCount >= 2) and (ParamStr(2) = '-v') then
	           begin
		      command_version();
		      command_run(False);
		   end
	       else
	           begin
		      command_version();
		      command_run(True);
	           end;
	       halt(0);
	    end; // end of 'run'
	 if ParamStr(1) = 'sha512' then
	    begin
	       if (ParamCount >= 3) and (ParamStr(2) = 'str') then
	           begin
		      hash_out := sha512_str(ParamStr(3));
		      WriteLn(hash_out);
		      halt(0);
		   end;
	       if (ParamCount >= 3) and (ParamStr(2) = 'file') then
	           begin
		      hash_out := sha512_file(ParamStr(3));
		      WriteLn(hash_out);
		      halt(0);
		   end;

	    end;
      end;

   halt(0);
end.

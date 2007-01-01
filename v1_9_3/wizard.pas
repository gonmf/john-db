program wizard;
uses wincrt;
var
menu: char;
file1: text;
var1,var2: longint;
cont1,cont2: longint;
dbextense: longint;
names: array[1..2048] of string[15];
begin
randomize;
repeat
clrscr;
write(' John DB Wizard');
writeln;
writeln('1 <> Restore');
writeln('2 <> Plugin');
readln(menu);
until (menu='1') or (menu='2');
case menu of
'1': begin
clrscr;
assign(file1,'syntax.ini');
rewrite(file1);
write(file1,'0');
close(file1);
writeln('Restore Complete');
writeln('(Please delete the DB files manually)');
readkey;
donewincrt;
end;
'2': begin
repeat
repeat
clrscr;
writeln('John DBs Extense? (EX: 64, 256, 1024) CAUTION!');
readln(dbextense);
until (dbextense>=2) and (dbextense<=32768);
dbextense:=dbextense-1;
clrscr;
writeln('How many DB files? Max:',dbextense);
readln(var1);
until (var1>0) and (var1<=dbextense);
repeat
clrscr;
writeln('How many DB files? Max:',dbextense);
writeln(var1);
writeln;
writeln('How many entries per DB? Max:',dbextense);
readln(var2);
until (var2>0) and (var2<=dbextense);
assign(file1,'buffer.ini');
rewrite(file1);
for cont1:=1 to var1 do writeln(file1,'F',cont1,'.db');
close(file1);
assign(file1,'buffer.ini');
reset(file1);
for cont1:=1 to var1 do readln(file1,names[cont1]);
erase(file1);
close(file1);  
assign(file1,'syntax.ini');
rewrite(file1);
writeln(file1,'1');
writeln(file1,'0');
writeln(file1,var1);
for cont1:=1 to var1 do writeln(file1,names[cont1]);
close(file1);    
for cont1:=1 to var1 do begin
assign(file1,names[cont1]);
rewrite(file1);
writeln(file1,'DBnr',cont1);
for cont2:=1 to var2 do begin
writeln(file1,'Item',cont2);
writeln(file1,random(9999)+1);
writeln(file1,((random(9999))+1)/(random(4)+3)/100);
end;
write(file1,'<eof>');
close(file1);
end;
writeln;
writeln('Plugin Complete');
readkey;
donewincrt;
end;
end;
end.
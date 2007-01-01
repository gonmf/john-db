program john;
uses wincrt;
const
dataversion='1.9.3';
programfile='john.exe';
syntaxfile='syntax.ini';
dbextense=1149; { Reccomended: 1024 }
timer=round(dbextense/64);
var
listsize: file of byte;
listuse: text;
menu: char;
num1,aux2,aux3,aux4,cont1: word;
aux8,aux10: real;
aux5,aux6: longint;
aux1,aux9: string[15];
buffering: array[1..15] of char;
name: array[1..dbextense] of string[15];
qty: array[1..dbextense] of word;
price: array[1..dbextense] of real;
db: array[1..dbextense] of string[12];
dbnum,dbqty,dbuses: longint;  
dbname: string[15];         
newdb: record
oth1: string[5];
oth2,oth3: string[15];
end;
procedure writingsyntax;
begin
assign(listuse,syntaxfile);
rewrite(listuse);
writeln(listuse,dbnum);
writeln(listuse,dbuses);
writeln(listuse,dbqty);
for cont1:=1 to dbqty do writeln(listuse,db[cont1]);
close(listuse);
end;
procedure readingsyntax;
begin
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,dbnum);
readln(listuse,dbuses);
readln(listuse,dbqty);
for cont1:=1 to dbqty do readln(listuse,db[cont1]);
close(listuse);
end;
procedure writing;
begin
assign(listuse,db[dbnum]);
rewrite(listuse);
num1:=1;
writeln(listuse,dbname);
repeat
if qty[num1]>0 then begin
writeln(listuse,name[num1]);
writeln(listuse,qty[num1]);
writeln(listuse,price[num1]);
end;
num1:=num1+1;
until name[num1]='<eof>';
write(listuse,'<eof>');
close(listuse);
end;
procedure reading;
begin
assign(listuse,db[dbnum]);
reset(listuse);
num1:=0;
readln(listuse,dbname);
repeat
num1:=num1+1;
readln(listuse,name[num1]);
if name[num1]<>'<eof>' then begin
readln(listuse,qty[num1]);
readln(listuse,price[num1]);
end;
until name[num1]='<eof>';
num1:=num1-1;
close(listuse);
end;
procedure timemaker;
begin
gotoxy(72,25);
write('Loading');
for cont1:=1 to timer do begin
assign(listuse,'buffer.ini');
rewrite(listuse);
write(listuse,'timer');
close(listuse);
assign(listuse,'buffer.ini');
reset(listuse);
erase(listuse);
close(listuse);
end;
end; 
procedure proc2_8;
begin
repeat
clrscr;
writeln;
writeln(' a - Reinstall/Reset Program');
writeln(' b - Uninstall Program');
writeln;
writeln(' 0 - Cancel');
readln(menu);
until (menu='a') or (menu='b') or (menu='0');
if menu='a' then begin
clrscr;
writeln('Warning: This will erase every registered Data Base and reset the program files. ');
writeln('         This operation cannot be undone.');
writeln;
writeln('Are you absolutly sure you wish to proceed? To Reset the program input 0,');
writeln('any other input will override this operation.');
writeln;
write('If you understand the losses type 0: ');
readln(buffering[1]);
if buffering[1]='0' then begin
writeln;
for aux5:=1 to dbqty do begin
assign(listuse,db[aux5]);
reset(listuse);
erase(listuse);
close(listuse);
end;
assign(listuse,syntaxfile);
rewrite(listuse);
writeln(listuse,'0');
close(listuse);
writeln('Program reset, it will shut down now.');
writeln('You will need to manually restart it anew.');
readkey;
donewincrt;
end
else begin
writeln;
writeln('Reset cancelled. Press any key.');
readkey;
end;
end else
if menu='b' then begin
clrscr;
writeln('Warning: This will erase every registered Data Base and the program files. ');
writeln('         This operation cannot be undone.');
writeln;
writeln('Are you absolutly sure you wish to proceed? To Uninstall the program input 0, any');
writeln('other input will override this operation.');
writeln;
write('If you understand the losses type 0: ');
readln(buffering[1]);
if buffering[1]='0' then begin
writeln;
for aux5:=1 to dbqty do begin
assign(listuse,db[aux5]);
reset(listuse);
erase(listuse);
close(listuse);
end;
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
assign(listuse,programfile);
reset(listuse);
erase(listuse);
close(listuse);
timemaker;
clrscr;
writeln('Program uninstalled successfully, it will shut down now.');
readkey;
donewincrt
end
else begin
writeln;
writeln('Uninstall cancelled. Press any key.');
readkey;
end;
end;
end;
procedure proc2_7;
begin
clrscr;
aux5:=0;
for cont1:=1 to dbqty do
if cont1 mod 24 = 0 then aux5:=aux5+1;
aux6:=0;
for cont1:=1 to dbqty do begin
if cont1<10 then write('  ') else
if cont1<100 then write(' ');
write(cont1,' - ',db[cont1],' ('); 
assign(listsize,db[cont1]);
reset(listsize);
if filesize(listsize)<1024 then writeln(filesize(listsize),' bytes)')
else writeln(filesize(listsize)/1024:0:2,' KB)');
close(listsize);                   
if cont1 mod 24 = 0 then begin
aux6:=aux6+1;
write(' Page ',aux6,'/',aux5+1);
readkey;
clrscr;
end;
end;
readkey;
end;
procedure proc2_6;
begin
repeat
aux2:=0;
clrscr;
writeln('CAUTION: If you choose to erase the current data base it will be lost for ever.');
writeln('         To delete ALL your DBs at once please use the Reinstall option.');
writeln('         Input 0 to cancel operation.');
writeln;
write('Data Base file name: ');
readln(newdb.oth1);
if newdb.oth1='0' then begin
writeln;
write('Cancelled');
aux2:=1;
readkey;
end else begin    
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 5 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 5 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1,'.db');
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
read(listuse,newdb.oth3);
close(listuse);
for cont1:=1 to dbqty do
if newdb.oth3=db[cont1] then aux2:=aux2+1;
if aux2=0 then begin
writeln('File could not be found.');
readkey;
end;
end;
until aux2>0;
if newdb.oth1<>'0' then begin
if newdb.oth3<>'0.db' then begin
assign(listuse,syntaxfile);
rewrite(listuse);
writeln(listuse,1);
writeln(listuse,dbuses);
writeln(listuse,dbqty-1);
for cont1:=1 to dbqty do
if db[cont1]<>newdb.oth3 then writeln(listuse,db[cont1]);
close(listuse);
assign(listuse,newdb.oth3);
reset(listuse);
erase(listuse);
close(listuse);
readingsyntax;
reading;
writeln;
writeln('Operation Successfull');
writeln('Now using DB ',dbnum,'/',dbqty,', ',db[dbnum]);
readkey;
end;
end;
end;
procedure proc2_5;
begin
repeat
aux2:=0;
clrscr;
writeln;
writeln('CAUTION: Maximum length of file names is five (5) characters.');
writeln('         Do NOT write extensions, .db is the default.');
writeln('         DBs that do not comply with version ',dataversion,' requisits');
writeln('         may crash the program. Input 0 to abort operation.');
writeln;
write('Data Base file name: ');
repeat
readln(newdb.oth1);
until newdb.oth1<>'<eof>';
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 5 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 5 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1,'.db');
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
read(listuse,newdb.oth3);
close(listuse);
for cont1:=1 to dbqty do
if newdb.oth3=db[cont1] then aux2:=aux2+1;
if aux2>0 then begin
writeln('File already exists in library');
readkey;
end;
until (aux2=0) or (newdb.oth3='0.db');
if newdb.oth3<>'0.db' then begin
db[dbqty+1]:=newdb.oth3;
dbqty:=dbqty+1;
dbnum:=dbqty;  
reading;  
writingsyntax;
end;
end;
procedure proc2_4;
begin
clrscr;
if dbqty>=dbextense then begin
writeln('Program DB extense full, erase old data bases to create new ones.');
readkey;
end else begin
writeln('Data Base Compatibility Version: ',dataversion);
write('Data Base file name: ');
repeat
readln(newdb.oth1);
until (newdb.oth1<>'0') and (newdb.oth1<>'<eof>');
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 5 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 5 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,newdb.oth1);
close(listuse);
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1,'.db');
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
read(listuse,newdb.oth3);
close(listuse);
write('Data Base Name: ');
repeat
readln(newdb.oth2);
until (newdb.oth2<>'0') and (newdb.oth2<>'<eof>');
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth2);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 15 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 15 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,newdb.oth2);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
aux4:=0;
dbname:=newdb.oth2;
repeat
write(' New item name: ');
readln(aux1);     
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 15 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 15 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
writingsyntax;
until aux1<>'<eof>';
write(' Quantity: ');
repeat
readln(aux3);
until aux3>0;
write(' Price: ');
repeat
readln(aux8);
until aux8>0;
num1:=1;
name[num1]:=aux1;
qty[num1]:=aux3;
price[num1]:=aux8;
num1:=num1+1;
dbqty:=dbqty+1;
dbnum:=dbqty;
db[dbnum]:=newdb.oth3;
name[num1]:='<eof>';
writingsyntax;
writing;
end;
end;
procedure proc2_3;
begin
clrscr;
writeln('Type the desired new name:');
write(dbname);
gotoxy(0,2);
readln(aux1);                
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 15 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 15 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
dbname:=aux1;
writing;
end;
procedure proc2_2;
begin      
clrscr;
writeln('Type the desired new file name:  (Input 0 to cancel)');
write(db[dbnum]);
gotoxy(0,2);
repeat
readln(newdb.oth1);
until newdb.oth1<>'<eof>';
if newdb.oth1='0' then begin
writeln;
writeln('Cancelled');
readkey;
end else begin
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,newdb.oth1,'.db');
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 8 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 8 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,newdb.oth3);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
writingsyntax;
assign(listuse,db[dbnum]);
reset(listuse);
erase(listuse);
close(listuse);
db[dbnum]:=newdb.oth3;
writingsyntax;
writing;
reading;
end;
end;     
procedure proc2_1;
begin
repeat 
clrscr;
writeln('Warning: Are you sure you want to change your predefined Data Base?');
writeln('         Other users who might also use this program will have to rechange it');
writeln('         later.');
writeln;
writeln('All the data you had in the previous Data Base will not be erased.');
writeln;
write('Please input the number (1-',dbqty,') of the desired database: ');
readln(dbnum);
until (dbnum>=1) and (dbnum<=dbqty);
writingsyntax;
writeln;
writeln('The now at use Data Base has been changed to the nr ',dbnum,'.');
writeln('This is backedup with the file ',db[dbnum],'.');
readkey;
end;
procedure proc1_8;
begin
clrscr;
writeln(' Important Notice');
writeln('01: Maximum number of DBs in library: ',dbextense);
writeln('02: Maximum number of entrys per DB: ',dbextense);
writeln('03: Maximum number of chars per DB name: 15');
writeln('04: Maximum number of chars per DB file name: 12');
writeln('05: Maximum quantity per item: 65536');
writeln('06: Maximum number of uses before reset: 2147483647');
writeln('07: Forbidden keywords: <eof>, 0');
writeln('');
writeln(' Advice/Tips');
writeln('01: Never try out incorrect inputs, program may crash.');
writeln('02: Never open the syntax.ini file.');
writeln('03: Use easily to comprehend file names.');
writeln('04: If you report a bug email anakinxiii@hotmail.com .');
writeln('');
writeln(' Minimal requirements');
writeln('01: 75KB RAM free.');
writeln('02: Writeable directory.');
writeln('03: QWERTY/ASCII Keyboard.');
readkey;
end;
procedure proc1_7; { MISS }
begin
clrscr;
write('Not Ready Yet');
readkey;
end;
procedure proc1_6;
begin
clrscr;
reading;
aux8:=0;
for cont1:=1 to num1 do
aux8:=aux8+qty[num1];
writeln(' Nr of items: ',num1);
writeln(' Average Quantity: ',aux8/num1:0:0);
aux8:=0;
for cont1:=1 to num1 do
aux8:=aux8+price[cont1];
writeln(' Average Price: ',aux8/num1:0:2);
aux8:=0;
for cont1:=1 to num1 do
if qty[cont1]>aux8 then aux8:=qty[cont1];
writeln(' Largest Quantity: ',aux8:0:0);
for cont1:=num1 downto 1 do
if qty[cont1]<aux8 then aux8:=qty[cont1];
writeln(' Lowest Quantity: ',aux8:0:0);
aux8:=0;
for cont1:=1 to num1 do
if price[cont1]>aux8 then aux8:=price[cont1];
writeln(' Bigger Price: ',aux8:0:2);
for cont1:=num1 downto 1 do
if price[cont1]<aux8 then aux8:=price[cont1];
writeln(' Lowest Price: ',aux8:0:2);
aux8:=0;
for cont1:=1 to num1 do aux8:=aux8+qty[cont1];
writeln(' Total Quantity In Stock: ',aux8:0:0);
aux8:=0;
for cont1:=1 to num1 do aux8:=aux8+price[cont1];
writeln(' Total Money Invested In Stock: ',aux8:0:2);
writeln;
writeln('Extense Slots Occupied/Avaiable: ',dbqty,'/',dbextense);
readkey;          
end;
procedure proc1_5;
begin
reading;
repeat
clrscr;
writeln(' Search Keys:');
writeln('  a - Name');
writeln('  b - Quantity');
writeln('  c - Price');
readln(menu);
writeln;
until (menu>='a') and (menu<='c');
case menu of
'a': begin
write(' Insert Name search string: ');
readln(aux1);
aux2:=0;
for cont1:=1 to num1 do
if name[cont1]=aux1 then begin
aux2:=aux2+1;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
if aux2=0 then writeln(' Sorry there are no items that meet your criteria.');
readkey;
end;
'b': begin
writeln;
writeln('  a - By quantity');
writeln('  b - Items of greater quantity than');
writeln('  c - Items of lesser quantity than');
repeat     
readln(menu);
until (menu>='a') and (menu<='c');
aux2:=0;
writeln;
writeln(' Quantity? ');
repeat
readln(aux3);
until aux3>=0;
writeln;
case menu of
'a': begin
for cont1:=1 to num1 do
if qty[cont1]=aux3 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
'b': begin
for cont1:=1 to num1 do
if qty[cont1]>aux3 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
'c': begin
for cont1:=1 to num1 do
if qty[cont1]<aux3 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
end;
if aux2=0 then writeln(' Sorry there are no items that meet your criteria.');
readkey;
end;
'c': begin
writeln;
writeln('  a - By exact price');
writeln('  b - Items of greater price than');
writeln('  c - Items of lesser price than');
repeat
readln(menu);
until (menu>='a') and (menu<='c');
aux2:=0;
writeln;
writeln(' Price? ');
repeat
readln(aux8);
until aux8>=0;
writeln;
case menu of
'a': begin
for cont1:=1 to num1 do
if price[cont1]=aux8 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
'b': begin
for cont1:=1 to num1 do
if price[cont1]>aux8 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
'c': begin
for cont1:=1 to num1 do
if price[cont1]<aux8 then begin
aux2:=aux2+1;
if (aux2=10) or (aux2 mod 34=0) then begin
readkey;
clrscr;
end;
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
end;
end;
end;
if aux2=0 then writeln(' Sorry there are no items that meet your criteria.');
readkey;
end;
end;
end;      
procedure proc1_4;
begin
repeat
clrscr;
write(' Item name: ');
readln(aux1);
until aux1<>'<eof>';
aux2:=0;
for cont1:=1 to num1 do
if aux1=name[cont1] then aux2:=aux2+1;
if aux2=0 then begin
writeln;
writeln(' Sorry there are no items that meet your criteria.');
readkey;
end
else
begin
writeln;
writeln('  a - Modify name');
writeln('  b - Modify quantity');
writeln('  c - Modify price');
repeat
readln(menu);
until (menu>='a') and (menu<='c');
writeln;
case menu of
'a': begin
repeat
write(' New name: ');
readln(aux9);
until (aux1<>aux9) and (aux9<>'<eof>');
for cont1:=1 to num1 do
if name[cont1]=aux1 then name[cont1]:=aux9;
end;
'b': begin
repeat
write(' New quantity: ');
readln(aux3);
until aux3>0;
for cont1:=1 to num1 do
if name[cont1]=aux1 then qty[cont1]:=aux3;
end;
'c': begin
repeat
write(' New price: ');
readln(aux8);
until aux8>0;
for cont1:=1 to num1 do
if name[cont1]=aux1 then price[cont1]:=aux8;
end;
end;
end;
end;
procedure proc1_3;
begin
reading;
repeat
clrscr;
writeln(' 1 - Trash ONE item');
writeln(' 2 - Trash all items from one item type');
readln(menu);
until (menu='1') or (menu='2');
writeln;
writeln(' Item name: ');
readln(aux1);
case menu of
'1': for cont1:=1 to num1 do
if name[cont1]=aux1 then qty[cont1]:=qty[cont1]-1;
'2': for cont1:=1 to num1 do
if name[cont1]=aux1 then qty[cont1]:=0;
end;
writing;
end;             
procedure proc1_2;
begin
reading; 
repeat
clrscr;
aux4:=0;
write(' Item name: ');
readln(aux1);     
assign(listuse,syntaxfile);
rewrite(listuse);
write(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
for aux5:=1 to 15 do read(listuse,buffering[aux5]);
close(listuse);
buffering[1]:=upcase(buffering[1]);
assign(listuse,syntaxfile);
rewrite(listuse);
for aux5:=1 to 15 do write(listuse,buffering[aux5]);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,aux1);
close(listuse);
assign(listuse,syntaxfile);
reset(listuse);
erase(listuse);
close(listuse);
writingsyntax;
until aux1<>'<eof>';
for cont1:=1 to num1 do
if name[cont1]=aux1 then aux4:=aux4+1;   
if aux4=0 then
if num1=dbextense then begin
writeln('No free slots of memory reserved to items, delete');
writeln('unused ones or create a brand new data base');
readkey
end else begin
writeln('New item created');
writeln;
write(' Quantity: ');
repeat
readln(aux3);
until aux3>0;
write(' Price: ');
repeat
readln(aux8);
until aux8>0;
num1:=num1+1;
name[num1]:=aux1;
qty[num1]:=aux3;
price[num1]:=aux8;
num1:=num1+1;
name[num1]:='<eof>';
end else begin
writeln('Item accessed');
for cont1:=1 to num1 do
if name[cont1]=aux1 then aux5:=cont1;
writeln;
write(' Quantity: ');
repeat
readln(aux3);
until aux3>0;
write(' Price: ');
repeat
readln(aux8);
until aux8>0;
writeln;
writeln('   Previous quantity: ',qty[aux5]);
writeln('   a - Sum quantities to ',qty[aux5]+aux3);
writeln('   b - Reset the quantity to ',aux3);
repeat
readln(menu);
until (menu='a') or (menu='b');
case menu of
'a': qty[aux5]:=qty[aux5]+aux3;
'b': qty[aux5]:=aux3;
end;
writeln;
writeln('   Previous price: ',price[aux5]:0:2);
writeln('   a - Average price to ',((aux5-1)*price[aux5]+aux8)/aux5:0:2);
writeln('   b - Reset the price to ',aux8:0:2);
repeat
readln(menu);
until (menu='a') or (menu='b');
case menu of
'a': price[aux5]:=((aux5-1)*price[aux5]+aux8)/aux5;
'b': price[aux5]:=aux8;
end;
end;
writing;
reading;
writingsyntax;
readingsyntax;
end;    
procedure proc1_1;
begin
reading;
clrscr;
aux5:=0;
for cont1:=1 to num1 do
if cont1 mod 22 = 0 then aux5:=aux5+1;
aux6:=0;
for cont1:=1 to num1 do
if cont1 mod 22 <> 0 then writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2) else
begin
writeln(qty[cont1],' x ',name[cont1],' at ',price[cont1]:0:2);
aux6:=aux6+1;
writeln;
write('  Page ',aux6,'/',aux5+1);
readkey;
clrscr;
end;
readkey;
end;  
begin
randomize;
writeln('Program Aborted!');
writeln('File missing: syntax.ini');
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,menu);
close(listuse);
if (menu<'0') or (menu>'9') then begin
clrscr;
writeln('Program Aborted!');
writeln('File corrupted: syntax.ini');
readkey;
donewincrt;
end;
clrscr;
assign(listuse,syntaxfile);
reset(listuse);
readln(listuse,dbnum);
close(listuse);
if dbnum<=0 then begin
timemaker;
repeat
writeln;
writeln('  Welcome newcomer');
writeln;     
writeln('The system detected you have no database created.');
writeln('You will need to create your first one now.');
writeln('This can be done in four quick steps.');
writeln;
writeln('Brand new data bases require one (1) item to be input upon creation.');
writeln('This system uses files named Data Bases (DB), overwritten DB extension files');
writeln('cannot be recovered later on. Keep that in mind.');
writeln;
writeln(' Program Status:');
writeln('  Prgm Uses: ',dbuses);
writeln('  Prgm Vrsn: ',dataversion);
writeln('  Prgm Xtns: ',dbextense,'/15/12');
writeln;
writeln(' Program Files:');
write('  Client: ',programfile,' (');
assign(listsize,programfile);
reset(listsize);
if filesize(listsize)<1024 then writeln(filesize(listsize),' bytes)')
else writeln(filesize(listsize)/1024:0:2,' KB)');
close(listsize);        
write('  Syntax: ',syntaxfile,' (');
assign(listsize,syntaxfile);
reset(listsize);
if filesize(listsize)<1024 then writeln(filesize(listsize),' bytes)')
else writeln(filesize(listsize)/1024:0:2,' KB)');
close(listsize);
writeln;
writeln(' First users:');
writeln('  a - Create new database');
writeln('  b - Start with sample DB');
writeln;
writeln('  0 - Quit Operator');
write('  _');
gotoXY(3,25);
readln(menu);
if menu='0' then donewincrt;
clrscr;
until (menu='a') or (menu='b');
timemaker;
if menu='a' then begin
dbuses:=0;
dbqty:=0;
proc2_4;
end else begin
assign(listuse,syntaxfile);
rewrite(listuse);
writeln(listuse,1);
writeln(listuse,0);
writeln(listuse,1);
db[1]:='Ex_DB.db';
writeln(listuse,db[1]);
close(listuse);
assign(listuse,db[1]);
rewrite(listuse);
num1:=1;
writeln(listuse,'Ex_DB_Name');
aux2:=random(round(dbextense/2));
repeat
writeln(listuse,'Item_Nr',num1);
writeln(listuse,random(9999)+1);
writeln(listuse,((random(9999))+1)/(random(4)+3)/100);
num1:=num1+1;
until num1=aux2;
write(listuse,'<eof>');
close(listuse);
readingsyntax;
reading;
end;
end;
readingsyntax;
assign(listuse,db[dbnum]);
reset(listuse);
readln(listuse,dbname);
close(listuse);
dbuses:=dbuses+1;
repeat
timemaker;
repeat
writingsyntax;
clrscr;
writeln;
writeln(' Status');
writeln('  DB Nmbr: ',dbnum,'/',dbqty);
writeln('  DB Name: ',dbname);
write('  DB File: ',db[dbnum],' (');
assign(listsize,db[dbnum]);
reset(listsize);
if filesize(listsize)<1024 then writeln(filesize(listsize),' bytes)')
else writeln(filesize(listsize)/1024:0:2,' KB)');
close(listsize);        
gotoxy(40,3);
write('  Prgm Uses: ',dbuses);
gotoxy(40,4);
write('  Prgm Vrsn: ',dataversion,' (');
assign(listsize,programfile);
reset(listsize);
if filesize(listsize)<1024 then writeln(filesize(listsize),' bytes)')
else writeln(filesize(listsize)/1024:0:2,' KB)');
close(listsize);           
gotoxy(40,5);
writeln('  Prgm Xtns: ',dbextense,'/15/12');
writeln;
writeln; 
writeln(' Toolset');
writeln('  a - Show item list');
writeln('  b - Item Insert');
writeln('  c - Item Erase');
writeln('  d - Item Modify');
gotoxy(40,9);
writeln('  e - Advanced Search');
gotoxy(40,10);
writeln('  f - Statistics');
gotoxy(40,11);
writeln('  g - ???'); { MISS }
gotoxy(40,12);
writeln('  h - About JohnDB');
writeln;
writeln;
writeln(' Config');
writeln('  i - Change predifined DB');
writeln('  j - Change current DB File ');
writeln('  k - Change current DB Name');
writeln('  l - Create new data base');
writeln('  m - Add ',dataversion,' compatible DB');
writeln('  n - Erase data base');
writeln('  o - List all data bases');
writeln('  p - Reinstall/Uninstall Program');
writeln;
writeln;
writeln('  0 - Quit operator');
gotoxy(45,19);
write('| |  Standing By');
gotoXY(46,19);
menu:=readkey;
until ((menu>='a') and (menu<='p')) or (menu='0');
case menu of
'a': proc1_1;
'b': proc1_2;
'c': proc1_3; 
'd': proc1_4;
'e': proc1_5;
'f': proc1_6;
'g': proc1_7; { MISS }
'h': proc1_8;
'i': proc2_1;
'j': proc2_2;
'k': proc2_3;
'l': proc2_4;
'm': proc2_5;
'n': proc2_6;
'o': proc2_7;
'p': proc2_8;
end;
until menu='0';
writingsyntax;
timemaker;
clrscr;
donewincrt;
end.
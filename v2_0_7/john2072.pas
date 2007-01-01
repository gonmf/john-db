program vfjohndb2;
uses wincrt;
const
swname='VFP John DB';
swversion='2.0.7';
swvdate='29/12/2007';
switch='switch.ini';
swpost='post.ini';
swstats='stats.ini';
cache='bin\data.tmp';
type
dbtype=record
indicator: longint;
name: string;
quantity: longint;
value: real;
end;
accounttype=record
dbnamestr: string[8];
dbfilestr: string[15];
end;
systemtype=record
accnamestr: string[8];
accpassstr: string[8];
accfilestr: string[15];
end;
auxtype=record
auxstr: string[15];
end;
statstype=record
statsuser: string[8];
statsuses: longint;
statsdbsc: longint;
statsdbsd: longint;
statsitemsc: longint;
statsitemsd: longint;
end;
var
inuse: record
accname: string[8];
accfile: string[15];
dbname: string[8];
dbfile: string[15];
end;
systembin,systembin2: file of systemtype;
accountbin,accountbin2: file of accounttype;
dbbin,dbbin2: file of dbtype;
auxbin,auxbin2: file of auxtype;
statsbin,statsbin2: file of statstype;
statsuse: statstype;
auxuse: auxtype;
systemuse: systemtype;
accountuse: accounttype;
dbuse: dbtype; 
accname,accpass: string[8];
accfile: string[15];
login,dbopen: boolean;
{ S Y S }
lchar: array[1..8] of char;
astring1,astring2: string[8];
astring3,astring4: string[15];
buffer: text;
consoled: record
msg: array[0..5] of string;
owner: array[0..5] of string;
end;
cont1,cont2,cont3: longint;
areal1: real;
{ I / O   F U N C T I O N S } 
procedure resetsys;
begin
assign(systembin,switch);
rewrite(systembin);
close(systembin);
assign(auxbin,swpost);
rewrite(auxbin);
close(auxbin);
assign(statsbin,swstats);
rewrite(statsbin);
close(statsbin);
donewincrt;  
end;
{ C O N S O L E }



            
procedure console(csl:string);
var csl2: string;
csl3: text;
csl4: array[1..70] of char;
csl5: word;
begin
assign(csl3,'console');
rewrite(csl3);
write(csl3,csl):
close(csl3);   
assign(csl3,'console');
reset(csl3);
for csl5:=1 to 70 do read(csl3,csl4[csl5]);
close(csl3);
assign(csl3,'console');
rewrite(csl3);
for csl5:=1 to 70 do write(csl3,upcase(csl4[csl5]));
close(csl3);    
assign(csl3,'console');
reset(csl3);
read(csl3,csl2):
erase(csl3);
close(csl3);





if csl='<reset>' then for cont1:=0 to 4 do consoled.msg[cont1]:='' else
if csl='<input>' then begin
gotoxy(0,19);
writeln('-Console----------------------------------------------------------------------+');
for cont1:=1 to 4 do
if consoled.msg[5-cont1]<>consoled.msg[5] then
writeln(' ',consoled.owner[5-cont1],' says: ',consoled.msg[5-cont1]) else
writeln;
write('\');
readln(consoled.msg[0]);
consoled.owner[0]:='User';
if consoled.msg[0]<>consoled.msg[5] then
for cont1:=4 downto 1 do begin
consoled.msg[cont1]:=consoled.msg[cont1-1];
consoled.owner[cont1]:=consoled.owner[cont1-1];
if consoled.msg[0]='resetsys' then resetsys;
if consoled.msg[0]='runerror' then runerror(255);
if consoled.msg[0]='quit' then donewincrt;
if consoled.msg[0]='logout' then login:=false;
if consoled.msg[0]='dbclose' then dbopen:=false;
end;
end else begin
consoled.msg[0]:=csl;
consoled.owner[0]:='System';
if consoled.msg[0]<>consoled.msg[5] then
for cont1:=4 downto 1 do begin
consoled.msg[cont1]:=consoled.msg[cont1-1];
consoled.owner[cont1]:=consoled.owner[cont1-1];
end;
end;
end;













{ I N S T R U C T I O N S }
procedure proc1_1;
begin
repeat
clrscr;
writeln(' DBs List - ',inuse.accname);
assign(accountbin,inuse.accfile);
reset(accountbin);
for cont2:=1 to filesize(accountbin) do begin
read(accountbin,accountuse);
writeln(cont2/1:4:0,' - ',accountuse.dbnamestr,' - ',accountuse.dbfilestr);
if (cont2 mod 21=0) and (cont2<>filesize(accountbin)) then begin
writeln;
write('DBs [',cont2-20,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
cont3:=filesize(accountbin);
close(accountbin);
gotoxy(1,24);
write(' Database to open Nr? (0 to cancel) ');
read(cont1);
until (cont1>=0) and (cont1<=cont3);  
if cont1>0 then begin 
assign(accountbin,inuse.accfile);
reset(accountbin);
dbopen:=true;
seek(accountbin,cont1-1);
read(accountbin,accountuse);
inuse.dbname:=accountuse.dbnamestr;
inuse.dbfile:=accountuse.dbfilestr;
close(accountbin);  
assign(dbbin,inuse.dbfile);
reset(dbbin);
assign(dbbin2,cache);
rewrite(dbbin2);
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
write(dbbin2,dbuse);
end;
close(dbbin);
close(dbbin2); 
end;
end;
procedure proc1_2;
begin
inuse.dbname:='unnamed';
inuse.dbfile:='bin\unnamed.bin';
assign(dbbin,inuse.dbfile);
rewrite(dbbin);
close(dbbin);
dbopen:=true;
assign(dbbin,cache);
rewrite(dbbin);
close(dbbin);
end;
procedure proc1_3;
begin
assign(dbbin,cache);
reset(dbbin);
assign(dbbin2,inuse.dbfile);
rewrite(dbbin2);
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
write(dbbin2,dbuse);
end;
close(dbbin2);
close(dbbin);
console('Saved!');
end;
procedure proc1_4;
begin
proc1_3;
repeat
cont2:=0;
clrscr;
console('Save as DB Name?');
console('<input>');
astring1:=consoled.msg[0];
assign(buffer,'buffer');
rewrite(buffer);
write(buffer,astring1);
close(buffer);
for cont1:=1 to 8 do lchar[cont1]:=' ';
assign(buffer,'buffer');
reset(buffer);
for cont1:=1 to 8 do read(buffer,lchar[cont1]);
erase(buffer);
close(buffer);
astring1:='';
for cont1:=1 to 8 do astring1:=astring1+upcase(lchar[cont1]);
assign(accountbin,inuse.accfile);
reset(accountbin);
for cont1:=1 to filesize(accountbin) do begin
read(accountbin,accountuse);
if astring1=accountuse.dbnamestr then cont2:=1;
end;
until cont2=0;
repeat
cont3:=0;
assign(buffer,'buffer');
rewrite(buffer);
for cont1:=1 to 8 do begin
cont2:=random(10);
write(buffer,cont2);
end;
close(buffer);
assign(buffer,'buffer');
reset(buffer);
read(buffer,astring3);
erase(buffer);
close(buffer);
astring3:='bin\'+astring3+'.db'; 
assign(auxbin,swpost);
reset(auxbin);
for cont1:=1 to filesize(auxbin) do begin
read(auxbin,auxuse);
if auxuse.auxstr=astring3 then cont3:=1;
end;
close(auxbin);   
until cont3=0;
astring4:=inuse.dbfile;
inuse.dbname:=astring1;
inuse.dbfile:=astring3; 
assign(dbbin,cache);
reset(dbbin);
rename(dbbin,inuse.dbfile);
close(dbbin);   
assign(dbbin,inuse.dbfile);
reset(dbbin);
assign(dbbin2,cache);
rewrite(dbbin2);
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
write(dbbin2,dbuse);
end;
close(dbbin2);
close(dbbin);  
assign(accountbin,inuse.accfile);
reset(accountbin);
assign(accountbin2,'buffer');
rewrite(accountbin2); 
for cont1:=1 to filesize(accountbin) do begin
read(accountbin,accountuse);
write(accountbin2,accountuse);
end;
accountuse.dbnamestr:=inuse.dbname;
accountuse.dbfilestr:=inuse.dbfile;
write(accountbin2,accountuse);
erase(accountbin);
close(accountbin);
close(accountbin2);
assign(accountbin,'buffer');
reset(accountbin);
rename(accountbin,inuse.accfile);
close(accountbin);
assign(auxbin,swpost);
reset(auxbin);
assign(auxbin2,'buffer');
rewrite(auxbin2);
for cont1:=1 to filesize(auxbin) do begin
read(auxbin,auxuse);
write(auxbin2,auxuse);
end;
erase(auxbin);
close(auxbin);
auxuse.auxstr:=inuse.dbfile;
write(auxbin2,auxuse);
close(auxbin2);
assign(auxbin,'buffer');
reset(auxbin);
rename(auxbin,swpost);
close(auxbin);   
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
if statsuse.statsuser=inuse.accname then statsuse.statsdbsc:=statsuse.statsdbsc+1;
write(statsbin2,statsuse);
end;
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin); 
console('Saved!');
end;
procedure proc1_5;
begin
clrscr;
console('To delete a database you cannot have no DB open');
console('Input 0 to continue and close any DB if open (work will be lost)');
console('<input>');
if consoled.msg[0]='0' then begin
dbopen:=false;
clrscr;
writeln;
assign(accountbin,inuse.accfile);
reset(accountbin);
for cont2:=1 to filesize(accountbin) do begin
read(accountbin,accountuse);
writeln(cont2/1:4:0,' - ',accountuse.dbnamestr,' - ',accountuse.dbfilestr);
if (cont2 mod 21=0) and (cont2<>filesize(accountbin)) then begin
writeln;
write('DBs [',cont2-20,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
close(accountbin);
gotoxy(1,24);
write(' Database to delete Nr? (0 to cancel) ');
read(cont1);
assign(accountbin,inuse.accfile);
reset(accountbin);
cont2:=filesize(accountbin);
close(accountbin);
if (cont1>=1) and (cont1<=cont2+1) then begin
assign(accountbin,inuse.accfile);
reset(accountbin);
seek(accountbin,cont1-1);
read(accountbin,accountuse);
inuse.dbname:=accountuse.dbnamestr;
inuse.dbfile:=accountuse.dbfilestr;
close(accountbin);
assign(dbbin,cache);
rewrite(dbbin);
close(dbbin);
assign(dbbin,inuse.dbfile);
reset(dbbin);
erase(dbbin);
close(dbbin);       
assign(accountbin,inuse.accfile);
reset(accountbin);
assign(accountbin2,'buffer');
rewrite(accountbin2);
for cont3:=1 to filesize(accountbin) do begin
read(accountbin,accountuse);
if accountuse.dbfilestr<>inuse.dbfile then write(accountbin2,accountuse);
end;
erase(accountbin);
close(accountbin);
close(accountbin2);
assign(accountbin,'buffer');
reset(accountbin);
rename(accountbin,inuse.accfile);
close(accountbin);    
assign(auxbin,swpost);
reset(auxbin);
assign(auxbin2,'buffer');
rewrite(auxbin2);
for cont3:=1 to filesize(auxbin) do begin
read(auxbin,auxuse);
if auxuse.auxstr<>inuse.dbfile then write(auxbin2,auxuse);
end;               
erase(auxbin);
close(auxbin);
close(auxbin2);
assign(auxbin,'buffer');
reset(auxbin);
rename(auxbin,swpost);
close(auxbin); 
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
if statsuse.statsuser=inuse.accname then statsuse.statsdbsd:=statsuse.statsdbsd+1;
write(statsbin2,statsuse);
end;
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin);   
console('Logged Out - '+inuse.dbname+' Deleted');
end;   
end;
end;
procedure proc1_6;
begin
clrscr;
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
repeat   
read(statsbin,statsuse); 
cont2:=cont2+1;
if filesize(statsbin)*2<cont2 then begin
write('Critical Error: Log Files Corrupted');
readkey;
donewincrt;  
end;
until statsuse.statsuser=inuse.accname;
close(statsbin);
writeln;
writeln(' ',swname,' Statistics for user ',inuse.accname);
writeln;
writeln('  -Software uses: ',statsuse.statsuses);
writeln;
writeln('  -Nr of DBs created: ',statsuse.statsdbsc);
writeln;
writeln('  -Nr of DBs erased: ',statsuse.statsdbsd);
writeln;
writeln('  -Nr of items created: ',statsuse.statsitemsc);
writeln;
writeln('  -Nr of items erased: ',statsuse.statsitemsd);
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
cont2:=cont2+statsuse.statsuses;
end;
close(statsbin);                  
writeln;
assign(systembin,switch);
reset(systembin);
cont1:=filesize(systembin);
close(systembin);
writeln(' ',swname,' Statistics for all ',cont1,' users');  
writeln;
writeln('  -Software uses: ',cont2);
writeln;  
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
cont2:=cont2+statsuse.statsdbsc;
end;
close(statsbin); 
writeln('  -Nr of DBs created: ',cont2);
writeln;   
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
cont2:=cont2+statsuse.statsdbsd;
end;
close(statsbin); 
writeln('  -Nr of DBs erased: ',cont2);
writeln;     
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
cont2:=cont2+statsuse.statsitemsc;
end;
close(statsbin);  
writeln('  -Nr of items created: ',cont2);
writeln;         
assign(statsbin,swstats);
reset(statsbin);
cont2:=0;
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
cont2:=cont2+statsuse.statsitemsd;
end;
close(statsbin);       
writeln('  -Nr of items erased: ',cont2);
readkey;
end;
procedure proc1_7;
begin
console('Not Done Yet');
end;
procedure proc1_8;
begin
clrscr;
writeln('You need solely a compatible QWERT/ASCII input peripheral, no mouse needed');
writeln('If you are asked for a number ALLWAYS type numbered strings only');
writeln('The disrespect for this may rule result in severe system corruption');
writeln;
writeln('Q: Program stops suddenly - Error Messages: 2,3,101');
writeln('A: Make sure you havent messed around the programs directory');
writeln('   If nothing else works run a resetsys function (will clean everything)');
writeln;
writeln('Q: How can I quit from the program without a mouse or Alt-F4?');
writeln('A: That option isnt built-in, use the function quit');
writeln;
writeln('Q: How safe is a ',swname,' password?');
writeln('A: Files can be easily decoded only by experient programmers but');
writeln('   generally having multiple accounts registered is much safer');
writeln;
writeln('Q: Is there an item limit or account limit or data bases limit?');
writeln('A: Well, no, but the VFP tech allows only about 43046721 DB files and accounts');
writeln('   Item number is infinite');
writeln;
writeln('Q: Are the console commands case sensitive?');
writeln('A: Not generally, when they are it is pointed out for you');
writeln;
writeln('Q: How can i backup my files?');
write('A: Backup all the files (except the main application)');
readkey;
end;
procedure proc2_1;
begin
clrscr;
writeln(' Item List - ',inuse.dbname);
assign(dbbin,cache);
reset(dbbin);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);                      
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
if (cont2 mod 21=0) and (cont2<>filesize(dbbin)) then begin
writeln;
write('Items [',cont2-20,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
close(dbbin);
readkey;
end;
procedure proc2_2;
begin              
cont2:=0;
assign(dbbin,cache);
reset(dbbin);
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
cont2:=dbuse.indicator;
end;    
cont2:=cont2+1;
repeat
repeat
clrscr;
writeln;
writeln(' New Item Creation');
writeln;
writeln('  -Unique ID (relates to the order items were created): ',cont2);
write('  -Common Name: ');
readln(astring1);
write('  -Value (-/-): ');
readln(areal1);
write('  -Present Quantity: ');
readln(cont3);
writeln('  -Value Tt: ',areal1*cont3:0:2);
until (areal1>=0) and (cont3>=0);
writeln;
writeln('         Accept Values?');
writeln('    Y=Yes     N=No     Q=Quit');
write('               ');
readln(lchar[1]);
lchar[1]:=upcase(lchar[1]);
until (lchar[1]='Y') or (lchar[1]='Q');
if lchar[1]='Y' then begin 
assign(dbbin,cache);
reset(dbbin);
assign(dbbin2,'buffer');
rewrite(dbbin2);
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
write(dbbin2,dbuse);
end;
dbuse.indicator:=cont2;
dbuse.name:=astring1;
dbuse.quantity:=cont3;
dbuse.value:=areal1;
write(dbbin2,dbuse);
erase(dbbin);
close(dbbin);
close(dbbin2);
assign(dbbin,'buffer');
reset(dbbin);
rename(dbbin,cache);
close(dbbin);  
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
if statsuse.statsuser=inuse.accname then statsuse.statsitemsc:=statsuse.statsitemsc+1;
write(statsbin2,statsuse);
end;
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin);
console('New Item Added: '+astring1);
end;         
end;                                           
procedure proc2_3;
begin    
repeat
assign(dbbin,cache);
reset(dbbin);
clrscr;
writeln(' Item List - ',inuse.dbname);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);                      
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
if (cont2 mod 21=0) and (cont2<>filesize(dbbin)) then begin
writeln;
write('Items [',cont2-20,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
gotoxy(1,24);
write(' Unique ID to delete? (0 to cancel) ');
readln(cont1);
cont3:=filesize(dbbin);
close(dbbin);                   
until (cont1>=0) and (cont1<=cont3);                                 
if cont1>0 then begin  
assign(dbbin,cache);
reset(dbbin);
assign(dbbin2,'buffer');
rewrite(dbbin2);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
if dbuse.indicator<>cont1 then write(dbbin2,dbuse) else astring1:=dbuse.name;
end;
erase(dbbin);
close(dbbin);
close(dbbin2);
assign(dbbin,'buffer');
reset(dbbin);
rename(dbbin,cache);
close(dbbin);
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
if statsuse.statsuser=inuse.accname then statsuse.statsitemsd:=statsuse.statsitemsd+1;
write(statsbin2,statsuse);
end;
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin);
console('Item Erased: '+astring1);
end;
end;
procedure proc2_4;
begin     
repeat
cont3:=0;
clrscr;
writeln(' Item List - ',inuse.dbname);
assign(dbbin,cache);
reset(dbbin);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);                      
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
if (cont2 mod 21=0) and (cont2<>filesize(dbbin)) then begin
writeln;
write('Items [',cont2-20,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
gotoxy(1,24);
write(' Unique ID to modify? (0 to cancel) ');
readln(cont1);
close(dbbin);
assign(dbbin,cache);
reset(dbbin);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
if dbuse.indicator=cont1 then cont3:=1;
end;                  
close(dbbin);
until (cont1=0) xor (cont3=1);
if cont1<>0 then begin
assign(dbbin,cache);
reset(dbbin);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
if dbuse.indicator=cont1 then begin
astring1:=dbuse.name;
areal1:=dbuse.value;
cont3:=dbuse.quantity;
end;
end;
close(dbbin);
repeat
clrscr;
writeln;
writeln(' Item Modify');
writeln;
writeln('  -Unique ID (relates to the order items were created): ',cont1);
writeln('  -Common Name: ',astring1);
writeln('  -Value (-/-): ',areal1:0:2);
writeln('  -Present Quantity: ',cont3);
writeln('  -Value Tt: ',areal1*cont3:0:2);
writeln;
writeln('  Change...?');
writeln('  a - Name');
writeln('  b - Value (-/-)');
writeln('  c - Quantity');
write('  ');
readln(lchar[1]);
writeln;
lchar[1]:=upcase(lchar[1]); 
until (lchar[1]>='A') and (lchar[1]<='C');
case lchar[1] of 
'A': begin
write(' New Name: ');
readln(astring1);
end;
'B': begin
repeat
write(' New Value (-/-): ');
readln(areal1);
until areal1>=0;
end;
'C': begin
repeat
write(' New Quantity: ');
readln(cont3);
until cont3>=0;
end;
end;   
if cont1<>0 then begin  
assign(dbbin,cache);
reset(dbbin);
assign(dbbin2,'buffer');
rewrite(dbbin2);
for cont2:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
if dbuse.indicator=cont1 then begin
dbuse.name:=astring1;
dbuse.value:=areal1;
dbuse.quantity:=cont3;
end;
write(dbbin2,dbuse);
end;
erase(dbbin);
close(dbbin);
close(dbbin2);
assign(dbbin,'buffer');
reset(dbbin);
rename(dbbin,cache);
close(dbbin);
console('Item Modified: '+astring1);
end;
end;           
end;
procedure proc2_5;
begin
repeat
clrscr;
writeln;
writeln(' Advanced Search Item');
writeln;
writeln('  a - Unique ID (relates to the order items were created)');
writeln('  b - Common Name');
writeln('  c - Value (-/-)');
writeln('  d - Present Quantity');
writeln('  e - Value Tt');
writeln('  0 - Cancel');
writeln;
write('  Search Key: ');
readln(lchar[1]);
writeln;
lchar[1]:=upcase(lchar[1]); 
until ((lchar[1]>='A') and (lchar[1]<='E')) or (lchar[1]='0');
if lchar[1]<>'0' then begin
if lchar[1]<>'B' then begin
writeln('  a - >');
writeln('  b - >=');
writeln('  c - =');
writeln('  d - <=');
writeln('  e - <');
writeln('  f - <>');
write(' Search Method: ');
repeat
readln(lchar[2]);
lchar[2]:=upcase(lchar[2]);
until ((lchar[2]>='A') and (lchar[2]<='F'));
writeln;   
end;   
if lchar[1]='B' then begin
write(' Search String (Case Sensitive): ');
readln(astring1);
writeln;
writeln('  a - Whole match');
writeln('  b - String Present');
repeat
readln(lchar[3]);
lchar[3]:=upcase(lchar[3]);
until (lchar[3]='A') or (lchar[3]='B');
end else begin
write(' Search Value: ');
readln(areal1);
end;   
cont2:=0;
clrscr;
assign(dbbin,cache);
reset(dbbin);                 
for cont1:=1 to filesize(dbbin) do begin
read(dbbin,dbuse);
if (lchar[1]='B') then begin
if (lchar[3]='A') and (dbuse.name=astring1) then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;   
end else
if (lchar[3]='B') and (pos(astring1,dbuse.name)>0) then begin  
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
end else 
case lchar[1] of
'A': case lchar[2] of
'A': if dbuse.indicator>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'B': if dbuse.indicator>=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'C': if dbuse.indicator=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'D': if dbuse.indicator<=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'E': if dbuse.indicator>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'F': if dbuse.indicator<>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end; 
end;     
'C': case lchar[2] of
'A': if dbuse.value>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'B': if dbuse.value>=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'C': if dbuse.value=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'D': if dbuse.value<=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'E': if dbuse.value>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'F': if dbuse.value<>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end; 
end;  
'D': case lchar[2] of
'A': if dbuse.quantity>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'B': if dbuse.quantity>=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'C': if dbuse.quantity=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'D': if dbuse.quantity<=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'E': if dbuse.quantity>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'F': if dbuse.quantity<>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end; 
end;  
'E': case lchar[2] of
'A': if dbuse.quantity*dbuse.value>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'B': if dbuse.quantity*dbuse.value>=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'C': if dbuse.quantity*dbuse.value=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'D': if dbuse.quantity*dbuse.value<=areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'E': if dbuse.quantity*dbuse.value>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
'F': if dbuse.quantity*dbuse.value<>areal1 then begin
writeln(' ID',dbuse.indicator/1:4:0,' - ',dbuse.quantity,' x ',dbuse.name,', ',dbuse.value:0:2,'$ -/- ,',
dbuse.quantity*dbuse.value:0:2,'$ Tt');
cont2:=cont2+1;
end;
end;
end;  
if (cont2 mod 21=0) and (cont2<>0) then begin
writeln;
write('Items [',cont2-14,'-',cont2,']');
readkey;
clrscr;
writeln;
end;
end;
if cont2=0 then writeln('No entries meet your criteria');
readkey;
close(dbbin); 
end;      
end; 
begin
randomize;
{ S A F E   M O D E }
console('Safe Mode Start (Pre-Post Run)');
console('<input>');
console('<reset>');
{ A C T I O N }
clrscr;
cont3:=1;
repeat
cont3:=cont3+1;
cont1:=random(80);
cont2:=random(25); 
gotoXY(cont1,cont2);
if cont3 mod 2=0 then write('\') else write('/');   
gotoXY(34,12);
write(' ',swname,' '); 
gotoXY(34,13);
write('    ',swversion,'    ');
if cont3>8192 then begin  
gotoXY(28,15);
write(' Press any key to continue ');
end;
until (keypressed) and (cont3>8192);  
{ B O D Y }
clrscr;
write('Critical Error: Directory Read-Only');
assign(buffer,'buffer');
rewrite(buffer);
close(buffer);
assign(buffer,'buffer');
reset(buffer);
erase(buffer);
close(buffer);
clrscr;
write('Critical Error: System Files Not Found');
assign(systembin,switch);
reset(systembin);
close(systembin); 
clrscr;
write('Critical Error: Post Files Not Found');
assign(auxbin,swpost);
reset(auxbin);
close(auxbin);   
clrscr;      
write('Critical Error: Log Files Not Found');
assign(statsbin,swstats);
reset(statsbin);
close(statsbin);   
clrscr;         
write('Critical Error: Directories Not Found');
assign(dbbin,cache);
rewrite(dbbin);
close(dbbin);
assign(buffer,'sys\buffer.tmp');
rewrite(buffer);
close(buffer);
assign(buffer,'sys\buffer.tmp');
reset(buffer);
erase(buffer);
close(buffer);
clrscr;
repeat
console('This is the console for menu/ADV code - Thank You');
repeat
cont2:=0;
assign(systembin,switch);
reset(systembin);
cont1:=filesize(systembin);
close(systembin);
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
write(' Welcome to the system (',cont1,' registered user');
if cont1<>1 then writeln('s)') else writeln(')');
writeln;
writeln;
if cont1=0 then writeln(' a - [_]') else writeln(' a - Login');
writeln(' b - Register');
writeln(' c - Help');
write(' ');
console('<input>');
if consoled.msg[0]='c' then proc1_8;
if consoled.msg[0]='b' then begin
repeat
cont3:=0;
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
writeln(' Welcome to the system');
writeln;
writeln;
write(' Username:');
console('<input>');
astring1:=consoled.msg[0];
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
writeln(' Welcome to the system');
writeln;
writeln;
writeln(' Username: ',astring1);
write(' Password:');
console('<input>');
astring2:=consoled.msg[0];
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
writeln(' Welcome to the system');
writeln;
writeln;
writeln(' Username: ',astring1);
writeln(' Password: ',astring2);
assign(buffer,'buffer');
rewrite(buffer);
write(buffer,astring1);
close(buffer);
for cont1:=1 to 8 do lchar[cont1]:=' ';
assign(buffer,'buffer');
reset(buffer);
for cont1:=1 to 8 do read(buffer,lchar[cont1]);
erase(buffer);
close(buffer);
astring1:='';
for cont1:=1 to 8 do astring1:=astring1+upcase(lchar[cont1]);
repeat
cont3:=0;
assign(buffer,'buffer');
rewrite(buffer);
for cont1:=1 to 8 do begin
cont2:=random(10);
write(buffer,cont2);
end;
close(buffer);
assign(buffer,'buffer');
reset(buffer);
read(buffer,astring3);
erase(buffer);
close(buffer);
astring3:='sys\'+astring3+'.db'; 
assign(auxbin,swpost);
reset(auxbin);
for cont1:=1 to filesize(auxbin) do begin
read(auxbin,auxuse);
if auxuse.auxstr=astring3 then cont3:=1;
end;
close(auxbin);   
until cont3=0;
assign(systembin,switch);
reset(systembin);
for cont1:=1 to filesize(systembin) do begin
read(systembin,systemuse);
if systemuse.accnamestr=astring1 then cont3:=1;
end;
close(systembin); 
until cont3=0;
assign(systembin,switch);
reset(systembin); 
assign(systembin2,'buffer');
rewrite(systembin2);
for cont1:=1 to filesize(systembin) do begin
read(systembin,systemuse);
write(systembin2,systemuse);
end;
systemuse.accnamestr:=astring1;
systemuse.accpassstr:=astring2;
systemuse.accfilestr:=astring3;
write(systembin2,systemuse);
close(systembin2);
erase(systembin);
close(systembin);
assign(systembin,'buffer');
reset(systembin);
rename(systembin,switch);
close(systembin); 
console('Update Success: System files');
assign(accountbin,astring3);
rewrite(accountbin);
close(accountbin);
console('Update Success: Account files');
assign(auxbin,swpost);
reset(auxbin); 
assign(auxbin2,'buffer');
rewrite(auxbin2);
for cont1:=1 to filesize(auxbin) do begin
read(auxbin,auxuse);
write(auxbin2,auxuse);
end;
auxuse.auxstr:=astring3;
write(auxbin2,auxuse);
erase(auxbin);
close(auxbin);
close(auxbin2);
assign(auxbin,'buffer');
reset(auxbin);
rename(auxbin,swpost);
close(auxbin);
console('Update Success: Post files'); 
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
write(statsbin2,statsuse);
end;                
statsuse.statsuser:=systemuse.accnamestr;
statsuse.statsuses:=0;
statsuse.statsdbsc:=0;
statsuse.statsdbsd:=0;
statsuse.statsitemsc:=0;
statsuse.statsitemsd:=0;  
write(statsbin2,statsuse);
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin);         
console('Update Success: Log files - New user created');
readkey;
end;
assign(systembin,switch);
reset(systembin);
cont1:=filesize(systembin);
close(systembin);
if (consoled.msg[0]='a') and (cont1>0) then 
repeat
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
writeln(' Welcome to the system');
writeln(' Attempts to connect left: ',3-cont2);
writeln;
write(' Username: ');
readln(astring1);
clrscr;
writeln;
writeln(' Virtual Flexible-Point John DB 2');
writeln('  Version ',swversion,' (',swvdate,')');
writeln;
writeln(' Welcome to the system');
writeln(' Attempts to connect left: ',3-cont2);
writeln;
writeln(' Username: ',astring1);
write(' Password: ');
readln(astring2);
assign(buffer,'buffer');
rewrite(buffer);
write(buffer,astring1);
close(buffer);
for cont1:=1 to 8 do lchar[cont1]:=' ';
assign(buffer,'buffer');
reset(buffer);
for cont1:=1 to 8 do read(buffer,lchar[cont1]);
erase(buffer);
close(buffer);
astring1:='';
for cont1:=1 to 8 do astring1:=astring1+upcase(lchar[cont1]);
assign(systembin,switch);
reset(systembin); 
for cont1:=1 to filesize(systembin) do begin
read(systembin,systemuse);
if (systemuse.accnamestr=astring1) and (systemuse.accpassstr=astring2) then begin
login:=true;
inuse.accname:=systemuse.accnamestr;
inuse.accfile:=systemuse.accfilestr;
end;
end;
close(systembin);
cont2:=cont2+1;
until (login=true) or (cont2=3);
until login=true;
{ /BODY & MENU LOOP }
console('<reset>');
dbopen:=false;
console('Login Successful - Welcome');
assign(statsbin,swstats);
reset(statsbin);
assign(statsbin2,'buffer');
rewrite(statsbin2);
for cont1:=1 to filesize(statsbin) do begin
read(statsbin,statsuse);
if statsuse.statsuser=inuse.accname then statsuse.statsuses:=statsuse.statsuses+1;
write(statsbin2,statsuse);
end;
erase(statsbin);
close(statsbin);
close(statsbin2); 
assign(statsbin,'buffer');
reset(statsbin);
rename(statsbin,swstats);
close(statsbin);  
repeat
clrscr;
writeln('Critical Error: Account File Not Found');
assign(accountbin,inuse.accfile);
reset(accountbin);
cont1:=filesize(accountbin);
close(accountbin);
clrscr; 
writeln;
writeln(' 0 - ',inuse.accname,' LOGOUT');
if cont1>0 then writeln(' a - DB Open') else writeln(' a - [_]');
writeln(' b - DB New');
if (dbopen=true) and (inuse.dbname<>'unnamed') then writeln(' c - DB Save') else writeln(' c - [_]');
if dbopen=true then writeln(' d - DB Save As') else writeln(' d - [_]');
if cont1>0 then writeln (' e - DB Delete') else writeln(' e - [_]');
writeln(' f - Statistics');
writeln(' g - ?_Applet/Plugin');
writeln(' h - Help');
writeln;             
if dbopen=true then begin  
assign(dbbin,cache);
reset(dbbin);
cont2:=filesize(dbbin);
writeln(' 1 - ',inuse.dbname,' CLOSE');
close(dbbin);
if cont2>0 then writeln(' i - Show Item List') else writeln(' i - [_]');
writeln(' j - Item Insert');
if cont2>0 then writeln(' k - Item Erase') else writeln(' k - [_]');
if cont2>0 then writeln(' l - Item Modify') else writeln(' l - [_]');
if cont2>0 then writeln(' m - Adv. Search Item') else writeln(' m - [_]');
end else begin
writeln('    NO DATA BASE OPEN');
writeln('  [_]');
end;      
console('<input>');
if consoled.msg[0]='0' then login:=false;
if consoled.msg[0]='1' then dbopen:=false;  
if (cont1>0) and (consoled.msg[0]='a') then proc1_1;
if consoled.msg[0]='b' then proc1_2;                 
if (dbopen=true) and (consoled.msg[0]='c') and (inuse.dbname<>'unnamed') then proc1_3;
if (dbopen=true) and (consoled.msg[0]='d') then proc1_4;
if (cont1>0) and (consoled.msg[0]='e') then proc1_5;
if consoled.msg[0]='f' then proc1_6;
if consoled.msg[0]='g' then proc1_7;
if consoled.msg[0]='h' then proc1_8; 
if dbopen=true then begin
if (cont2>0) and (consoled.msg[0]='i') then proc2_1;
if consoled.msg[0]='j' then proc2_2;
if (cont2>0) and (consoled.msg[0]='k') then proc2_3;
if (cont2>0) and (consoled.msg[0]='l') then proc2_4;
if (cont2>0) and (consoled.msg[0]='m') then proc2_5;
end;
until login=false;
{ /LOOP }
clrscr;
console('<reset>');
console('Logout Successful...');
until login=true;
end.       


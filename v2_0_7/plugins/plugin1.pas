program plugin1;
uses wincrt;
const
swname='VFP John DB Plugin 1';
swversion='1.0';
swvdate='01/12/2007';
type
dbtype=record
indicator: longint;
name: string;
quantity: longint;
value: real;
end;
var
dbbin: file of dbtype;
dbuse: dbtype; 
astring1: string[15];
cont1,cont2: longint;
begin
randomize;
writeln('Plugin 1 - Use to create random items on a given DB');
writeln;
writeln('  1 - Go to your bin directory and get the db number');
write('  2 - What is it? (dont include its extension) ');
readln(astring1);
astring1:='bin\'+astring1+'.db';
write('  3 - How many entries in the database? (Content will be overwriten) ');
readln(cont1);
writeln;
assign(dbbin,astring1);
rewrite(dbbin);
for cont2:=1 to cont1 do begin
dbuse.indicator:=cont2;
dbuse.name:='AutoItemPlugin';
dbuse.quantity:=random(30000)+1;
dbuse.value:=random(1000)*3.14/3*(random(3)+1);
write(dbbin,dbuse);
end;
close(dbbin);
writeln('  Done');
readkey;
donewincrt;
end.

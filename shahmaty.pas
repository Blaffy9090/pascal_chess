{
ПОФИКСИТЬ СИСТЕМУ ШАХОВ, ПОРАБОТАТЬ НАД МОМЕНТОМ БЕЗДУМНОГО СЪЕДЕНИЯ ФИГУРЫ ДЛЯ ОТКРЫТИЯ БОЛЬШИХ АТАК
}
var
  mode:integer = 1;//1 -  режим алгебраических нотаций, 2 - режим с доской
  cvet: string = 'w';
  board: array of array of string = (('bR', 'bN', 'bB', 'bQ', 'bK', 'bB', 'bN', 'bR'),
                                    ('bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP'),
                                    ('  ', '  ', '  ', '  ', '  ', '  ', '  ', '  '),
                                    ('  ', '  ', '  ', '  ', '  ', '  ', '  ', '  '),
                                    ('  ', '  ', '  ', '  ', '  ', '  ', '  ', '  '),
                                    ('  ', '  ', '  ', '  ', '  ', '  ', '  ', '  '),
                                    ('wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP'),
                                    ('wR', 'wN', 'wB', 'wQ', 'wK', 'wB', 'wN', 'wR'));
  
  {}{
  board:array of array of string = (('bR','bN','bB','bQ','bK','bB','bN','bR'),
                                    ('bP','bP','bP','bP','bP','bP','bP','bP'),
                                    ('  ','  ','  ','  ','  ','  ','  ','  '),
                                    ('  ','  ','  ','  ','  ','  ','  ','  '),
                                    ('  ','  ','  ','  ','  ','  ','  ','  '),
                                    ('  ','  ','  ','  ','  ','  ','  ','  '),
                                    ('wP','wP','wP','wP','wP','wP','wP','wP'),
                                    ('wR','wN','wB','wQ','wK','wB','wN','wR'));
  {}
  boardb, boardw, Chkd, Zashita: array of array of string;
  CostBoard, AttackBoard, ZashitaBoard: array of array of double;
  PawnEval: array of array of double = ((2, 2, 2, 2, 2, 2, 2, 2), 
                                      (-0.04, 0.68, 0.61, 0.47, 0.47, 0.49, 0.45, -0.01), 
                                      (0.06, 0.16, 0.25, 0.33, 0.24, 0.24, 0.14, -0.06), 
                                      (0.0, -0.01, 0.09, 0.28, 0.20, 0.08, -0.01, 0.11),
                                      (0.06, 0.04, 0.06, 0.14, 0.15, -0.05, 0.06, -0.06),
                                      (-0.01, -0.08, -0.04, 0.04, 0.02, -0.12, -0.01, 0.05),
                                      (0.05, 0.16, 0.16, -0.14, -0.14, 0.13, 0.15, 0.08),
                                      (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
  
  KnightEval: array of array of double = ((-0.55, -0.40, -0.30, -0.28, -0.26, -0.30, -0.40, -0.50),
                                        (-0.37, -0.15, 0.0, -0.06, 0.04, 0.03, -0.17, -0.40), 
                                        (-0.25, 0.05, 0.16, 0.12, 0.11, 0.06, 0.06, -0.29), 
                                        (-0.24, 0.05, 0.21, 0.14, 0.18, 0.09, 0.11, -0.26), 
                                        (-0.36, -0.05, 0.09, 0.23, 0.24, 0.21, 0.02, -0.24), 
                                        (-0.32, -0.01, 0.04, 0.19, 0.20, 0.04, 0.11, -0.25), 
                                        (-0.38, -0.22, 0.04, -0.01, 0.08, -0.05, -0.18, -0.34), 
                                        (-0.50, -0.46, -0.32, -0.24, -0.36, -0.25, -0.34, -0.50));
  
  BishopEval: array of array of double = ((-0.16, -0.15, -0.12, -0.05, -0.10, -0.12, -0.10, -0.20), 
                                        (-0.13, 0.05, 0.06, 0.01, -0.06, -0.05, 0.03, -0.06), 
                                        (-0.16, 0.06, -0.01, 0.16, 0.07, -0.01, -0.06, -0.05), 
                                        (-0.14, -0.01, 0.11, 0.14, 0.04, 0.10, 0.11, -0.13), 
                                        (-0.04, 0.05, 0.12, 0.16, 0.04, 0.06, 0.02, -0.16), 
                                        (-0.15, 0.04, 0.14, 0.08, 0.16, 0.04, 0.16, -0.15), 
                                        (-0.05, 0.06, 0.06, 0.06, 0.03, 0.06, 0.09, -0.07), 
                                        (-0.14, -0.04, -0.15, -0.04, -0.09, -0.04, -0.12, -0.14));
  
  RookEval: array of array of double = ((0.05, -0.02, 0.06, 0.02, -0.02, -0.06, 0.04, -0.02),
                                        (0.08, 0.13, 0.11, 0.15, 0.11, 0.15, 0.16, 0.04),
                                        (-0.06, 0.03, 0.03, 0.06, 0.01, -0.02, 0.03, -0.05),
                                        (-0.10, 0.05, -0.04, -0.04, -0.01, -0.06, 0.03, -0.02),
                                        (-0.04, 0.03, 0.05, -0.02, 0.04, 0.01, -0.05, 0.01),
                                        (0.00, 0.01, 0.01, -0.03, 0.05, 0.06, 0.01, -0.09),
                                        (-0.10, -0.01, -0.04, 0.0, 0.05, -0.06, -0.06, -0.09),
                                        (-0.01, -0.02, -0.06, 0.09, 0.09, 0.05, 0.04, -0.05));
  
  QueenEval: array of array of double = ((-0.21, -0.7, -0.6, 0.01, -0.8, -0.15, -0.10, -0.16), 
                                        (-0.04, -0.05, 0.03, -0.04, 0.02, 0.06, 0.03, -0.10), 
                                        (-0.13, -0.2, 0.7, 0.2, 0.6, 0.10, -0.04, -0.6), 
                                        (-0.01, -0.04, 0.3, 0.01, 0.08, 0.8, -0.02, -0.02), 
                                        (0.0, 0.06, 0.08, 0.01, -0.01, 0.1, 0.0, -0.03), 
                                        (-0.11, 0.10, 0.06, 0.03, 0.07, 0.09, 0.04, -0.10), 
                                        (-0.12, -0.06, 0.05, 0.0, 0.0, -0.05, 0.04, -0.10), 
                                        (-0.20, -0.06, -0.07, -0.07, -0.04, -0.12, -0.09, -0.20));
                                        
 KingEval: array of array of double =((-0.50,-0.40,-0.30,-0.20,-0.20,-0.30,-0.40,-0.50),
                                      (-0.30,-0.18,-0.15,0.06,0.03,-0.06,-0.24,-0.30),
                                      (-0.35,-0.16,0.20,0.32,0.34,0.14,-0.11,-0.30),
                                      (-0.34,-0.05,0.24,0.35,0.34,0.35,-0.16,-0.35),
                                      (-0.36,-0.07,0.31,0.34,0.34,0.34,-0.12,-0.31),
                                      (-0.30,-0.07,0.14,0.33,0.36,0.16,-0.13,-0.33),
                                      (-0.36,-0.27,0.05,0.02,0.05,-0.01,-0.31,-0.33),
                                      (-0.48,-0.26,-0.26,-0.26,-0.28,-0.25,-0.30,-0.51));

procedure SplitBoard;
var
  i, j: integer;
begin
  setlength(boardb, 8);
  setlength(boardw, 8);
  for i := 0 to length(board) - 1 do
  begin
    setlength(boardb[i], 8);
    setlength(boardw[i], 8);  
  end;
  
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      if board[i][j][1] = 'b' then
        boardb[i][j] := board[i][j]
      else
        boardb[i][j] := '  ';
      if board[i][j][1] = 'w' then
        boardw[i][j] := board[i][j]
      else
        boardw[i][j] := '  ';      
    end;
  end;  
end;

procedure Print(brd: array of array of string);
var
  i, j: integer;
begin
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      if ((brd[i][j] = '') or (brd[i][j] = '  ')) then
        write(' - ')
      else
        write(brd[i][j]:3); 
    end;
    writeln();
  end;
  writeln();
end;

procedure Print(brd: array of array of double);
var
  i, j: integer;
begin
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
      write(brd[i][j]:6:2);
    writeln;
  end;
  writeln();
end;

function Reverse(brd: array of array of string): array of array of string;
var
  i, j: integer;
  Return: array of array of string;
begin
  setlength(Return, 8);  
  for i := 0 to 7 do setlength(Return[i], 8); 
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      Return[7 - i][7 - j] := brd[i][j];  
    end;    
  end;
  Reverse := Return;
end;

function Reverse(brd: array of array of double): array of array of double;
var
  i, j: integer;
  Return: array of array of double;
begin
  setlength(Return, 8);  
  for i := 0 to 7 do setlength(Return[i], 8); 
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      Return[7 - i][7 - j] := brd[i][j];  
    end;    
  end;
  Reverse := Return;
end;

function WriteMove(f: string; i, j: integer; ik, jk: integer; side: string): string;
var
  s: string;
begin
  //writeln(f,' ',i,' ',j,' ',ik,' ',jk,' ',side);
  if f = '' then begin
    writeln('CRASH');
    halt(0);
  end;
  s := f[2];
  if s = 'P' then
    s := '';  
  if side = 'w' then begin
    i := 8 - i;
    ik := 8 - ik;
  end
  else begin
    i := i + 1;
    j := 7 - j;
    ik := ik + 1;
    jk := 7 - jk;
  end; 
  {
  case j of
    0:  s:=s+'a';
    1:  s:=s+'b';
    2:  s:=s+'c';
    3:  s:=s+'d';
    4:  s:=s+'e';
    5:  s:=s+'f';
    6:  s:=s+'g';
    7:  s:=s+'h';
  end;
  s:=s+IntToStr(i);}
  case jk of
    0:  s := s + 'a';
    1:  s := s + 'b';
    2:  s := s + 'c';
    3:  s := s + 'd';
    4:  s := s + 'e';
    5:  s := s + 'f';
    6:  s := s + 'g';
    7:  s := s + 'h';
  end;
  s := s + IntToStr(ik);
  WriteMove := s; 
end;

function CheckAttacks(brd: array of array of string; side: string): array of array of string;
var
  i, j, k, i1, j1: integer;
  Attacks: array of array of string;
begin
  Setlength(Attacks, 8);
  for i := 7 downto 0 do
  begin
    Setlength(Attacks[i], 8);
  end;
  
  for i := 7 downto 0 do
  begin
    for j := 7 downto 0 do
    begin  
      //writeln(i, ' ',j);
      //Print(Attacks);      
      
      if brd[i][j][1] <> side then
        continue;
      
      if brd[i][j] = '  ' then
        continue;
      
      if brd[i][j][2] = 'P' then begin
        if ((i - 1) >= 0) then begin
          if (j - 1 >= 0) then
            Attacks[i - 1][j - 1] := Attacks[i - 1][j - 1] + brd[i][j];
          if ((j + 1) <= 7) then
            Attacks[i - 1][j + 1] := Attacks[i - 1][j + 1] + brd[i][j];
        end;
      end;
      
      if brd[i][j][2] = 'B' then begin
        k := 1;
        while ((i - k >= 0) and (j - k >= 0)) do
        begin
          if (brd[i - k][j - k] <> '  ') then begin
            Attacks[i - k][j - k] := brd[i][j] + Attacks[i - k][j - k];
            break;
          end;
          Attacks[i - k][j - k] := brd[i][j] + Attacks[i - k][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((i - k >= 0) and (j + k <= 7)) do
        begin
          if (brd[i - k][j + k] <> '  ') then begin
            Attacks[i - k][j + k] := brd[i][j] + Attacks[i - k][j + k];
            break;
          end;
          Attacks[i - k][j + k] := brd[i][j] + Attacks[i - k][j + k];
          k := k + 1;
        end;
        k := 1;
        while ((i + k <= 7) and (j - k >= 0)) do
        begin
          if (brd[i + k][j - k] <> '  ') then begin
            Attacks[i + k][j - k] := brd[i][j] + Attacks[i + k][j - k];
            break;
          end;
          Attacks[i + k][j - k] := brd[i][j] + Attacks[i + k][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((i + k <= 7) and (j + k <= 7)) do
        begin
          if (brd[i + k][j + k] <> '  ') then begin
            Attacks[i + k][j + k] := brd[i][j] + Attacks[i + k][j + k];
            break;
          end;
          Attacks[i + k][j + k] := brd[i][j] + Attacks[i + k][j + k];
          k := k + 1;
        end;
      end; 
      
      if brd[i][j][2] = 'N' then begin
        if (i + 2 <= 7) then begin
          if (j - 1) >= 0 then
            Attacks[i + 2][j - 1] := brd[i][j]  + Attacks[i + 2][j - 1];
          if (j + 1) <= 7 then
            Attacks[i + 2][j + 1] := brd[i][j]  + Attacks[i + 2][j + 1];
        end;       
        if (i - 2 >= 0) then begin
          if (j - 1) >= 0 then
            Attacks[i - 2][j - 1] := brd[i][j] + Attacks[i - 2][j - 1];
          if (j + 1) <= 7 then
            Attacks[i - 2][j + 1] := brd[i][j] + Attacks[i - 2][j + 1];
        end;       
        if (j - 2 >= 0) then begin
          if (i - 1) >= 0 then
            Attacks[i - 1][j - 2] := brd[i][j] + Attacks[i - 1][j - 2];
          if (i + 1) <= 7 then
            Attacks[i + 1][j - 2] := brd[i][j] + Attacks[i + 1][j - 2];
        end;       
        if (j + 2 <= 7) then begin
          if (i - 1) >= 0 then
            Attacks[i - 1][j + 2] := brd[i][j] + Attacks[i - 1][j + 2];
          if (i + 1) <= 7 then
            Attacks[i + 1][j + 2] := brd[i][j] + Attacks[i + 1][j + 2];
        end;       
      end;
      
      if brd[i][j][2] = 'R' then begin
        k := 1;
        while ((i - k) >= 0) do
        begin
          if (brd[i - k][j] <> '  ') then begin
            Attacks[i - k][j] := brd[i][j] + Attacks[i - k][j];
            break;
          end;
          Attacks[i - k][j] := brd[i][j] + Attacks[i - k][j];
          k := k + 1;
        end;
        k := 1;
        while ((i + k) <= 7) do
        begin
          if (brd[i + k][j] <> '  ') then begin
            Attacks[i + k][j] := brd[i][j] + Attacks[i + k][j];
            break;
          end;
          Attacks[i + k][j] := brd[i][j] + Attacks[i + k][j];
          k := k + 1;
        end;
        k := 1;
        while ((j - k) >= 0) do
        begin
          if (brd[i][j - k] <> '  ') then begin
            Attacks[i][j - k] := brd[i][j] + Attacks[i][j - k];
            break;
          end;
          Attacks[i][j - k] := brd[i][j] + Attacks[i][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((j + k) <= 7) do
        begin
          if (brd[i][j + k] <> '  ') then begin
            Attacks[i][j + k] := brd[i][j] + Attacks[i][j + k];
            break;
          end;
          Attacks[i][j + k] := brd[i][j] + Attacks[i][j + k];
          k := k + 1;
        end;        
      end;
      
      if brd[i][j][2] = 'Q' then begin
        k := 1;
        while ((i - k) >= 0) do
        begin
          if (brd[i - k][j] <> '  ') then begin
            Attacks[i - k][j] := brd[i][j] + Attacks[i - k][j];
            break;
          end;
          Attacks[i - k][j] := brd[i][j] + Attacks[i - k][j];
          k := k + 1;
        end;
        k := 1;
        while ((i + k) <= 7) do
        begin
          if (brd[i + k][j] <> '  ') then begin
            Attacks[i + k][j] := brd[i][j] + Attacks[i + k][j];
            break;
          end;
          Attacks[i + k][j] := brd[i][j] + Attacks[i + k][j];
          k := k + 1;
        end;
        k := 1;
        while ((j - k) >= 0) do
        begin
          if (brd[i][j - k] <> '  ') then begin
            Attacks[i][j - k] := brd[i][j] + Attacks[i][j - k];
            break;
          end;
          Attacks[i][j - k] := brd[i][j] + Attacks[i][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((j + k) <= 7) do
        begin
          if (brd[i][j + k] <> '  ') then begin
            Attacks[i][j + k] := brd[i][j] + Attacks[i][j + k];
            break;
          end;
          Attacks[i][j + k] := brd[i][j] + Attacks[i][j + k];
          k := k + 1;
        end;
        k := 1;
        while ((i - k >= 0) and (j - k >= 0)) do
        begin
          if (brd[i - k][j - k] <> '  ') then begin
            Attacks[i - k][j - k] := brd[i][j] + Attacks[i - k][j - k];
            break;
          end;
          Attacks[i - k][j - k] := brd[i][j] + Attacks[i - k][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((i - k >= 0) and (j + k <= 7)) do
        begin
          if (brd[i - k][j + k] <> '  ') then begin
            Attacks[i - k][j + k] := brd[i][j] + Attacks[i - k][j + k];
            break;
          end;
          Attacks[i - k][j + k] := brd[i][j] + Attacks[i - k][j + k];
          k := k + 1;
        end;
        k := 1;
        while ((i + k <= 7) and (j - k >= 0)) do
        begin
          if (brd[i + k][j - k] <> '  ') then begin
            Attacks[i + k][j - k] := brd[i][j] + Attacks[i + k][j - k];
            break;
          end;
          Attacks[i + k][j - k] := brd[i][j] + Attacks[i + k][j - k];
          k := k + 1;
        end;
        k := 1;
        while ((i + k <= 7) and (j + k <= 7)) do
        begin
          if (brd[i + k][j + k] <> '  ') then begin
            Attacks[i + k][j + k] := brd[i][j] + Attacks[i + k][j + k];
            break;
          end;
          Attacks[i + k][j + k] := brd[i][j] + Attacks[i + k][j + k];
          k := k + 1;
        end;
      end;
      
      if brd[i][j][2] = 'K' then begin
        for i1 := -1 to 1 do
        begin
          for j1 := -1 to 1 do
          begin
            if not ((i1 = 0) and (j1 = 0)) then begin
              if ((not((i1 = 0) and (j1 = 0))) and (i + i1 >= 0) and (i + i1 <= 7) and (j + j1 >= 0) and (j + j1 <= 7)) then
                Attacks[i + i1][j + j1] := Attacks[i + i1][j + j1] + brd[i][j];
            end;
          end;
        end;  
      end;
      
    end;
  end; 
  CheckAttacks := Attacks;
end;

function FigureCost(f: string): double;
begin
  case f[2] of 
    'P':  FigureCost := 1;
    'R':  FigureCost := 5;
    'N':  FigureCost := 3.2;
    'B':  FigureCost := 3.1;
    'Q':  FigureCost := 9;
    'K':  FigureCost := 20;
  else FigureCost := 0;
  end; 
end;

procedure Clone(brd1, brd2: array of array of string);
var
  i, j: integer;
begin
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      brd2[i][j] := brd1[i][j];
    end;
  end;
end;

procedure MoveFigure(brd: array of array of string; i, j, i1, j1: integer);
begin
  brd[i1][j1] := brd[i][j];
  brd[i][j] := '  ';
end;

function AttackCost(f: string): double;
var
  k: integer;
  c: double;
begin
  c := 0;
  k := 2;
  while k <= length(f) do
  begin
    case f[k] of 
      'P':  c := c + 0.2;
      'B':  c := c + 0.25;
      'N':  c := c + 0.3;
      'R':  c := c + 0.35;
      'Q':  c := c + 0.4;
      'K':  c := c + 0.1;
    else c := c + 0;
    end; 
    k := k + 2;
  end;
  AttackCost := c;
end;

function FutureAttacks(brd: array of array of string; figure, side: string): double;
var
  Theirboard, Attacks: array of array of string;
  other: string;
  n: double;
  i, j: integer;
begin
  if side = 'w' then begin
    TheirBoard := boardb;
    other := 'b';
  end
  else begin
    TheirBoard := Reverse(boardw);
    other := 'w';
  end;
  Attacks := CheckAttacks(brd, side);
  n := 0;
  for i := 0 to 7 do
  begin
    for j := 0 to 7 do
    begin
      if ((figure in Attacks[i][j]) and (other in TheirBoard[i][j])) then
        n := n + FigureCost(TheirBoard[i][j]) / 10;
    end;
  end; 
  FutureAttacks := n;
end;

function FindKing(brd:array of array of string;side:string):string;
var
  i,j:integer;
  s:string;
begin
  for i:=0 to 7 do begin
    for j:=0 to 7 do begin
      if (brd[i][j] = (side + 'K')) then
        s:=IntToStr(i)+IntToStr(j);
    end;
  end; 
  Findking:=s;
end;

function BigSum(brd: array of array of string; i, j, ii, jj: integer; side: string): double;
var
  n, n0, n1, n2, n3, n4, n5, n6,n7: double;
  temp,temp2: array of array of string;
  kng,other:string;
  k,k1,k2: integer;
begin
  setlength(temp, 8);
  setlength(temp2, 8);
  for k := 0 to 7 do
  begin
    setlength(temp[k], 8);
    setlength(temp2[k], 8);
  end;
  
  Clone(brd, temp);  
  MoveFigure(temp, i, j, ii, jj);
   
  //writeln(i,'-',j,'/',ii,'-',jj);
  n := (random(10) - 5) / 100;
  
  n0 := CostBoard[ii][jj];
  n1 := AttackBoard[i][j];
  n2 := ZashitaBoard[ii][jj];  
  n3 := FigureCost(brd[i][j]); 
  n4 := AttackCost(CheckAttacks(temp, side)[ii][jj]);
  n5 := AttackCost(brd[i][j]);
  n6 := FutureAttacks(temp, temp[ii][jj], side);
  
  kng:=FindKing(temp,side);
  k1:=StrtoInt(kng[1]);
  k2:=StrtoInt(kng[2]);
  
  if side = 'w' then begin
    other := 'b';
  end
  else begin
    other := 'w'
  end;
  
  temp2:=Reverse(CheckAttacks(Reverse(temp),other));
  
  if (AttackCost(temp2[k1][k2]) <> 0.0) then begin
    if (brd[i][j][2] = 'K') then
      n:=n - FigureCost('aK')*2
    else
      n:=n - FigureCost('aK');
  end;
  
  if (AttackCost(temp2[i][j]) > n5) then
    if AttackCost(temp2[ii][jj]) <> 0.0 then
      n:=n - n3;
  
  if brd[ii][jj] = '  ' then begin
    if n2 > 0 then begin
      if n5 > n2 then  
        n := n + (n4 - n5 - n2)
      else begin
        if (n4 - n5 >= n2) then 
          n := n + (n4 - n2) + n5
        else
          n := n + (n4 - n2) - n3;  
      end
    end
    else begin
      n := n + n6;  
    end;
  end
  else begin
    if (n2 = 0) then 
      n := n + (n4 - n2) + n0 + n6
    else begin
      if (n0 > n3) then 
        n := n + (n4 - n2) * 0.5 + n0 - n3 * 0.75
      else if (n0 = n3) then
        n := n + (n4 - n2) + n5         
      else
        n := n + (n4 - n2) + n0 - n3;
      
      if (n4 <= n2) then
        n := n + (n4 - n5 - n2) + n0 - n3;
    end;
  end;
  
  if n4 < n1 then
    n := n - n1 * 2 + n4;
  
  n7 := ZashitaBoard[i][j];
  
  if n5 > n7 then
  begin
    if n2 < n7 then
      n := n + n5*2;    
  end;
    
  BigSum := n;
end;

function EvaluateBoard(brd: array of array of string; side: string): array of array of string;
var
  i, j, k, i1, j1, imax, jmax, ik, jk,k1,k2: integer;
  OurBoard: array of array of double;
  TheirBoard, Future: array of array of string;
  other, fmax, kng: string;
  n, max: double;
begin
  SplitBoard;
  if side = 'w' then begin
    TheirBoard := boardb;
    other := 'b';
  end
  else begin
    TheirBoard := Reverse(boardw);
    brd := Reverse(brd);
    other := 'w'
  end;
  
  Chkd := CheckAttacks(brd, side);
  Zashita := Reverse(CheckAttacks(Reverse(brd), other));   
  
  setlength(OurBoard, 8);
  setlength(CostBoard, 8);
  setlength(AttackBoard, 8);
  setlength(ZashitaBoard, 8);
  setlength(Future, 8);
  for i := 0 to 7 do
  begin
    setlength(OurBoard[i], 8);
    setlength(CostBoard[i], 8);
    setlength(AttackBoard[i], 8);
    setlength(ZashitaBoard[i], 8);
    setlength(Future[i], 8);
    for j := 0 to 7 do
    begin
      CostBoard[i][j] :=  FigureCost(Theirboard[i][j]);
      AttackBoard[i][j] := AttackCost(Chkd[i][j]);
      ZashitaBoard[i][j] := AttackCost(Zashita[i][j]);
      OurBoard[i][j] := -50.00;
    end;
  end; 

  max := -50.00;
  fmax:='';
  //Print(Theirboard);
  //Print(CostBoard);
  //Print(AttackBoard);
  //Print(ZashitaBoard);
  //Print(Chkd); 
  
  for i := 7 downto 0 do
  begin
    for j := 7 downto 0 do
    begin
      
      if brd[i][j][1] <> side then continue;      
      if brd[i][j] = '  ' then continue;
      
      if brd[i][j] =  (side + 'P') then begin
        if i = 6 then begin
          if ((brd[i - 2][j] = '  ') and (brd[i - 1][j] = '  ')) then begin
            n := BigSum(brd, i, j, i - 2, j, side) + PawnEval[i - 2][j] + 2 * AttackCost(brd[i][j]);
            if n > OurBoard[i - 2][j] then
              OurBoard[i - 2][j] := n;
            if n > max then begin
              ik := i - 2;
              jk := j;
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
            end;
          end;
        end;
        if (i - 1 >= 0) then begin
          if ((j - 1 >= 0) and (brd[i - 1][j - 1] <> '  ') and (brd[i - 1][j - 1][1] <> side)) then begin
            n := BigSum(brd, i, j, i - 1, j - 1, side)  + PawnEval[i - 1][j - 1];
            if n > OurBoard[i - 1][j - 1] then
              OurBoard[i - 1][j - 1] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - 1;
              jk := j - 1;
            end;
          end;
          
          if ((j + 1 <= 7) and (brd[i - 1][j + 1] <> '  ') and (brd[i - 1][j + 1][1] <> side)) then begin
            n := BigSum(brd, i, j, i - 1, j + 1, side) + PawnEval[i - 1][j + 1];
            if n > OurBoard[i - 1][j + 1] then
              OurBoard[i - 1][j + 1] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - 1;
              jk := j + 1;
            end;
          end;
          
          if (brd[i - 1][j] = '  ') then begin
            n := BigSum(brd, i, j, i - 1, j, side) + PawnEval[i - 1][j] + AttackCost(brd[i][j]);
            if n > OurBoard[i - 1][j] then
              OurBoard[i - 1][j] := n;
            if n > max then begin
              ik := i - 1;
              jk := j;
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
            end;
          end;
        end;
      end;
      
      if brd[i][j] = (side + 'R') then begin
        k := 1;
        while ((i - k) >= 0) do
        begin
          if (brd[i - k][j][1] = side) then
            break;
          if (brd[i - k][j] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j, side) + RookEval[i - k][j];            
            if AttackBoard[i - k][j] <> 0 then
              n := n - AttackCost('aR');
            if n > OurBoard[i - k][j] then
              OurBoard[i - k][j] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i - k, j, side) + RookEval[i - k][j];          
          if AttackBoard[i - k][j] <> 0 then
            n := n - AttackCost('aR');
          if n > OurBoard[i - k][j] then
            OurBoard[i - k][j] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k) <= 7) do
        begin
          if (brd[i + k][j][1] = side) then
            break;
          if (brd[i + k][j] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j, side) + RookEval[i + k][j];
            if AttackBoard[i + k][j] <> 0 then
              n := n - AttackCost('aR');
            if n > OurBoard[i + k][j] then
              OurBoard[i + k][j] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j, side) + RookEval[i + k][j];
          if AttackBoard[i + k][j] <> 0 then
            n := n - AttackCost('aR'); 
          if n > OurBoard[i + k][j] then
            OurBoard[i + k][j] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j;
          end; 
          k := k + 1;
          end;
        end;
        k := 1;
        while ((j - k) >= 0) do
        begin
          if (brd[i][j - k][1] = side) then
            break;
          if (brd[i][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i, j - k, side) + RookEval[i][j - k];
            if AttackBoard[i][j - k] <> 0 then
              n := n - AttackCost('aR');
            if n > OurBoard[i][j - k] then
              OurBoard[i][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i;
              jk := j - k;
            end; 
            break;
          end
          else begin
          n := BigSum(brd, i, j, i, j - k, side) + RookEval[i][j - k];
          if AttackBoard[i][j - k] <> 0 then
            n := n - AttackCost('aR');
          if n > OurBoard[i][j - k] then
            OurBoard[i][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i;
            jk := j - k;
          end; 
          k := k + 1;
          end;
        end;
        k := 1;
        while ((j + k) <= 7) do
        begin
          if (brd[i][j + k][1] = side) then
            break;
          if (brd[i][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i, j + k, side) + RookEval[i][j + k];
            if AttackBoard[i][j + k] <> 0 then
              n := n - AttackCost('aR');
            if n > OurBoard[i][j + k] then
              OurBoard[i][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i;
              jk := j + k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i, j + k, side) + RookEval[i][j + k];
          if AttackBoard[i][j + k] <> 0 then
            n := n - AttackCost('aR');
          if n > OurBoard[i][j + k] then
            OurBoard[i][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i;
            jk := j + k;
          end;
          k := k + 1;
          end;
        end;        
      end;
      
      if brd[i][j] = (side + 'N') then begin
        if (i + 2 <= 7) then begin
          if (j - 1) >= 0 then begin
            if (brd[i + 2][j - 1][1] <> side) then begin
              n := BigSum(brd, i, j, i + 2, j - 1, side) + KnightEval[i + 2][j - 1];
              if AttackBoard[i + 2][j - 1] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i + 2][j - 1] then
                OurBoard[i + 2][j - 1] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i + 2;
                jk := j - 1;
              end; 
            end;
          end;
          if (j + 1) <= 7 then begin
            if (brd[i + 2][j + 1][1] <> side) then begin
              n := BigSum(brd, i, j, i + 2, j + 1, side) + KnightEval[i + 2][j + 1];
              if AttackBoard[i + 2][j + 1] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i + 2][j + 1] then
                OurBoard[i + 2][j + 1] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i + 2;
                jk := j + 1;
              end;
            end;
          end;
        end;       
        if (i - 2 >= 0) then begin
          if (j - 1) >= 0 then begin
            if (brd[i - 2][j - 1][1] <> side) then begin
              n := BigSum(brd, i, j, i - 2, j - 1, side) + KnightEval[i - 2][j - 1];
              if AttackBoard[i - 2][j - 1] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i - 2][j - 1] then
                OurBoard[i - 2][j - 1] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i - 2;
                jk := j - 1;
              end;
            end;
          end;
          if (j + 1) <= 7 then begin
            if (brd[i - 2][j + 1][1] <> side) then begin
              n := BigSum(brd, i, j, i - 2, j + 1, side) + KnightEval[i - 2][j + 1];
              if AttackBoard[i - 2][j + 1] <> 0 then
                n := n - AttackCost('aN'); 
              if n > OurBoard[i - 2][j + 1] then   
                OurBoard[i - 2][j + 1] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i - 2;
                jk := j + 1;
              end;
            end;
          end;
        end;       
        if (j - 2 >= 0) then begin
          if (i - 1) >= 0 then begin
            if (brd[i - 1][j - 2][1] <> side) then begin
              n := BigSum(brd, i, j, i - 1, j - 2, side) + KnightEval[i - 1][j - 2];
              if AttackBoard[i - 1][j - 2] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i - 1][j - 2] then 
                OurBoard[i - 1][j - 2] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i - 1;
                jk := j - 2;
              end;
            end;
          end;
          if (i + 1) <= 7 then begin
            if (brd[i + 1][j - 2][1] <> side) then begin
              n := BigSum(brd, i, j, i + 1, j - 2, side) + KnightEval[i + 1][j - 2];
              if AttackBoard[i + 1][j - 2] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i + 1][j - 2] then
                OurBoard[i + 1][j - 2] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i + 1;
                jk := j - 2;
              end;
            end;
          end;
        end;       
        if (j + 2 <= 7) then begin
          if (i - 1) >= 0 then begin
            if (brd[i - 1][j + 2][1] <> side) then begin
              n := BigSum(brd, i, j, i - 1, j + 2, side) + KnightEval[i - 1][j + 2];
              if AttackBoard[i - 1][j + 2] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i - 1][j + 2] then 
                OurBoard[i - 1][j + 2] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i - 1;
                jk := j + 2;
              end; 
            end;
          end;
          if (i + 1) <= 7 then begin
            if (brd[i + 1][j + 2][1] <> side) then begin
              n := BigSum(brd, i, j, i + 1, j + 2, side) + KnightEval[i + 1][j + 2];
              if AttackBoard[i + 1][j + 2] <> 0 then
                n := n - AttackCost('aN');
              if n > OurBoard[i][j + 2] then
                OurBoard[i + 1][j + 2] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i + 1;
                jk := j + 2;
              end;
            end;
          end;
        end;       
      end;
      
      if brd[i][j] = (side + 'B') then begin
        k := 1;
        while ((i - k >= 0) and (j - k >= 0)) do
        begin
          if (brd[i - k][j - k][1] = side) then
            break;
          if (brd[i - k][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j - k, side) + BishopEval[i - k][j - k];
            if AttackBoard[i - k][j - k] <> 0 then
              n := n - AttackCost('aB'); 
            if n > OurBoard[i - k][j - k] then 
              OurBoard[i - k][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j - k;
            end;           
            break;
          end
          else begin
          n := BigSum(brd, i, j, i - k, j - k, side) + BishopEval[i - k][j - k];
          if AttackBoard[i - k][j - k] <> 0 then
            n := n - AttackCost('aB'); 
          if n > OurBoard[i - k][j - k] then 
            OurBoard[i - k][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j - k;
          end;   
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i - k >= 0) and (j + k <= 7)) do
        begin
          if (brd[i - k][j + k][1] = side) then
            break;
          if (brd[i - k][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j + k, side) + BishopEval[i - k][j + k];
            if AttackBoard[i - k][j + k] <> 0 then
              n := n - AttackCost('aB');  
            if n > OurBoard[i - k][j + k] then
              OurBoard[i - k][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j + k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i - k, j + k, side) + BishopEval[i - k][j + k];
          if AttackBoard[i - k][j + k] <> 0 then
            n := n - AttackCost('aB');  
          if n > OurBoard[i - k][j + k] then
            OurBoard[i - k][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j + k;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k <= 7) and (j - k >= 0)) do
        begin
          if (brd[i + k][j - k][1] = side) then
            break;
          if (brd[i + k][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j - k, side) + BishopEval[i + k][j - k];
            if AttackBoard[i + k][j - k] <> 0 then
              n := n - AttackCost('aB');
            if n > OurBoard[i + k][j - k] then
              OurBoard[i + k][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j - k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j - k, side) + BishopEval[i + k][j - k];
          if AttackBoard[i + k][j - k] <> 0 then
            n := n - AttackCost('aB');
          if n > OurBoard[i + k][j - k] then
            OurBoard[i + k][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j - k;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k <= 7) and (j + k <= 7)) do
        begin
          if (brd[i + k][j + k][1] = side) then
            break;
          if (brd[i + k][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j + k, side) + BishopEval[i + k][j + k];
            if AttackBoard[i + k][j + k] <> 0 then
              n := n - AttackCost('aB');
            if n > OurBoard[i + k][j + k] then
              OurBoard[i + k][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j + k;
            end; 
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j + k, side) + BishopEval[i + k][j + k];
          if AttackBoard[i + k][j + k] <> 0 then
            n := n - AttackCost('aB');
          if n > OurBoard[i + k][j + k] then
            OurBoard[i + k][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j + k;
          end; 
          k := k + 1;
          end;
        end;
      end; 
      
      if brd[i][j] = (side + 'Q') then begin
        k := 1;
        while ((i - k >= 0) and (j - k >= 0)) do
        begin
          if (brd[i - k][j - k][1] = side) then
            break;
          if (brd[i - k][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j - k, side) + QueenEval[i - k][j - k];
            if AttackBoard[i - k][j - k] <> 0 then
              n := n - AttackCost('aQ'); 
            if n > OurBoard[i - k][j - k] then 
              OurBoard[i - k][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j - k;
            end;           
            break;
          end 
          else begin
          n := BigSum(brd, i, j, i - k, j - k, side) + QueenEval[i - k][j - k];
          if AttackBoard[i - k][j - k] <> 0 then
            n := n - AttackCost('aQ'); 
          if n > OurBoard[i - k][j - k] then 
            OurBoard[i - k][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j - k;
          end;   
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i - k >= 0) and (j + k <= 7)) do
        begin
          if (brd[i - k][j + k][1] = side) then
            break;
          if (brd[i - k][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j + k, side) + QueenEval[i - k][j + k];
            if AttackBoard[i - k][j + k] <> 0 then
              n := n - AttackCost('aQ');  
            if n > OurBoard[i - k][j + k] then
              OurBoard[i - k][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j + k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i - k, j + k, side) + QueenEval[i - k][j + k];
          if AttackBoard[i - k][j + k] <> 0 then
            n := n - AttackCost('aQ');  
          if n > OurBoard[i - k][j + k] then
            OurBoard[i - k][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j + k;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k <= 7) and (j - k >= 0)) do
        begin
          if (brd[i + k][j - k][1] = side) then
            break;
          if (brd[i + k][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j - k, side) + QueenEval[i + k][j - k];
            if AttackBoard[i + k][j - k] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i + k][j - k] then
              OurBoard[i + k][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j - k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j - k, side) + QueenEval[i + k][j - k];
          if AttackBoard[i + k][j - k] <> 0 then
            n := n - AttackCost('aQ');
          if n > OurBoard[i + k][j - k] then
            OurBoard[i + k][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j - k;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k <= 7) and (j + k <= 7)) do
        begin
          if (brd[i + k][j + k][1] = side) then
            break;
          if (brd[i + k][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j + k, side) + QueenEval[i + k][j + k];
            if AttackBoard[i + k][j + k] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i + k][j + k] then
              OurBoard[i + k][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j + k;
            end; 
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j + k, side) + QueenEval[i + k][j + k];
          if AttackBoard[i + k][j + k] <> 0 then
            n := n - AttackCost('aQ');
          if n > OurBoard[i + k][j + k] then
            OurBoard[i + k][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j + k;
          end; 
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i - k) >= 0) do
        begin
          if (brd[i - k][j][1] = side) then
            break;
          if (brd[i - k][j] <> '  ') then begin
            n := BigSum(brd, i, j, i - k, j, side) + QueenEval[i - k][j];            
            if AttackBoard[i - k][j] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i - k][j] then
              OurBoard[i - k][j] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i - k;
              jk := j;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i - k, j, side) + QueenEval[i - k][j];          
          if AttackBoard[i - k][j] <> 0 then
            n := n - AttackCost('aQ');
          if n > OurBoard[i - k][j] then
            OurBoard[i - k][j] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i - k;
            jk := j;
          end;
          k := k + 1;
          end;
        end;
        k := 1;
        while ((i + k) <= 7) do
        begin
          if (brd[i + k][j][1] = side) then
            break;
          if (brd[i + k][j] <> '  ') then begin
            n := BigSum(brd, i, j, i + k, j, side) + QueenEval[i + k][j];
            if AttackBoard[i + k][j] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i + k][j] then
              OurBoard[i + k][j] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i + k;
              jk := j;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i + k, j, side) + QueenEval[i + k][j];
          if AttackBoard[i + k][j] <> 0 then
            n := n - AttackCost('aQ'); 
          if n > OurBoard[i + k][j] then
            OurBoard[i + k][j] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i + k;
            jk := j;
          end; 
          k := k + 1;
          end;
        end;
        k := 1;
        while ((j - k) >= 0) do
        begin
          if (brd[i][j - k][1] = side) then
            break;
          if (brd[i][j - k] <> '  ') then begin
            n := BigSum(brd, i, j, i, j - k, side) + QueenEval[i][j - k];
            if AttackBoard[i][j - k] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i][j - k] then
              OurBoard[i][j - k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i;
              jk := j - k;
            end; 
            break;
          end
          else begin
          n := BigSum(brd, i, j, i, j - k, side) + QueenEval[i][j - k];
          if AttackBoard[i][j - k] <> 0 then
            n := n - AttackCost('aQ');
          if n > OurBoard[i][j - k] then
            OurBoard[i][j - k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i;
            jk := j - k;
          end; 
          k := k + 1;
          end;
        end;
        k := 1;
        while ((j + k) <= 7) do
        begin
          if (brd[i][j + k][1] = side) then
            break;
          if (brd[i][j + k] <> '  ') then begin
            n := BigSum(brd, i, j, i, j + k, side) + QueenEval[i][j + k];
            if AttackBoard[i][j + k] <> 0 then
              n := n - AttackCost('aQ');
            if n > OurBoard[i][j + k] then
              OurBoard[i][j + k] := n;
            if n > max then begin
              imax := i;
              jmax := j;
              fmax := brd[i][j];
              max := n;
              ik := i;
              jk := j + k;
            end;
            break;
          end
          else begin
          n := BigSum(brd, i, j, i, j + k, side) + QueenEval[i][j + k];
          if AttackBoard[i][j + k] <> 0 then
            n := n - AttackCost('aQ');
          if n > OurBoard[i][j + k] then
            OurBoard[i][j + k] := n;
          if n > max then begin
            imax := i;
            jmax := j;
            fmax := brd[i][j];
            max := n;
            ik := i;
            jk := j + k;
          end;
          k := k + 1;
          end;
        end; 
      end; 
      
      if brd[i][j] = (side + 'K') then begin
        k1:=i;
        k2:=j;
        for i1 := -1 to 1 do
        begin
          for j1 := -1 to 1 do
          begin
            if ( (not((i1 = 0) and (j1 = 0))) and (i + i1 >= 0) and (i + i1 <= 7) and (j + j1 >= 0) and (j + j1 <= 7)) and (brd[i + i1][j + j1][1] <> side) and (ZashitaBoard[i + i1][j + j1] = 0) then begin
                n := BigSum(brd, i, j, i + i1, j + j1, side) + KingEval[i+i1][j+j1];
              if n > OurBoard[i + i1][j + j1] then
                OurBoard[i + i1][j + j1] := n;
              if n > max then begin
                imax := i;
                jmax := j;
                fmax := brd[i][j];
                max := n;
                ik := i + i1;
                jk := j + j1;
              end; 
            end;
          end;
        end;        
      end;
      
    end;
  end;
  
  if mode = 1 then
    write(writemove(fmax, imax, jmax, ik, jk, side), ' ');
    
  if (ik = 0) and (fmax[2] = 'P') then
    brd[imax][jmax] := side + 'Q';
  

  if (brd[ik][jk] = (other + 'K')) or ((ZashitaBoard[k1][k2] <> 0.0) and (fmax='')) then begin
    writeln('!CHECKMATE!');
    halt(0);
  end;  
  if side = 'w' then begin
    //writeln(max,fmax,imax,jmax,ik,jk,side);
    //Print(OurBoard);
    
    MoveFigure(brd, imax, jmax, ik, jk);    
    EvaluateBoard := brd;    
  end
  else begin
    //writeln(max,fmax,imax,jmax,ik,jk,side);
    //Print(reverse(OurBoard));
    
    MoveFigure(brd, imax, jmax, ik, jk); 
    Evaluateboard := reverse(brd);
  end;
end;


var
  shetchik: integer;
  side: string;  
  temp: array of array of string;

begin
  side := cvet;
  {
  setlength(temp,8);
  for shetchik:=0 to 7 do
    setlength(temp[shetchik],8);
  
  Print(EvaluateBoard(board,side));
  
  Clone(board,temp);  
  MoveFigure(temp,6,3,4,3);
  Print(temp);
  temp:=CheckAttacks(temp,side);
  Print(temp); 
  }
  if mode = 2 then
    Print(board);
  
  for shetchik := 1 to 200 do
  begin
    if mode = 2 then
      writeln(shetchik,'-',side)
      else begin
    if (shetchik mod 2 = 1) then
      write(shetchik div 2 + 1, '. ');
  end;
    board := EvaluateBoard(board, side);
    
    if mode = 2 then
      Print(board);
    if side = 'w' then
      side := 'b'
    else
      side := 'w';
    if (shetchik mod 2 = 0) then
      writeln;
  end;
end.
(* Simple module for formatted output based on Oakwood guidelines
 *
 * Copyright 2017-2019 ComdivByZero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)
MODULE Out;

 IMPORT Stream := VDataStream, IO := VDefaultIO, Chars0X, Platform;

 VAR
   success: BOOLEAN;
   ln     : ARRAY 2 OF CHAR;
   lnOfs  : INTEGER;
   out    : Stream.POut;

 PROCEDURE Write(s: ARRAY OF CHAR; ofs, len: INTEGER);
 BEGIN
   success := len = Stream.WriteChars(out^, s, ofs, len)
 END Write;

 PROCEDURE String*(s: ARRAY OF CHAR);
 BEGIN
   Write(s, 0, Chars0X.CalcLen(s, 0))
 END String;

 PROCEDURE Char*(ch: CHAR);
 VAR s: ARRAY 1 OF CHAR;
 BEGIN
   s[0] := ch;
   Write(s, 0, 1)
 END Char;

 PROCEDURE Int*(x, n: INTEGER);
 VAR s: ARRAY 32 OF CHAR;
     i: INTEGER;
     neg: BOOLEAN;
 BEGIN
   i := LEN(s);
   neg := FALSE;
   IF x = 0 THEN
     DEC(i);
     s[i] := "0"
   ELSE
     IF x < 0 THEN
       neg := TRUE;
       x := -x
     END;
     WHILE x # 0 DO
       DEC(i);
       s[i] := CHR(ORD("0") + x MOD 10);
       x := x DIV 10
     END;
     IF neg THEN
       DEC(i);
       s[i] := "-"
     END
   END;
   IF n < 0 THEN
     n := LEN(s)
   ELSIF n > LEN(s) THEN
     n := 0
   ELSE
     n := LEN(s) - n
   END;
   WHILE i > n DO
     DEC(i);
     s[i] := " "
   END;
   Write(s, i, LEN(s) - i)
 END Int;

 PROCEDURE Ln*;
 BEGIN
   Write(ln, lnOfs, LEN(ln) - lnOfs)
 END Ln;

 (* TODO *)
 PROCEDURE Real*(x: REAL; n: INTEGER);
 VAR s: ARRAY 64 OF CHAR;
     i, l, e, d: INTEGER;
     sign: BOOLEAN;
     tens: REAL;
 BEGIN
   i := LEN(s) DIV 2;
   IF x # x THEN
     l := i + 2;
     s[i    ] := "N";
     s[i + 1] := "a";
     s[i + 2] := "N"
   ELSIF (x = 0.0) OR (x = -0.0) THEN
     l := i + 2;
     s[i    ] := "0";
     s[i + 1] := ".";
     s[i + 2] := "0";
     IF x < 0.0 THEN
       DEC(i);
       s[i] := "-"
     END;
   ELSE
     sign := x < 0.0;
     l := i;
     IF sign THEN
       s[l] := "-";
       INC(l);
       x := -x
     END;
     IF x < 1.0 THEN
       e := -1;
       tens := 10.0;
       WHILE x * tens < 1.0 DO
         DEC(e);
         tens := tens * 10.0
       END;
       x := x * tens
     ELSIF 10.0 <= x THEN
       e := 1;
       tens := 10.0;
       WHILE (x / tens >= 10.0) & (e <= 308) DO
         INC(e);
         tens := tens * 10.0
       END;
       x := x / tens
     ELSE ASSERT((1.0 <= x) & (x < 10.0));
       e := 0
     END;
     IF e > 308 THEN
       s[l    ] := "i";
       s[l + 1] := "n";
       s[l + 2] := "f";
       INC(l, 2)
     ELSE
       s[l] := CHR(ORD("0") + FLOOR(x));
       INC(l);
       s[l] := ".";
       IF FLOOR(x * 10.0) MOD 10 = 0 THEN
         INC(l);
         s[l] := "0"
       ELSE
         WHILE (l < LEN(s) - 6) & (FLOOR(x * 10.0) MOD 10 # 0) DO
           x := x - FLT(FLOOR(x) MOD 10);
           x := x * 10.0;
           INC(l);
           s[l] := CHR(ORD("0") + FLOOR(x) MOD 10)
         END
       END;
       IF e # 0 THEN
         s[l + 1] := "E";
         INC(l, 2);
         IF e < 0 THEN
           e := -e;
           s[l] := "-"
         ELSE
           s[l] := "+"
         END;
         d := 100;
         WHILE e < d DO
           d := d DIV 10
         END;
         REPEAT
           INC(l);
           s[l] := CHR(ORD("0") + e DIV d);
           e := e MOD d;
           d := d DIV 10
         UNTIL d = 0
       END
     END
   END;
   IF n < l + 1 THEN
     n := l + 1 - n
   ELSE
     n := 0
   END;
   WHILE n < i DO
     DEC(i);
     s[i] := " "
   END;
   Write(s, i, l - i + 1)
 END Real;

 PROCEDURE LongReal*(x: REAL; n: INTEGER);
 BEGIN
   Real(x, n)
 END LongReal;

 PROCEDURE Open*;
 VAR o: Stream.POut;
 BEGIN
   o := IO.OpenOut();
   success := o # NIL;
   IF o # NIL THEN
     Stream.CloseOut(out);
     out := o
   END
 END Open;

BEGIN
   ln[0] := 0DX;
   ln[1] := 0AX;
   lnOfs := ORD(Platform.Posix);
   out   := IO.OpenOut()
END Out.

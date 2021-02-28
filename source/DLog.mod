(*  Log for debug information
 *  Copyright (C) 2016 ComdivByZero
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published
 *  by the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *)
MODULE DLog;

IMPORT Out;

VAR state*,
	init: BOOLEAN;

PROCEDURE Str*(s: ARRAY OF CHAR);
BEGIN
	IF state THEN
		Out.String(s)
	END
END Str;

PROCEDURE StrLn*(s: ARRAY OF CHAR);
BEGIN
	IF state THEN
		Out.String(s);
		Out.Ln
	END
END StrLn;

PROCEDURE Char*(ch: CHAR);
BEGIN
	IF state THEN
		Out.Char(ch)
	END
END Char;

PROCEDURE Int*(x: INTEGER);
BEGIN
	IF state THEN
		Out.Int(x, 0)
	END
END Int;

PROCEDURE Ln*;
BEGIN
	IF state THEN
		Out.Ln
	END
END Ln;

PROCEDURE Real*(x: REAL);
BEGIN
	IF state THEN
		Out.Real(x, 0)
	END
END Real;

PROCEDURE Bool*(b: BOOLEAN);
BEGIN
	IF ~state THEN
		;
	ELSIF b THEN
		Out.String("TRUE")
	ELSE
		Out.String("FALSE")
	END
END Bool;

PROCEDURE Set*(s: SET);
VAR i: INTEGER;
BEGIN
	IF state THEN
		Out.String("{ ");
		FOR i := 0 TO 31 DO
			IF i IN s THEN
				Out.Int(i, 0); Out.String(" ")
			END
		END;
		Out.String("}");
	END
END Set;

PROCEDURE Turn*(st: BOOLEAN);
BEGIN
	IF st & ~init THEN
		init := TRUE;
		Out.Open
	END;
	state := st
END Turn;

PROCEDURE On*;
BEGIN
	Turn(TRUE)
END On;

PROCEDURE Off*;
BEGIN
	Turn(FALSE)
END Off;

BEGIN
	init  := FALSE;
	state := FALSE
END DLog.

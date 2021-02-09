Platform-specific determination of preferable user interface language

Copyright (C) 2021 ComdivByZero

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

MODULE PlatformMessagesLang;

  IMPORT Lang := InterfaceLang, Env := OsEnv, Platform, LocaleParser;

  PROCEDURE GetEnv(VAR env: ARRAY OF CHAR): BOOLEAN;
  VAR ofs: INTEGER;
  BEGIN
    ofs := 0;
  RETURN
     Env.Get(env, ofs, "LC_ALL")
  OR Env.Get(env, ofs, "LC_MESSAGES")
  OR Env.Get(env, ofs, "LANG")
  END GetEnv;

  PROCEDURE Get*(VAR lang: INTEGER): BOOLEAN;
  VAR ok: BOOLEAN; env: ARRAY 16 OF CHAR; lng, state: ARRAY 3 OF CHAR; enc: ARRAY 6 OF CHAR;
  BEGIN
    ok := Platform.Posix
        & GetEnv(env)
        & LocaleParser.Parse(env, lng, state, enc)
        & (enc = "UTF-8");
    IF ~ok THEN
      ;
    ELSIF lng = "ru" THEN
      lang := Lang.Ru
    ELSIF lng = "uk" THEN
      lang := Lang.Ua
    ELSIF lng = "en" THEN
      lang := Lang.En
    ELSE
      ok := FALSE
    END
  RETURN
    ok
  END Get;

END PlatformMessagesLang.

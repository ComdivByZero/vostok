(*  Checker of special identifiers
 *  Copyright (C) 2018 ComdivByZero
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
MODULE SpecIdentChecker;

  IMPORT Strings := StringStore;

  CONST
    MathC* = 0;

  PROCEDURE Eq(name: Strings.String; str: ARRAY OF CHAR): BOOLEAN;
  RETURN Strings.IsEqualToString(name, str)
  END Eq;

  PROCEDURE IsCKeyWord*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "a": o := Eq(n, "auto")
             OR Eq(n, "asm")
    | "b": o := Eq(n, "break")
    | "c": o := Eq(n, "case")
             OR Eq(n, "char")
             OR Eq(n, "const")
             OR Eq(n, "continue")
    | "d": o := Eq(n, "default")
             OR Eq(n, "do")
             OR Eq(n, "double")
    | "e": o := Eq(n, "else")
             OR Eq(n, "enum")
             OR Eq(n, "extern")
    | "f": o := Eq(n, "float")
             OR Eq(n, "for")
    | "g": o := Eq(n, "goto")
    | "i": o := Eq(n, "if")
             OR Eq(n, "inline")
             OR Eq(n, "int")
    | "l": o := Eq(n, "long")
    | "r": o := Eq(n, "register")
             OR Eq(n, "restrict")
             OR Eq(n, "return")
    | "s": o := Eq(n, "short")
             OR Eq(n, "signed")
             OR Eq(n, "sizeof")
             OR Eq(n, "static")
             OR Eq(n, "struct")
             OR Eq(n, "switch")
    | "t": o := Eq(n, "typedef")
             OR Eq(n, "typeof")
    | "u": o := Eq(n, "union")
             OR Eq(n, "unsigned")
    | "v": o := Eq(n, "void")
             OR Eq(n, "volatile")
    | "w": o := Eq(n, "while")
    | "h", "j", "k", "m" .. "q", "x" .. "z": o := FALSE
    END
    RETURN o
  END IsCKeyWord;

  PROCEDURE IsCLib*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "a": o := Eq(n, "abort")
             OR Eq(n, "assert")
             OR Eq(n, "atof")
             OR Eq(n, "atoi")
             OR Eq(n, "atol")
             OR Eq(n, "atoll")
             OR Eq(n, "abs")
             OR Eq(n, "atexit")
    | "b": o := Eq(n, "bool")
             OR Eq(n, "bsearch")
    | "c": o := Eq(n, "calloc")
    | "d": o := Eq(n, "div")
    | "e": o := Eq(n, "errno")
             OR Eq(n, "exit")
    | "f": o := Eq(n, "free")
             OR Eq(n, "fputc")
             OR Eq(n, "fputs")
    | "g": o := Eq(n, "getenv")
    | "l": o := Eq(n, "labs")
             OR Eq(n, "ldiv")
             OR Eq(n, "llabs")
             OR Eq(n, "lldiv")
    | "m": o := Eq(n, "main")
             OR Eq(n, "malloc")
             OR Eq(n, "memchr")
             OR Eq(n, "memcmp")
             OR Eq(n, "memcpy")
             OR Eq(n, "memset")
             OR Eq(n, "mblen")
             OR Eq(n, "mbtowc")
             OR Eq(n, "mbstowcs")
    | "p": o := Eq(n, "putc")
             OR Eq(n, "putchar")
             OR Eq(n, "puts")
    | "q": o := Eq(n, "qsort")
    | "r": o := Eq(n, "rand")
             OR Eq(n, "realloc")
    | "s": o := Eq(n, "strcspn")
             OR Eq(n, "strerror")
             OR Eq(n, "strspn")
             OR Eq(n, "strrchr")
             OR Eq(n, "strpbrk")
             OR Eq(n, "strchr")
             OR Eq(n, "strcat")
             OR Eq(n, "strstr")
             OR Eq(n, "strncat")
             OR Eq(n, "strcmp")
             OR Eq(n, "strcoll")
             OR Eq(n, "strcpy")
             OR Eq(n, "strncpy")
             OR Eq(n, "strlen")
             OR Eq(n, "strtok")
             OR Eq(n, "strtol")
             OR Eq(n, "strtoll")
             OR Eq(n, "strtoul")
             OR Eq(n, "strtoull")
             OR Eq(n, "strtod")
             OR Eq(n, "strtof")
             OR Eq(n, "strtold")
             OR Eq(n, "strxfrm")
             OR Eq(n, "srand")
             OR Eq(n, "system")
    | "w": o := Eq(n, "wctomb")
             OR Eq(n, "wcstombs")
    | "h", "i" .. "k", "n" .. "o", "t" .. "v", "x" .. "z": o := FALSE
    END
    RETURN o
  END IsCLib;

  PROCEDURE IsCMath*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "a": o := Eq(n, "acos")
             OR Eq(n, "acosf")
             OR Eq(n, "acosl")
             OR Eq(n, "acosh")
             OR Eq(n, "acoshf")
             OR Eq(n, "acoshl")
             OR Eq(n, "asin")
             OR Eq(n, "asinf")
             OR Eq(n, "asinl")
             OR Eq(n, "asinh")
             OR Eq(n, "asinhf")
             OR Eq(n, "asinhl")
             OR Eq(n, "atan")
             OR Eq(n, "atanf")
             OR Eq(n, "atanl")
             OR Eq(n, "atan2")
             OR Eq(n, "atan2f")
             OR Eq(n, "atan2l")
             OR Eq(n, "atanh")
             OR Eq(n, "atanhf")
             OR Eq(n, "atanhl")
    | "c": o := Eq(n, "cbrt")
             OR Eq(n, "cbrtf")
             OR Eq(n, "cbrtl")
             OR Eq(n, "ceil")
             OR Eq(n, "ceilf")
             OR Eq(n, "ceill")
             OR Eq(n, "copysign")
             OR Eq(n, "copysignf")
             OR Eq(n, "copysignl")
             OR Eq(n, "cos")
             OR Eq(n, "cosf")
             OR Eq(n, "cosl")
             OR Eq(n, "cosh")
             OR Eq(n, "coshf")
             OR Eq(n, "coshl")
    | "e": o := Eq(n, "erf")
             OR Eq(n, "erff")
             OR Eq(n, "erfl")
             OR Eq(n, "erfc")
             OR Eq(n, "erfcf")
             OR Eq(n, "erfcl")
             OR Eq(n, "exp")
             OR Eq(n, "expf")
             OR Eq(n, "expl")
             OR Eq(n, "exp2")
             OR Eq(n, "exp2f")
             OR Eq(n, "exp2l")
             OR Eq(n, "expm1")
             OR Eq(n, "expm1f")
             OR Eq(n, "expm1l")
    | "f": o := Eq(n, "fabs")
             OR Eq(n, "fabsf")
             OR Eq(n, "fabsl")
             OR Eq(n, "fdim")
             OR Eq(n, "fdimf")
             OR Eq(n, "fdiml")
             OR Eq(n, "floor")
             OR Eq(n, "floorf")
             OR Eq(n, "floorl")
             OR Eq(n, "fmax")
             OR Eq(n, "fmaxf")
             OR Eq(n, "fmaxl")
             OR Eq(n, "fmin")
             OR Eq(n, "fminf")
             OR Eq(n, "fminl")
             OR Eq(n, "fma")
             OR Eq(n, "fmaf")
             OR Eq(n, "fmal")
             OR Eq(n, "fmod")
             OR Eq(n, "fmodf")
             OR Eq(n, "fmodl")
             OR Eq(n, "fpclassify")
             OR Eq(n, "frexp")
             OR Eq(n, "frexpf")
             OR Eq(n, "frexpl")
    | "h": o := Eq(n, "hypot")
             OR Eq(n, "hypotf")
             OR Eq(n, "hypotl")
    | "i": o := Eq(n, "ilogb")
             OR Eq(n, "ilogbf")
             OR Eq(n, "ilogbl")
             OR Eq(n, "isgreater")
             OR Eq(n, "isgreaterequal")
             OR Eq(n, "isfinite")
             OR Eq(n, "isinf")
             OR Eq(n, "isless")
             OR Eq(n, "islessequal")
             OR Eq(n, "islessgreater")
             OR Eq(n, "isnan")
             OR Eq(n, "isnormal")
    | "l": o := Eq(n, "ldexp")
             OR Eq(n, "ldexpf")
             OR Eq(n, "ldexpl")
             OR Eq(n, "lgamma")
             OR Eq(n, "lgammaf")
             OR Eq(n, "lgammal")
             OR Eq(n, "log")
             OR Eq(n, "logf")
             OR Eq(n, "logl")
             OR Eq(n, "log10")
             OR Eq(n, "log10f")
             OR Eq(n, "log10l")
             OR Eq(n, "log1p")
             OR Eq(n, "log1pf")
             OR Eq(n, "log1pl")
             OR Eq(n, "log2")
             OR Eq(n, "log2f")
             OR Eq(n, "log2l")
             OR Eq(n, "logb")
             OR Eq(n, "logbf")
             OR Eq(n, "logbl")
             OR Eq(n, "lround")
             OR Eq(n, "lroundf")
             OR Eq(n, "lroundl")
             OR Eq(n, "llround")
             OR Eq(n, "llroundf")
             OR Eq(n, "llroundl")
             OR Eq(n, "lrint")
             OR Eq(n, "lrintf")
             OR Eq(n, "lrintl")
             OR Eq(n, "llrint")
             OR Eq(n, "llrintf")
             OR Eq(n, "llrintl")
    | "m": o := Eq(n, "modf")
             OR Eq(n, "modff")
             OR Eq(n, "modfl")
    | "n": o := Eq(n, "nan")
             OR Eq(n, "nanf")
             OR Eq(n, "nanl")
             OR Eq(n, "nearbyint")
             OR Eq(n, "nearbyintf")
             OR Eq(n, "nearbyintl")
             OR Eq(n, "nextafter")
             OR Eq(n, "nextafterf")
             OR Eq(n, "nextafterl")
             OR Eq(n, "nexttoward")
             OR Eq(n, "nexttowardf")
             OR Eq(n, "nexttowardl")
    | "p": o := Eq(n, "pow")
             OR Eq(n, "powf")
             OR Eq(n, "powl")
    | "r": o := Eq(n, "remainder")
             OR Eq(n, "remainderf")
             OR Eq(n, "remainderl")
             OR Eq(n, "remquo")
             OR Eq(n, "remquof")
             OR Eq(n, "remquol")
             OR Eq(n, "rint")
             OR Eq(n, "rintf")
             OR Eq(n, "rintl")
             OR Eq(n, "round")
             OR Eq(n, "roundf")
             OR Eq(n, "roundl")
    | "s": o := Eq(n, "scalbn")
             OR Eq(n, "scalbnf")
             OR Eq(n, "scalbnl")
             OR Eq(n, "scalbln")
             OR Eq(n, "scalblnf")
             OR Eq(n, "scalblnl")
             OR Eq(n, "signbit")
             OR Eq(n, "sin")
             OR Eq(n, "sinf")
             OR Eq(n, "sinl")
             OR Eq(n, "sinh")
             OR Eq(n, "sinhf")
             OR Eq(n, "sinhl")
             OR Eq(n, "sqrt")
             OR Eq(n, "sqrtf")
             OR Eq(n, "sqrtl")
    | "t": o := Eq(n, "tan")
             OR Eq(n, "tanf")
             OR Eq(n, "tanl")
             OR Eq(n, "tanh")
             OR Eq(n, "tanhf")
             OR Eq(n, "tanhl")
             OR Eq(n, "tgamma")
             OR Eq(n, "tgammaf")
             OR Eq(n, "tgammal")
             OR Eq(n, "trunc")
             OR Eq(n, "truncf")
             OR Eq(n, "truncl")
    | "b", "d", "g", "j", "k", "o", "q", "u" .. "z": o := FALSE
    END
    RETURN o
  END IsCMath;

  PROCEDURE IsCMacros*(n: Strings.String): BOOLEAN;
    RETURN Eq(n, "unix") OR Eq(n, "linux") OR Eq(n, "BSD")
  END IsCMacros;

  PROCEDURE IsCppKeyWord*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "a": o := Eq(n, "array")
    | "c": o := Eq(n, "catch")
             OR Eq(n, "class")
    | "d": o := Eq(n, "decltype")
             OR Eq(n, "delegate")
             OR Eq(n, "delete")
             OR Eq(n, "deprecated")
             OR Eq(n, "dllexport")
             OR Eq(n, "dllimport")
             OR Eq(n, "dllexport")
    | "e": o := Eq(n, "event")
             OR Eq(n, "explicit")
             OR Eq(n, "each")
    | "f": o := Eq(n, "finally")
             OR Eq(n, "friend")
    | "g": o := Eq(n, "gcnew")
             OR Eq(n, "generic")
    | "i": o := Eq(n, "in")
             OR Eq(n, "initonly")
             OR Eq(n, "interface")
    | "l": o := Eq(n, "literal")
    | "m": o := Eq(n, "mutable")
    | "n": o := Eq(n, "naked")
             OR Eq(n, "namespace")
             OR Eq(n, "new")
             OR Eq(n, "noinline")
             OR Eq(n, "noreturn")
             OR Eq(n, "nothrow")
             OR Eq(n, "novtable")
             OR Eq(n, "nullptr")
    | "o": o := Eq(n, "operator")
    | "p": o := Eq(n, "private")
             OR Eq(n, "property")
             OR Eq(n, "protected")
             OR Eq(n, "public")
    | "r": o := Eq(n, "ref")
    | "s": o := Eq(n, "safecast")
             OR Eq(n, "sealed")
             OR Eq(n, "selectany")
             OR Eq(n, "super")
    | "t": o := Eq(n, "template")
             OR Eq(n, "this")
             OR Eq(n, "thread")
             OR Eq(n, "throw")
             OR Eq(n, "try")
             OR Eq(n, "typeid")
             OR Eq(n, "typename")
    | "u": o := Eq(n, "uuid")
    | "v": o := Eq(n, "value")
             OR Eq(n, "virtual")
    | "b", "h", "j", "k", "q", "w" .. "z": o := FALSE
    END
    RETURN o
  END IsCppKeyWord;

  PROCEDURE IsJsKeyWord*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "a": o := Eq(n, "abstract")
             OR Eq(n, "arguments")
    | "b": o := Eq(n, "boolean")
             OR Eq(n, "byte")
    | "d": o := Eq(n, "debugger")
    | "e": o := Eq(n, "eval")
             OR Eq(n, "export")
             OR Eq(n, "extends")
    | "f": o := Eq(n, "final")
             OR Eq(n, "function")
    | "i": o := Eq(n, "implements")
             OR Eq(n, "import")
             OR Eq(n, "instanceof")
             OR Eq(n, "interface")
    | "l": o := Eq(n, "let")
    | "n": o := Eq(n, "native")
             OR Eq(n, "null")
    | "p": o := Eq(n, "package")
             OR Eq(n, "private")
             OR Eq(n, "protected")
    | "s": o := Eq(n, "synchronized")
    | "t": o := Eq(n, "throws")
             OR Eq(n, "transient")
    | "v": o := Eq(n, "var")
    | "c", "g", "h", "j", "k", "m", "o", "q", "r", "u", "w" .. "z": o := FALSE
    END
    RETURN o
  END IsJsKeyWord;

  PROCEDURE IsJavaLib*(n: Strings.String): BOOLEAN;
  VAR o: BOOLEAN;
  BEGIN
    CASE n.block.s[n.ofs] OF
      "C": o := Eq(n, "Class")
    | "M": o := Eq(n, "Math")
    | "S": o := Eq(n, "String")
    | "A" .. "B", "D" .. "L", "N" .. "R", "T" .. "Z": o := FALSE
    END
    RETURN o
  END IsJavaLib;

  PROCEDURE O7(n: Strings.String): BOOLEAN;
  RETURN Eq(n, "initialized")
      OR Eq(n, "NULL")
  END O7;

  PROCEDURE IsSpecName*(n: Strings.String; filter: SET): BOOLEAN;
  RETURN O7(n)
      OR ("a" <= n.block.s[n.ofs]) & (n.block.s[n.ofs] <= "z")
      &  (IsCKeyWord(n)
       OR IsCLib(n)
       OR ~(MathC IN filter) & IsCMath(n)
       OR IsCMacros(n)
       OR IsCppKeyWord(n)
       OR IsJsKeyWord(n)
         )
  END IsSpecName;

  PROCEDURE IsSpecModuleName*(n: Strings.String): BOOLEAN;
  (* TODO *)
  RETURN Eq(n, "O7")
      OR Eq(n, "o7")
      OR Eq(n, "math")
      OR Eq(n, "limits")
      OR Eq(n, "ru")
  END IsSpecModuleName;

  PROCEDURE IsO7SpecName*(name: Strings.String): BOOLEAN;
  RETURN Eq(name, "init")
      OR Eq(name, "cnst")
      OR Eq(name, "len")
      OR Eq(name, "proc")
  END IsO7SpecName;

END SpecIdentChecker.
@MKDIR result\v0 result\v1 2>NUL
@SET SRC=CheckIntArithmetic.c Scanner.c Ast.c StringStore.c GeneratorC.c TextGenerator.c TypesLimits.c Translator.c Log.c Message.c V.c Out.c VDataStream.c Parser.c VFileStream.c PlatformExec.c CliParser.c OberonSpecIdent.c SpecIdentChecker.c ModulesStorage.c CCompilerInterface.c ModulesProvider.c FileSystemUtil.c LongSet.c Chars0X.c ArrayCopy.c singularity\CFiles.c singularity\CLI.c singularity\o7.c singularity\OsExec.c singularity\Platform.c singularity\OsEnv.c


@SET CC=tcc
@tcc -version >NUL
@IF %ERRORLEVEL%==0 GOTO FOUND

@SET CC=gcc
@gcc --version >NUL
@IF %ERRORLEVEL%==0 GOTO FOUND

@SET CC=clang
@clang --version >NUL
@IF %ERRORLEVEL%==0 GOTO FOUND

@cl >NUL
@IF %ERRORLEVEL%==0 GOTO FOUND_CL


@ECHO can not found C compiler: tcc, gcc, clang, cl
@EXIT

:FOUND

@ECHO Compiler is %CC%

@CD bootstrap
@%CC% %SRC%  -I . -I singularity -o ..\result\bs-ost.exe
@IF %ERRORLEVEL%==0 GOTO SUCCESS
@CD ..
@EXIT

:FOUND_CL

@ECHO Compiler is cl

@CD bootstrap
:: @cl /TP - Режим C++
@cl %SRC% /I. /Isingularity /Fe:..\result\bs-ost.exe
@IF %ERRORLEVEL%==0 GOTO SUCCESS
@CD ..
@EXIT

:SUCCESS

@CD ..
@ECHO:
@ECHO Bootstrap version of translator was built. Info about next steps:
@ECHO   result\bs-ost run make.Help -infr . -m source

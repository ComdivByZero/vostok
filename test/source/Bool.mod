MODULE Bool;

CONST

TYPE

VAR
	a, b, c: BOOLEAN;

PROCEDURE Fail*;
VAR d: BOOLEAN;
BEGIN
	IF FALSE THEN
		ASSERT(FALSE);
		d := TRUE
	END;
	IF d THEN
		ASSERT(FALSE)
	END
END Fail;

PROCEDURE Go*;
BEGIN
	b := 0 < 1;
	a := b OR c & a;
	ASSERT(a);

	c := a OR FALSE;
	a := b OR c & a;
	ASSERT(a);

	b := ~a;
	ASSERT(~b = a);

	ASSERT(FALSE & FALSE = TRUE & FALSE);
	ASSERT(FALSE & FALSE = FALSE & TRUE);
	ASSERT(TRUE & FALSE = FALSE & TRUE);
	ASSERT(FALSE & TRUE = FALSE & TRUE);

	ASSERT(~FALSE & TRUE);

	ASSERT(TRUE OR FALSE);
	ASSERT(FALSE OR TRUE)
END Go;

END Bool.

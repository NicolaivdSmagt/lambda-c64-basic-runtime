1 REM This is an example handler that can be used in an ALB target group
10 PRINT "{"
20 PRINT "  ";CHR$(34);"statusCode";CHR$(34);": 200,"
30 PRINT "  ";CHR$(34);"statusDescription";CHR$(34);": ";CHR$(34);"200 OK";CHR$(34);","
40 PRINT "  ";CHR$(34);"isBase64Encoded";CHR$(34);": false,"
50 PRINT "  ";CHR$(34);"headers";CHR$(34);": {"
60 PRINT "    ";
70 PRINT CHR$(34);"Content-Type";CHR$(34);": ";CHR$(34);"text";CHR$(47);"html";
80 PRINT CHR$(59);" charset=utf-8";CHR$(34)
90 PRINT "  },"
100 PRINT "  ";CHR$(34);"body";CHR$(34);": "CHR$(34);
140 PRINT "--==** This page is built with Commodore 64 BASIC V2 **==--";CHR$(34)
160 PRINT "}"
RUN

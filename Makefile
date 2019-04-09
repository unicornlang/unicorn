build:
	#cd src && cd parser && yacc -d unicorn.y
	cd src && cd parser && lex tokens.l
	cc src/unicorn.c src/parser/lex.yy.c -o unicorn

grammar Regex;

literal
  : ForwardSlash regex=pattern ForwardSlash 
  ;

pattern
  : '^'? expression '$'?
  ;

expression
  : sequence ( '|' sequence )*
  ;
  
sequence
  : group+
  ;

group
  : PatternNonGroup
  | group0
  ;
  
group0
  : LeftParen groupN RightParen PatternQuantifiers?
  ;
  
groupN
  : expression
  | PatternNonCapturing expression
  | capture=PatternCapturing expression
  ;

ForwardSlash: '/';

LeftParen: '(';

RightParen: ')';

PatternNonGroup
  : PatternCharacterClasses PatternQuantifiers?
  | PatternCharacters
  | PatternFlags
  ;

//fragment
//PatternTerminal
//  : PatternCharacters
//  ;
//
//fragment
//PatternNonTerminal
//  : PatternQuantifiable ( PatternQuantifiers )?
//  | PatternBoundaryMatchers
//  | LeftParen ( PatternNonCapturing )? PatternNonTerminal RightParen
//  ;
//
//fragment
//PatternQuantifiable
//  : PatternCharacterClasses
//  | PatternBackReferences
//  | PatternQuotedText
//  ;
//
//fragment
//PatternQuotedText
//  : '\\Q' 
//    (options {greedy=false;}
//      : .* '\\E'
//    )
//  ;
//
//fragment
//PatternBackReferences
//  : '\\0'
//  | '\\1'
//  | '\\2'
//  | '\\3'
//  | '\\4'
//  | '\\5'
//  | '\\6'
//  | '\\7'
//  | '\\8'
//  | '\\9'
//  ;
//
PatternNonCapturing
  : '?:'
  | '?='
  | '?!'
  | '?<='
  | '?<!'
  | '?>'
  | '?i:'
  | '?d:'
  | '?m:'
  | '?s:'
  | '?u:'
  | '?x:'
  | '?-i:'
  | '?-d:'
  | '?-m:'
  | '?-s:'
  | '?-u:'
  | '?-x:'
  ;

PatternCapturing
    : '?<' Letter (Letter | Digit)* '>'
    ;

fragment
PatternFlags
  : '?i'
  | '?d'
  | '?m'
  | '?s'
  | '?u'
  | '?x'
  | '?-i'
  | '?-d'
  | '?-m'
  | '?-s'
  | '?-u'
  | '?-x'
  ;

fragment
PatternCharacters
  : PatternCharacter+
  ;

fragment
PatternCharacter
  : Letter
  | Digit
  | ':'
  | '-'
  | ' '
  | '\\/'
  | '\\0' Digit ( Digit ( Digit )? )?
  | '\\x' HexDigit HexDigit
  | '\\u' HexDigit HexDigit HexDigit HexDigit
  | '\\t'
  | '\\n'
  | '\\r'
  | '\\f'
  | '\\a'
  | '\\e'
  | '\\c' Letter
  | '\\.'
  | '\\['
  | '\\('
  | '\\|'
  ;

fragment
PatternCharacterClasses
  : ('[' | '[^')  PatternCharacterClass+ ( PatternCharacterClassIntersection )? PatternCharacterClasses? ']'
  | '.'
  | '\\d'
  | '\\D'
  | '\\s'
  | '\\S'
  | '\\w'
  | '\\W'
  | PatternPosixCharacterClass 
  | PatternJavaCharacterClass
  ;

fragment
PatternCharacterClassIntersection
  : '&&'
  ;

fragment
PatternPosixCharacterClass
  : '\\p{Lower}'
  | '\\p{Upper}'
  | '\\p{ASCII}'
  | '\\p{Alpha}'
  | '\\p{Digit}'
  | '\\p{Alnum}'
  | '\\p{Punct}'
  | '\\p{Graph}'
  | '\\p{Print}'
  | '\\p{Blank}'
  | '\\p{Cntrl}'
  | '\\p{XDigit}'
  | '\\p{Space}'
  ;

fragment
PatternJavaCharacterClass
  : '\\p{javaLowerCase}'
  | '\\p{javaUpperCase}'
  | '\\p{javaWhitespace}'
  | '\\p{javaMirrored}'
  ;

fragment
PatternUnicodCharacterClass
  : '\\p{InBasicLatin}'
  // TODO: more unicode block names
  | '\\p{InGreek}'
  | '\\p{C}'
  | '\\p{Cc}'
  | '\\p{Cf}'
  | '\\p{Cn}'
  | '\\p{Co}'
  | '\\p{Cs}'
  | '\\p{L}'
  | '\\p{LC}'
  | '\\p{Ll}'
  | '\\p{Lm}'
  | '\\p{Lo}'
  | '\\p{Lt}'
  | '\\p{Lu}'
  | '\\p{M}'
  | '\\p{Mc}'
  | '\\p{Me}'
  | '\\p{Mn}'
  | '\\p{N}'
  | '\\p{Nd}'
  | '\\p{Nl}'
  | '\\p{No}'
  | '\\p{P}'
  | '\\p{Pd}'
  | '\\p{Pe}'
  | '\\p{Pf}'
  | '\\p{Pi}'
  | '\\p{Po}'
  | '\\p{Ps}'
  | '\\p{S}'
  | '\\p{Sc}'
  | '\\p{Sk}'
  | '\\p{Sm}'
  | '\\p{So}'
  | '\\p{Z}'
  | '\\p{Zl}'
  | '\\p{Zp}'
  | '\\p{Zs}'
  ;

fragment
PatternCharacterClass
  : Letter ( '-' Letter | Letter* )
  ;

//fragment
//PatternBoundaryMatchers
//  : '^'
//  | '$'
//  | '\\b'
//  | '\\B'
//  | '\\A'
//  | '\\G'
//  | '\\Z'
//  | '\\z'
//  ;
//

PatternQuantifiers
  : '?'
  | '??'
  | '?+'
  | '*'
  | '*?'
  | '*+'
  | '+'
  | '+?'
  | '++'
  | '{' Digit+ ( ',' Digit* )? ( '}' | '}?' | '}+' )
  ;

fragment     
Letter
    : '\u0041'..'\u005a'
    | '\u005f'
    | '\u0061'..'\u007a'
    | '\u00d8'..'\u00f6'
    ;

fragment
Digit: '0'..'9';

fragment
HexDigit: Digit | 'a'..'f' | 'A'..'F';
  
fragment
CR: '\r';

fragment
LF: '\n';

fragment
FF: '\u000C';

fragment
TAB: '\t';

WS: (' ' | CR | LF | TAB | FF)+ -> skip;


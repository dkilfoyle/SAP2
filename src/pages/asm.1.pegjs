{
  function filledArray(count, value) {
    return Array.apply(null, new Array(count))
      .map(function() { return value; });
  }

  function extractOptional(optional, index) {
    return optional ? optional[index] : null;
  }

  function extractList(list, index) {
    return list.map(function(element) { return element[index]; });
  }

  function buildList(head, tail, index) {
    return [head].concat(extractList(tail, index));
  }

  function optionalList(value) {
    return value !== null ? value : [];
  }
}

start = 
  __ program:Program __ { return program }
  
Program =
  body:SourceElements? { return {type: "program", body: optionalList(body) } }
  
SourceElements = 
  head:SectionText tail:(SectionData)? { return { text: head, data: tail} }

SectionText = 
  __ "section .text" __ instructions:(instruction0 / instruction1 / instruction2)* { return optionalList(instructions) }
    
SectionData =
  __ "section .data" __ instructions:(datainstruction)* { return optionalList(instructions) }

SourceElement =
  instruction / 
  label
  
Comment = 
  ";" (!EOL .)* 
  
label = 
  id:identifier ":" __ {return {type:"label", name: id.name, line: location().start.line } }
  
identifier = 
  !opcode !reserved head:[.a-zA-Z] tail:[a-zA-Z0-9]+ { return {type: "identifier", name: head + tail.join("") }; }

instruction0 = 
  _ oc:opcode EOLC { return {type: "instruction", opcode: oc.toUpperCase(), arglist: [], line: location().start.line }}

instruction1 = 
  _ oc:opcode _ arg1:argument EOLC { return {type: "instruction", opcode: oc.toUpperCase(), arglist: [arg1], line: location().start.line }}

instruction2 = 
  _ oc:opcode _ arg1:argument __ "," __ arg2:argument EOLC { return {type: "instruction", opcode: oc.toUpperCase(), arglist: [arg1, arg2], line: location().start.line }}

instruction = 
  _ oc:opcode _ al:argumentlist { return {type: "instruction", opcode: oc.toUpperCase(), arglist: al, line: location().start.line }}

datainstruction "datainstruction" = 
  _ oc:dataopcode _ arg:argument { return {type: "instruction", opcode: oc.toUpperCase(), arg: arg, line: location().start.line }}

opcode "opcode" =
  "LDA"i / "ADD"i / "SUB"i / "HLT"i / "OUT"i / "NOP"i

reserved =
  "section" / ".text" / ".data"

dataopcode =
  "DB"i / "DW"i
  
argumentlist = 
  head:argument? EOL /
  head:argument tail:(__ ',' __ a:argument {return a})* EOL { return [head].concat(tail) }
  
argument "argument" = 
  hex /
  number /
  identifier / 
  string /
  '[' r:register ']' { r.type = "address"; return r }

string =
  '"' str:stringcharacter* '"' { return {type: "string", value: str.join("") } }
  
stringcharacter
  = !('"' / "\\" / EOL) . { return text() }
    
register = 
  c:registerName {return {type: "register", value: text()} }
  
registerName = 
  "A" / "B" / "C" / "D" 

hex =
  "0x" n:[0-9a-fA-F]+ { console.log(n); return {type: "number", value: parseInt("0x"+n.join(""))} }

number =
  n:[0-9]+ { return {type: "number", value: parseInt(n.join(""))} }
  
EOL "EOL" = 
  '\r'? '\n' 

EOLC = _ Comment? EOL

WhiteSpace "WS" =
  [ \t\n\r]
  
__ = 
  (WhiteSpace / EOL / Comment)*
  
_ =
  WhiteSpace*
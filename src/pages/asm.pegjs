{
    var sectionState = "";
    var hasText = false;
    var validOps = { text: ["lda","add","sub","hlt","nop","out"], data: ["db"] };
    var validNumArgs = { "0": ["hlt","nop","out"], "1": ["lda","add","sub", "db"] };
    function checkInstruction(i) {
        if (sectionState === "") error("Missing section");
        if (!validOps[sectionState].includes(i.op)) error("Invalid op for this section"); 
        if (!validNumArgs[i.args.length].includes(i.op)) error("Invalid number of args"); 
    }
}

start = 
    first:line rest:(nl l:line {return l})* { if (!hasText) error("Missing section .text"); return [first].concat(rest) }

line =
    _ i:instruction eol { checkInstruction(i); return i } /
    _ s:section eol { return s } /
    _ l:label eol { return l } /
    _ eol { return {type:"skip"} }

instruction =
    i:opcode _ n:number* eol { return { type: "op", op: i.toLowerCase(), args: n } }
    // i:instruction0arg { return { type: "op", op: i.toLowerCase() } }

opcode "opcode" = "LDA"i / "ADD"i / "SUB"i / "DB"i / "HLT"i / "OUT"i / "NOP"i

instruction1arg = 
    "LDA"i / "ADD"i / "SUB"i / "DB"i

instruction0arg = 
    "HLT"i / "OUT"i / "NOP"i

section "section" = 
    "section .text" { sectionState = "text"; hasText = true; return { type: "section", section: "text" } } /
    "section .data" { sectionState = "data"; return { type: "section", section: "data" } }

label "label" = 
    l:labelname ":" { return { type: "label", label: l } }

labelname = n:[._a-zA-Z0-9]+ { return n.join("") }

// Fragments

sep = _ "," _
eol = _ comment?
comment = ";" [^\r\n]*

// Numbers
number "number" = binLiteral / hexLiteral / decLiteral

decLiteral "decimal literal" =
    digits:[0-9]+ { return parseInt(digits.join(""), 10); }

hexLiteral "hex literal" =
    '0x' hexits:[0-9a-fA-F]+ { return parseInt(hexits.join(""), 16); }

binLiteral "binary literal" =
    '0b' bits:[0-1]+ { return parseInt(bits.join(""), 2); }

// Whitespace
__  = ws+
_   = ws*
ws "WS" = [ \t]
nl "NL" = ("\r"? "\n") 
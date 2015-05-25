P206 := Object clone do (
     Regex
     isMatching := method( n, n asString matchesRegex("1.2.3.4.5.6.7.8.9") )
     constructSq := method(n,
        x := "123456789" asMutable
        ds := n asString(8,0) replaceSeq(" ","0")
        for(i,0,7,
            x = x atInsertSeq(1+i*2,ds at(i) asCharacter)
        )
        BigNum with(x asSymbol)
     )
     findNum := method(b,
         // the pattern ends in 0, so it's a multiple of 10, so n must be too
         // b := BigNum with("10203040506070809")
         n := b sqrt
         //                     "10203040506070809"
         mx := (b + BigNum with("00000000100000000"))
         while( true,
                sq := n pow(2)
                if(sq > mx, return (n * -1) )
                if(isMatching(sq),return n)
                n = n + 1
         )
         -1
     )
     //constructSq(17070707) print
     for(i,0,99999,
        st := constructSq(i*10000)
        v := findNum(st)
        if( v > 0, (v*10) print; "\n" print; break )
     )
)
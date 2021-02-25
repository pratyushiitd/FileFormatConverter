(* A function to convert a file which uses a 
character delimiter delim1 and convert it to another file
which uses a character delimiter delim2.
*)
exception UnevenFieldException of string;
exception EmptyInputFile;
fun convertDelimiters(infilename: string, delim1: char, outfilename: string, delim2: char) = 
let
	val instream = TextIO.openIn infilename
	val outstream = TextIO.openOut outfilename
    (*
        in_delim = true denotes the current field has delimiter 2.
        st_temp stores the current field in the form of string.
        len_st = 1 only if file has non zero characters, for raising emptyfileException
        num_field denotes the line we are currently on, used for denoting line number in UnevenFieldException
        count_dq denotes the number of double quotes in the current field
        tot represents the number of delimiters in the first line, used in UnevenFieldException
        curr represents the the number of delimiters in the current line, used in UnevenFieldException
    *)
	fun replace_delim(c: char option, in_delim: bool, st_temp: string, len_st: int, num_fields: int, count_dq: int, tot: int, curr: int) =  
		case c of
			NONE => (
                if (len_st = 0) then (
                    TextIO.closeIn instream;
                    TextIO.closeOut outstream;
                    raise EmptyInputFile
                )
                else if (in_delim = true) then (
                    if (count_dq > 0) then (
                        TextIO.output(outstream, st_temp);
                        TextIO.closeIn instream;
                        TextIO.closeOut outstream
                    )
                    else ( (*current field has delimiter 2 and field has no double quotes, so apppend double quotes on both sides.*)
                        TextIO.output1(outstream, #"\"");
                        TextIO.output(outstream, substring(st_temp, 0, String.size(st_temp)-1));
                        TextIO.output1(outstream, #"\"");
                        TextIO.output(outstream, substring(st_temp, String.size(st_temp)-1,1));
                        TextIO.closeIn instream;
                        TextIO.closeOut outstream
                    )
                )else (
                    if (count_dq > 0) then (
                        TextIO.output(outstream, st_temp);
                        TextIO.closeIn instream;
                        TextIO.closeOut outstream
                    )
                    else (
                        TextIO.output(outstream, st_temp);
                        TextIO.closeIn instream;
                        TextIO.closeOut outstream
                    )
                )
            )
            (*
            count_dq mod 2 = 0 denotes that the double quotes read in the current field till now is evem
            *)
			|SOME(c) => if ( c = #"\n" andalso count_dq mod 2 = 0) then (*char read is newline token present outside a field*)
                            (   if (num_fields = 0) then replace_delim(TextIO.input1 instream, in_delim, st_temp ^ str(c), 1, num_fields+1, count_dq, curr, 0)
                                else (
                                    if (tot <> curr) then raise UnevenFieldException ("Expected: "^Int.toString(tot+1)^" fields, Present: "^Int.toString(curr+1)^" fields on Line "^Int.toString(num_fields+1)^"\n")
                                    else replace_delim(TextIO.input1 instream, in_delim, st_temp ^ str(c), 1, num_fields+1, count_dq, tot, 0)
                                )
                            )
                        else if ( c = #"\"") then replace_delim(TextIO.input1 instream, in_delim, st_temp ^ str(c), 1, num_fields, count_dq+1, tot, curr)
                        else if (count_dq mod 2 = 1 andalso c = delim2) then replace_delim(TextIO.input1 instream, true, st_temp ^ str(c), 1, num_fields, count_dq, tot, curr)
                        else if (count_dq mod 2 =1) then replace_delim(TextIO.input1 instream, in_delim, st_temp ^ str(c), 1, num_fields, count_dq, tot, curr)
                        else if (count_dq mod 2 = 0 andalso (c = delim1 andalso in_delim=true)) then 
                            (
                                if (count_dq > 0) then (
                                    TextIO.output(outstream, st_temp);
                                    TextIO.output1(outstream, delim2);
                                    replace_delim(TextIO.input1 instream, false, "", 1, num_fields, 0, tot, curr+1)
                                )
                                else (
                                    TextIO.output1(outstream, #"\"");
                                    TextIO.output(outstream, st_temp);
                                    TextIO.output1(outstream, #"\"");
                                    TextIO.output1(outstream, delim2);
                                    replace_delim(TextIO.input1 instream, false, "", 1, num_fields, 0, tot, curr+1)
                                )
                            )
                        else if (count_dq mod 2 = 0 andalso (c = delim1 andalso in_delim=false)) then 
                            (
                                    TextIO.output(outstream, st_temp);
                                    TextIO.output1(outstream, delim2);
                                    replace_delim(TextIO.input1 instream, false, "", 1, num_fields, 0, tot, curr+1)
                            )
                        else 
                            (
                                if (c = delim2) then replace_delim(TextIO.input1 instream, true, st_temp ^ str(c), 1, num_fields, count_dq, tot, curr)
                                else replace_delim(TextIO.input1 instream, in_delim, st_temp ^ str(c), 1, num_fields, count_dq, tot, curr)
                            )

in
	replace_delim(TextIO.input1 instream, false, "", 0, 0, 0, 0, 0)
end
handle UnevenFieldException abc => print abc

fun csv2tsv (infilename: string, outfilename: string) = 
let
	val delim1 = #","
	val delim2 = #"\t"
in
	convertDelimiters(infilename, delim1, outfilename, delim2)
end

fun tsv2csv (infilename: string, outfilename: string) = 
let
	val delim1 = #"\t"
	val delim2 = #","
in
	convertDelimiters(infilename, delim1, outfilename, delim2)
end
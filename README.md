# FileFormatConverter
SML Program to convert a file from one Delimiter seperated format to other delimiter seperated format
CSV format has been specified in IETF’s RFC4180. We shall mostly
follow the RFC4180 conventions.

# Compile and Run
Compile the program using command $ sml csv2dsv.sml

# Converting file from c-seperated format to d-seperated format
use the command convertDelimiters(infilename, delim1, outfilename, delim2)

infilename: string contain input file name in double quotes. eg. "test.csv"
delim1: delimiter in infilename
outfilename: string contain output file name in double quotes. eg. "test_out.ssv"
delim2: delimiter required in outfilename

# Converting from csv to tsv and tsv to csv
To convert between csv and tsv file format, use the command 
csv2tsv(infile, outfile) or tsv2csv(infile, outfile) directly, no need to specify the delimiters.

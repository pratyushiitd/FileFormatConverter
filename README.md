# FileFormatConverter
SML Program to convert a file from one Delimiter seperated format to other delimiter seperated format\n
CSV format has been specified in IETF’s RFC4180. We shall mostly\n
follow the RFC4180 conventions.

# Compile and Run
Compile the program using command $ sml csv2dsv.sml\n

# Converting file from c-seperated format to d-seperated format
use the command convertDelimiters(infilename, delim1, outfilename, delim2)\n

infilename: string contain input file name in double quotes. eg. "test.csv"\n
delim1: delimiter in infilename\n
outfilename: string contain output file name in double quotes. eg. "test_out.ssv"\n
delim2: delimiter required in outfilename\n

# Converting from csv to tsv and tsv to csv
To convert between csv and tsv file format, use the command \n
csv2tsv(infile, outfile) or tsv2csv(infile, outfile) directly, no need to specify the delimiters.

#!/usr/bin/perl -w
use strict;

#Ryan Towner z1774451
#Program 2 - Scanning and Processing Input Files
#07/18/19

&openFiles; #Starts the program

#Function to check if the two arguments were given. If not it will display an error and end program.
sub checkArgs {
    if (@ARGV != 2) {
        printf STDERR "Incorrect number of arguments. Ex: prog2 inputfile outputfile\n";
        die;
    } else {
        print "Input File: $ARGV[0]\nOutput File: $ARGV[1]\n"; #prints filenmes in terminal not outputfile
    }
    return ($ARGV[0], $ARGV[1]); #return file names
}

#Function to open the files create the list and hash then close the files.
sub openFiles {
    (my $input_name, my $output_name) = &checkArgs; #check if correct arguments before opening. program will abort if error then gets file names from cmd line args

    open my $out, '>', $output_name
        or die "Error opening output file."; #open output file for writing or about and report error

    open my $in, '<', $input_name #file name from cmd line arg
        or die "Error opening input file."; #open input file for reading or about and report error

    chomp(my @lines = <$in>); #chomp incoming data
    my @data = @lines; #put data in an array

    my @list = &createList(@data); #create a list from the data
    my %hash = &createHash(@list); #create a hash from the list

    &printHash(\%hash, $out); #print out the hash data
    &closeFiles($in, $out); #close the files
}

#Function will close the files or report errors closing files before program is exited
sub closeFiles {
    my $input_file = $_[0]; #Get input file handle
    my $output_file = $_[1]; #Get output file handle

    close $input_file or die "Error closing input file."; #Close input file or about and report error
    close $output_file or die "Error closing output file."; #Close output file or about and report error
}

#Function will split the input and create a list with each individual item
#Takes @data as input and returns a seperated list
sub createList {
    my @list_data = @_; #create a copy of data to work with
    my @split_list;
    foreach my $list_item (@list_data) { #Takes each line from array and splits the words then adds each word to a list
        my @word = split(/\W+/, $list_item, -1);
        push (@split_list, @word);
    }
    return @split_list; #return the list
}

#Function will use the list to create a hash from the input data
#takes @list as input and returns a hash
sub createHash {
    my %freq_hash;
    my @word_list = @_;

    foreach my $word (@word_list) { #loop through the word list
        $freq_hash{$word}++; #build hash by frequency of the word
    }

    return %freq_hash; #return the hash
}

#Function will print the size of the hash and the hash itself
#Takes %hash as input
sub printHash {
    my %hash = %{$_[0]}; #gets hash data
    my $count = 0;
    my $size = keys %hash; # gets size of the hash
    my $output_file = $_[1]; #get output file handle for printing

    print $output_file "size = $size\n"; # prints size of hash

    foreach my $word (sort keys %hash) {
        if ($count % 4 == 0) {
            print $output_file "\n"; #print a new line ever 4 so there is 3 words per line to file
        } else {
            printf $output_file "%-15s :  %s   ", $word, $hash{$word}; #print key then 15 spaces and then : value to file
        }
        $count++;
    }
}
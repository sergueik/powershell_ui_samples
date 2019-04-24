#! perl
require 5.004;
die "Unsupported OS ($^O), sorry.\n" if $^O ne "MSWin32" and $^O ne 'linux' ;

use strict;

use vars qw(
    $msg $in
    @logfiles $doc
 $SELF $DEBUG 
);


use Data::Dumper; $Data::Dumper::Sortkeys = 1;
use POSIX;
use File::Find;
use File::Basename;
use File::Spec;
use Compress::Zlib;
use Getopt::Long;
use Cwd;
use DBI;
use DBD::SQLite;
use Time::localtime;


BEGIN {

    my $SCRIPT_HOME_DIR = dirname( $0 ) ;
    my $SCRIPT =  $ENV{SELF} || $0; # Script name string
    $SELF   =  basename($SCRIPT);    
    $DEBUG = 0;
    use constant DEVELOPER     => 'skouzmine';
    use constant EMAIL        => 'DL-ISWebOperations@carnival.com';
  
   
    unshift( @INC, "/always_include_production_lib_path" );

    if ( $DEBUG ) {
        unshift( @INC, "/home/" . ( DEVELOPER  ) . "/some_developer_override_lib_path" );
    }
    # warning: git, Ruby, Chef, Puppet all come with Perl
    # Make sure that some random Perl does not exist in the PATH already 
    # c:\Program Files\Git\bin\perl.exe
}




our $FILES     = {};
our $APP       = 'Carnival';
our $MAX_FILES = 100; 
our $MAX_LINES = 100000000;
our $SKIP = 0;
our $WHATIF = 0;
our $FILE_ROOT     = 'c:\\logs';
our $LAST = 0 ;
our $TARGET = '.';
our $FLAT = 0 ;
our $FULL = 0; 
our $USE_FIND  = 0; 
our $SHOW_HEADER  = 0; 
our $dbh;
$FILE_ROOT     = "\\\\vnx5700cifs\\akamai_logs\\carnival";
our $LOG_ROOT     = "\\\\vnx5700cifs\\akamai_logs\\splunk";
our $SQLITE_FILENAME = 'test.sqlite';
our $INIT_DB = 1; 
our $MAX_SIZE = undef;
our $ESCAPE_SPECIAL_CHARS = 0;
our $LOG_DEST     = "D:\\akamai_logs\\Carnival";
our $STATUS_CODES =  "5\d\d,400,301,302";
$in = {   } ;

&usage if !@ARGV or grep { /\?/ } @ARGV;

my $GETOPT_OK = GetOptions(
    "help"      => \&usage,
    "h"         => \&usage,
    "APP=s"     => \$APP ,  # alternative mail subject line.
    "maxfiles=n"     => \$MAX_FILES ,  # alternative mail subject line.
    "root=s"     => \$FILE_ROOT,
    "dest=s"     => \$LOG_DEST,

    "last=n" => \$LAST,    # in seconds 
    "skip=n" => \$SKIP,
    "whatif" => \$WHATIF,
    "flat"         => \$FLAT, 
    "full" =>  \$FULL,
    "target=s" => \$TARGET,
    "header" => \$SHOW_HEADER,
    "sqlite=s" => \$SQLITE_FILENAME,
    "status_codes=s" => \$STATUS_CODES,
    "escape" => \$ESCAPE_SPECIAL_CHARS,
    "init_db" => \$INIT_DB,  
    "debug"         => \$DEBUG, 
    "d"         => \$DEBUG 

);



our $TODAY_UNIX_SECONDS_EPOC = time();

our $STARTING_UNIX_SECONDS_EPOC = $TODAY_UNIX_SECONDS_EPOC - $LAST;   # one day before of current date.

my @tm  = localtime($STARTING_UNIX_SECONDS_EPOC) ;
my ($TODAY_SEC,$TODAY_MIN,$TODAY_HOUR,$TODAY_MDAY,$TODAY_MON,$TODAY_YEAR,$TODAY_WDAY,$TODAY_YDAY,$TODAY_ISDST) = @{$tm[0]} ;
    # why not just @tm ; ? 


database_init(\$dbh, $SQLITE_FILENAME , $INIT_DB ) ; # eval

# Sample DEBUG  code is moded to the DATA section 

my @tm  = localtime();
my ($TODAY_SEC,$TODAY_MIN,$TODAY_HOUR,$TODAY_MDAY,$TODAY_MON,$TODAY_YEAR,$TODAY_WDAY,$TODAY_YDAY,$TODAY_ISDST) = @{$tm[0]} ;
print "DEBUG=$DEBUG\n";
print "APP=$APP\n";
print "MAX_FILES=$MAX_FILES\n";
print "FILE_ROOT=$FILE_ROOT\n";
print "DEBUG=$DEBUG\n";
filter_files ( $in )  ;
print_summary();

print "Done.\n";

exit 0 ;

###########

sub gather_stat {

    my $F = $_;

    # filename filters could be placed here
    # the next clause allows picking random  $MAX_FILES
    # return if scalar (keys %$FILES) > $MAX_FILES + $SKIP;

    return 0 if $F =~ /^\./;

    return 0 unless $F =~ /^${APP}_\d+.*.gz$/i ;

    my $fullpath = $File::Find::name;
    my @stat     = stat($fullpath);

    $fullpath =~ s|/|\\|g;
    my  $filtered = $F;
 if ( $FLAT )  {
 $filtered  =~ s/\.gz/.filtered.log/ 
} else {   $filtered  =~ s/\.gz/.filtered.log.gz/;
 }
    print $F, "\n" if $DEBUG;


    $FILES->{$F}->{AGE}      = $stat[9];

    return 0 if ( $LAST > 0 )  && ( $FILES->{$F}->{AGE} < $STARTING_UNIX_SECONDS_EPOC) ;
    my @tm  = localtime($FILES->{$F}->{AGE} );
    my ($FILE_SEC,$FILE_MIN,$FILE_HOUR,$FILE_MDAY,$FILE_MON,$FILE_YEAR,$FILE_WDAY,$FILE_YDAY,$FILE_ISDST) = @{$tm[0]} ;


    return 0 unless $TODAY_YEAR == $FILE_YEAR  &&  $TODAY_MON == $FILE_MON && $TODAY_MDAY == $FILE_MDAY ;
    print "Found $F\n";

    $FILES->{$F}->{SIZE}     = $stat[7];
    $FILES->{$F}->{FULLPATH} = $fullpath;
    $FILES->{$F}->{RESULT}   = $filtered ;
    $FILES->{$F}->{FILENAME} = $F;

if ($DEBUG ){
 print "Now:\n";
 print Dumper \[$TODAY_MDAY,$TODAY_MON,$TODAY_YEAR,$TODAY_HOUR,$TODAY_MIN] ;
 
 print "File:\n";
 print Dumper \[$FILE_MDAY,$FILE_MON,$FILE_YEAR,$FILE_HOUR,$FILE_MIN] ;
}
    
#    print STDERR Dumper \($FILES->{$F}) if $DEBUG;
    return 1;
}

sub filter_files ( $ ) {

    my ($in) = @_;
    local $FILES = {};
    # local $ENV{PATH} = $FILE_ROOT;
    unless ($USE_FIND) {
       read_file_dir({BASEPATH=>$FILE_ROOT}) ;
    } else {
       find( { wanted => \&gather_stat, follow => 0 }, $FILE_ROOT );
    }
    my $size_tot = 0;
    my $file;
    my ( $keep_one, $kept_one ) =
      ( 1, undef );    # if no file qualifies ONBOARD, keep the best one.

    # reverse date order
    my @FILEINDEX =
      sort { $FILES->{$b}->{AGE} <=> $FILES->{$a}->{AGE} }
      keys(%$FILES);
    if ($SKIP > 0) {
       splice(@FILEINDEX,0, $SKIP ) ; 
    }
    splice(@FILEINDEX, $MAX_FILES ) ; 

    # erase all files which are not ONBOARD except one
    foreach $file (@FILEINDEX) {
       if ($FULL){
         if ($FILES->{$file}->{FULLPATH} =~ /\S/) {
            my $COMMAND_TEMPLATE =   'c:\\tools\\gzip.exe -vdcf "$SOURCE" > "$TARGET"';
            my $command =  $COMMAND_TEMPLATE ;
            $FILES->{$file}->{RESULT} =~ s/filtered/full/;
            $command =~ s/\$SOURCE/$FILES->{$file}->{FULLPATH}/go;
            my $target = "D:\\AKAMAI_LOGS\\carnival\\$FILES->{$file}->{RESULT}" ;
            $target = "$LOG_DEST\\$FILES->{$file}->{RESULT}" ;
            if  (-e $target ) {
              print STDERR "File already exists: \"$target\"\n";
            } else {
              $command =~ s/\$TARGET/$target/go;
              print STDERR $command, "\n";
              open CMD_FILE , ">> process.cmd";
              print CMD_FILE $command, "\n";
              close CMD_FILE;
              # eval ? do system()  call  return a reliable exit code ? 
              system($command) ;
              if  (!-e $target ) {
                print STDERR "Failure extracting  the file : \"$target\" Ignored\n";
                # TODO - parameter
                # die ;
               }
             }
           }
         } else {
           &truncate_file( $FILES->{$file} );
       }

    }

}


sub truncate_file ( $ ) {
    my $in       = shift;
    my @filtered = ();
    my $maxcnt   = $MAX_LINES;
    my $cnt      = 0;
    my $file     =  $in->{FULLPATH} ;

    my $total_rows  = 0; 
    my $selected_rows  = 0; 
    return unless $file;
    print STDERR "filtering the  file \"$file\"\n";
    my @header_rows = ();

    eval {
    insert(
        {
            APPLICATION     => $APP,
            FILENAME        => $in->{FULLPATH},
            RESULT => $in->{RESULT},
            AGE => $in->{AGE},
            TOTAL_ROWS      => $total_rows ,
            SELECTED_ROWS   => $selected_rows
        }
    )
    };
    if ($@) {
        print "Warning: $@\n";
    }

    my $gz = gzopen( $file, "rb" )
      or die "Cannot open $file: $gzerrno\n";


# my $status_codes_array = ['400','301','302', '5\d\d' ];
#
# my @arg = (split  (/,/, $STATUS_CODES )) ;
#
# $status_codes_array = \@arg;

my $status_codes_array =  [] ;
push @$status_codes_array ,   split  (/,/, $STATUS_CODES )  ;

my $keep_special_characters = !$ESCAPE_SPECIAL_CHARS ; 
my $status_codes_expression = join '|',  ( $keep_special_characters ?  @$status_codes_array : map { quotemeta} @$status_codes_array ); 
print STDERR "\$status_codes_expression = $status_codes_expression\n";

my $check_expression  = qr/($status_codes_expression)/;

    while ( $gz->gzreadline($_) > 0 && $cnt <= $maxcnt ) {
        $total_rows ++;
        my $line = $_;
        chomp $line;
        push @header_rows ,  $line if $total_rows < 3;   
        my @fields = split /\t+/, $line;
        my $req = {};
        $req->{response} = @fields[5];

### my $LOG_REGEX = qr{          (\d{4,4}\-\d{2,2}\-\d{2,2})      # date
###                              \s+
###                             (?:.*)? # optional ....
###                             $
###                             }ix;
### ( $req->{date}, $req->{time}, ...,     $req->{etc}   ) = ( $line =~ m/$LOG_REGEX/ );

### next if( $req->{response} =~ /(?:200|304|301|302|404|000|206)/ );
        next unless $req->{response} =~ m/(?:$check_expression)/go;
    
    # (?=$...
    # Do a regexp magic about current position in a search string 
    # See perldoc PERLRE for details of how this works 

        print STDERR Dumper join( "\t", @fields[ 3 .. 5 ] ) if $DEBUG;
        $cnt++;        
        push @filtered, $line;
        # push @filtered, $req->{response} if $DEBUG;

    }

## restore after lifting the $MAX_LINES
## die "Error reading from $file: $gzerrno\n" if $gzerrno != Z_STREAM_END ;

    $gz->gzclose();
# if ($#filtered == -1) {
#
#   return 
#  }
# 

  # Clear header rows
  $#header_rows = -1 unless $SHOW_HEADER; 
 print "Writing  "  .  join( "\\", $TARGET , $in->{RESULT}) . "\n";
    open FOUT, ">" . join( "\\", $TARGET , $in->{RESULT}) ;

    if ($FLAT) {
        foreach my $line (@header_rows, @filtered) {
            $selected_rows ++;
            print FOUT $line, $/
              or die "Error writing: $!\n";
        }

    }
    else {
        my $gz = gzopen( \*FOUT, "wb" )
          or die "Cannot open stdout: $gzerrno\n";

        foreach my $line (@header_rows, @filtered) {

            $gz->gzwrite($line)
              or die "Error writing: $gzerrno\n";
        }
        $gz->gzclose;
    }
print "1\n";
fetch_arrays( $in->{FULLPATH});
update_rows($in->{FULLPATH}, $total_rows, $selected_rows );
print "2\n";
fetch_arrays($in->{FULLPATH});

    1;
}


sub read_file_dir($) {
my $in = shift;
print  STDERR Dumper $in;
opendir DD, $in->{BASEPATH} or die $! ;
print "Looking for ${APP}\n" if $DEBUG ;

while ( my $F = readdir (DD)) {

    next if $F =~ /^\./;

    next unless $F =~ /^${APP}_\d+.*.gz$/i ;
#    next unless $F =~  /carnival_46625.esw3c_waf_S.201408291400-1500-/; # debugging
    my $fullpath = join( "\\", ($in->{BASEPATH}, $F ))    ;
    #  uncomment to show the io slowness 
   
#    print $fullpath, "\n" if $DEBUG;
    my @stat     = stat($fullpath);
    $fullpath =~ s|/|\\|g;
    my  $filtered = $F;
 if ( $FLAT )  {
 $filtered  =~ s/\.gz/.filtered.log/ 
} else {   $filtered  =~ s/\.gz/.filtered.log.gz/;
 }



    $FILES->{$F}->{AGE}      = $stat[9];

###  need to compensate for time zone
### adjustments
### 08/29/2014  01:30 PM        15,976,842 carnival_46625.esw3c_waf_S.201408291400-1500-2.gz
###
### DEBUG 
  next if ( $LAST > 0 )  && ( $FILES->{$F}->{AGE} < $STARTING_UNIX_SECONDS_EPOC) ;

if ($DEBUG){
print $FILES->{$F}->{AGE}, "\n" ;
print $STARTING_UNIX_SECONDS_EPOC, "\n";
print ($STARTING_UNIX_SECONDS_EPOC - $FILES->{$F}->{AGE}) /  3600 , "\n" ;

}
    print $F, "\n" if $DEBUG;

    my @tm  = localtime($FILES->{$F}->{AGE} );
    my ($FILE_SEC,$FILE_MIN,$FILE_HOUR,$FILE_MDAY,$FILE_MON,$FILE_YEAR,$FILE_WDAY,$FILE_YDAY,$FILE_ISDST) = @{$tm[0]} ;

### DEBUG 
    next unless $TODAY_YEAR == $FILE_YEAR  &&  $TODAY_MON == $FILE_MON && $TODAY_MDAY == $FILE_MDAY ;
    print "Found $F\n";

    $FILES->{$F}->{SIZE}     = $stat[7];
    $FILES->{$F}->{FULLPATH} = $fullpath;
    $FILES->{$F}->{RESULT}   = $filtered ;
    $FILES->{$F}->{FILENAME} = $F;

if ($DEBUG ){
 print "Now:\n";
 print Dumper \[$TODAY_MDAY,$TODAY_MON,$TODAY_YEAR,$TODAY_HOUR,$TODAY_MIN] ;
 
 print "File:\n";
 print Dumper \[$FILE_MDAY,$FILE_MON,$FILE_YEAR,$FILE_HOUR,$FILE_MIN] ;
}
    
#    print STDERR Dumper \($FILES->{$F}) if $DEBUG;

}

closedir(DD) ; 

    return 1;

}


sub database_init ($$$) {
    my ($dbh_ref, $db_file, $init_database  ) = @_; 
    my $driver   = "SQLite";
    my $database = "logs.db";
    my $dsn      = "DBI:$driver:dbname=$database";
    my $userid   = "";
    my $password = "";
    $$dbh_ref = DBI->connect( $dsn, $userid, $password, { RaiseError => 1 } )
      or die $DBI::errstr;

    print "Opened database successfully\n";

    # http://www.sqlite.org/datatype3.html
 
    my $stmt = qq/ 
   CREATE TABLE LOGS
      (FILENAME CHAR(256) PRIMARY KEY     NOT NULL,
         APPLICATION      CHAR(256),
         AGE            INT     NOT NULL,
         RESULT   CHAR(256),
         TOTAL_ROWS         REAL, 
         SELECTED_ROWS         REAL 
      );
      /;

    my $rv = undef;
if ($init_database) {
   eval { $rv =  $$dbh_ref->do($stmt) } ;
 
    if ( $rv < 0 ) {
        print $DBI::errstr;
    }
    else {
        print "Table created successfully\n";
    }
}
}

sub disconnect() {

    $dbh->disconnect();
}

sub insert($) {
    my $FILE = shift;
    print Dumper $FILE;

    $dbh->do(
"INSERT INTO LOGS (APPLICATION, FILENAME, AGE, RESULT, TOTAL_ROWS, SELECTED_ROWS) VALUES(?, ?, ?, ?, ?, ?)",
        undef, 
        $FILE->{APPLICATION},
        $FILE->{FILENAME},
        $FILE->{AGE},
        $FILE->{RESULT},
        $FILE->{TOTAL_ROWS},
        $FILE->{SELECTED_ROWS}

    );
    return;
}

sub fetch_arrays {
    my ($filename ) =  @_;
    my $sth = $dbh->prepare(
        "SELECT APPLICATION, FILENAME, AGE, TOTAL_ROWS , SELECTED_ROWS FROM LOGS WHERE  FILENAME = ?");
    $sth->execute($filename );
    while ( my @result = $sth->fetchrow_array() ) {
         print STDERR Dumper \@result;
    }
    $sth->finish;
    return;
}

sub fetch_hashref {
    my ($filename ) =  @_;
    my $sth = $dbh->prepare(
        # select star
        "SELECT FILENAME,*   FROM LOGS WHERE  FILENAME = ?");
    $sth->execute($filename );
    while ( my $result = $sth->fetchrow_hashref("NAME_lc") ) {
        print STDERR Dumper \$result;
    }
    $sth->finish;
    return;
}

sub update_rows {
    my ($filename , $total_rows, $selected_rows ) =  @_;
    my $sth = $dbh->prepare(
        "UPDATE LOGS SET TOTAL_ROWS = ?, SELECTED_ROWS = ?  WHERE FILENAME = ?");
    $sth->execute(  $total_rows, $selected_rows  ,$filename);
    $sth->finish;
    return;
}


sub print_summary()  {
  fetch_arrays('%');
}


sub usage {print $SELF; print <<PACKAGEUSAGE; exit 0;}
   Usage :

   $SELF [-apply|-diffonly] [-force] [-target <WORKAREA>]
         [-help] [-h]

   Unpack a AKAMAI logs.   Process logs, keep only the ones with specific statuses. Save the file locally
   Arguments:

   -root     - the location of the logs.  default is \\\\vnx5700cifs\\akamai_logs\\carnival
   -app      - Appplication log filename mask.  default is 'carnival' . Another possible choice is 'secure_carnival'
   -status   - option not supported yet. defalt is  (?:5\\d\\d|400) 
   -maxfiles - limit to processing this. detailt is 100.  
   -target   - directory to write files to - default is current directory.
   -skip     - skip first N files  . files are processed in reverse age order
   -header   - Keep the header lines in the filtered logs, listing the column names. Default is no headers
   -flat     - write the  filtered in plain text format. Default is gzipped
   -sqlite   - path to  SQLite database to keep and update the past execution history - work in progress
   -mysql    - the MYSQL connection string - work in progress 
   -initdb   - create DB schema 
Example:


 perl $SELF -app application_name -last 1800 -root \\\\host\\akamai_logs\\client   -flat

 perl $SELF -maxfiles 20 -skip 0 -app application -last 1800 -root \\\\host\\akamai_logs\\client  -flat

PACKAGEUSAGE


# vim: set tabstop=4 shiftwidth=4:
__END__



truncate_file({
#               FULLPATH=>"\\\\vnx5700cifs\\akamai_logs\\carnival\\secure_carnival_70848.esw3c_waf_S.201409090900-1000-0.gz" , 
FULLPATH=>"\\\\vnx5700cifs\\akamai_logs\\carnival\\secure_carnival_70848.esw3c_waf_S.201409090500-0600-0.gz" , 
              RESULT=>"b.log", 
              AGE=>time()}) ; 


# truncate_file({FULLPATH=>"\\\\vnx5700cifs\\akamai_logs\\carnival\\carnival_46625.esw3c_waf_S.201408261200-1300-1.gz" , AGE=>time()}) ; 
# truncate_file({FULLPATH=>"\\\\vnx5700cifs\\akamai_logs\\carnival\\carnival_46625.esw3c_waf_S.201408261300-1100-1.gz" , AGE=>time()}) ; 
exit ;

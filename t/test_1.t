use Test;
use Carp;
BEGIN { plan tests => 7 }

eval { require Regexp::Log::Helix; return 1; };
ok ($@, '', "Load test");
croak() if $@;


my $line = q(127.0.0.1 - - [18/Aug/2006:16:03:42 -0400]  "GET file.smil?cloakport=8080,554,7070 RTSPT/1.0" 200 8229 [MacOSX_10.4_10] [22f0d791-fd6e-11da-fa14-e92b0e9d89db] [Stat3:768] 10833 0 123 0 0 [0 0 0 0] [18/Aug/2006:16:01:37] 127.0.0.2);
    
my $rlrs;
my %data;

eval {
    $rlrs = Regexp::Log::Helix->new
	(
	 format => ':style11_3',
         capture => [qw( ip ts status req failedresends )],
      );
   my @fields = $rlrs->capture;
   my $re = $rlrs->regexp;
   @data{@fields} = ($line =~ /$re/g);
};
ok($@, '', "Capture and generate");

ok( $data{ip},     q(127.0.0.1), "ip" );
ok( $data{ts},   q(18/Aug/2006:16:03:42 -0400), "ts" );
ok( $data{status}, q(200), "status" );
ok( $data{req},    q(GET file.smil?cloakport=8080,554,7070 RTSPT/1.0), "req" );
ok( $data{failedresends}, q(0), "failedresends" );



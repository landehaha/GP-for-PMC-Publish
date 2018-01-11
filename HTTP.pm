dtmc
const double x1 ;
const double x2 ;
const double x3 = 1-x1-x2; 
const double y1 ;
const double y2 ;
const double y3 = 1- y1-y2;
const double z1 ;
const double z2 ;
const double z3 = 1-z1-z2;
const double w1 ;
const double w2 = 1-w1;
const double k1 ;
const double k2  = 1-k1;

module HTTP
	s : [0..9] init 0;
	[] s=0 -> y1 : (s'=1) + y2 :(s'=3) + y3 : (s'=7);
	[] s=1 -> 0.2 : (s'=1) + 0.55 :(s'=2) + 0.25 : (s'=8);
	[] s=2 -> 0.7 : (s'=5) + 0.3 :(s'=8);
	[] s=3 -> x2 : (s'=9) + x1 :(s'=8) + x3 : (s'=4);
	[] s=4 -> w1 : (s'=8) + w2 :(s'=9);
	[] s=5 -> z1 : (s'=6) + z2 :(s'=9) + z3 : (s'=8);
	[] s=6 -> k1 : (s'=8) + k2 :(s'=9);
	[] s=7 -> 1 : (s'=7);
	[] s=8 -> 1 : (s'=8);
	[] s=9 -> 1 : (s'=9);

endmodule

rewards "cost_time"

s = 1:1;
s = 2:2;
s = 3:1;
s = 4:1;
s = 5:1;
s = 6:4;

endrewards


rewards  "response_time"

s = 4:40;
s = 6:70;

endrewards
dtmc

const double Ps;
const int T;

module LWB
	s : [1..12] init 1;

	[] s = 1 -> Ps : (s'=3) + 1-Ps :(s'=2);	
	[] s = 2 -> 1 : (s'=1);
	[] s = 3 -> Ps : (s'=4) + 1-Ps :(s'=1);	
	[] s = 4 -> Ps : (s'=6) + 1-Ps :(s'=2);
	[] s = 5 -> Ps : (s'=6) + 1-Ps :(s'=7);
	[] s = 6 -> Ps : (s'=5) + 1-Ps :(s'=8);
	[] s = 7 -> Ps : (s'=5) + 1-Ps :(s'=9);
	[] s = 8 -> Ps : (s'=6) + 1-Ps :(s'=10);
	[] s = 9 -> Ps : (s'=6) + 1-Ps :(s'=11);
	[] s = 10 -> Ps : (s'=5) + 1-Ps :(s'=12);
	[] s = 11 -> Ps : (s'=5) + 1-Ps :(s'=1);	
	[] s = 12 -> Ps : (s'=6) + 1-Ps :(s'=2);								

endmodule

rewards "period"
s = 1 : (T-1000)/T;
s = 2 : 1000/T;
s= 4 : 35/T;
s= 3 : 145/T;
s= 5 : 19/T; 
s= 6 : 129/T;
s = 8 : 19/T;
s = 7 : 133/T;
s = 9 : 28/T;
s = 10 : 28/T;
s = 12 : 35/T;
s = 11 : 35/T;
endrewards

rewards "startup"
s = 1 : T-1000;
s = 2 : 1000;
s = 4 : 35;
s = 3 : 145;
s = 5 : 19;
endrewards
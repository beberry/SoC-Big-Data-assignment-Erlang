% The first task from the Erlang assignment for Big Data module
% By Jekabs Stikans
% 23.11.2014
-module(bdata1).
-export([pi/0,pi/1,pi/4]).
-export([round/2]).


% Default method, with precision to 5 decimal places.
pi() -> pi(5, 0, 1, 1).

% Method where the precision could be specified.
pi(N) -> pi(N, 0, 1, 1).

% Recursive method which calculates the PI value.
% Though by increasing the precision to decimal places,
% the result starts to get imprecise due to the limits of
% float data type.
pi(DecimalPlaces, CurrentPi, Sign, Denominator) when DecimalPlaces >= 0 andalso is_integer(DecimalPlaces) ->
	Changes		   = 4/Denominator,
	PrecisionLimit = math:pow(0.1,DecimalPlaces),

	if
		Changes < PrecisionLimit/4 ->
			% Round and return the calculated PI value.
			round(CurrentPi, DecimalPlaces);
		true ->
			% Calculate the new PI value and continue the recursion.
			NewPi = CurrentPi + (Sign*Changes),
			pi(DecimalPlaces, NewPi, Sign*-1, Denominator+2)
	end.

% Round function borrowed from - 
% http://www.codecodex.com/wiki/Round_a_number_to_a_specific_decimal_place
round(Number, Precision) ->
    P = math:pow(10, Precision),
    round(Number * P) / P.
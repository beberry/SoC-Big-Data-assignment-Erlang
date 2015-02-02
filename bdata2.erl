% The second task from the Erlang assignment for Big Data module
% By Jekabs Stikans
% 24.11.2014
-module(bdata2).
-export([unique/1, unique/2, quickSort/1, readlines/1, get_all_lines/1, count/1, count/2, printResutlts/2]).

% Work with a list provided to this method,
unique(L) ->
	UniqueList = unique(L, []),

	printResutlts(L, UniqueList).


% Load a list from a file.
unique(loadFile, FileName) -> 
	Text  = readlines(FileName),
	Parts = string:tokens(string:to_lower(Text), " !.,?:;>~</\\\n\r\"-@#$%^&*()[]+=_'0123456789"), 
	
	UniqueList = unique(Parts,[]),

	printResutlts(Parts, UniqueList);
	
% Add to objects to a unique list if they are not in it already.
unique([H|T],UniqueObj) ->
	case lists:member(H, UniqueObj) of
		true  -> NewUniqueObj = UniqueObj;
		false -> NewUniqueObj = UniqueObj ++ [H]
	end,

	unique(T,NewUniqueObj);

% Print out the final list of unique objects.
unique([], UniqueObj) ->
	quickSort(UniqueObj);

% In case of a wrong input.
unique(_,_) -> false.



% Quicksort example taken from the second lecture.
quickSort([Pivot|T]) ->
	quickSort([ X || X <- T, X < Pivot]) ++
	[Pivot] ++
	quickSort([ X || X <- T, X >= Pivot]);


quickSort([]) -> [].



% Counting elements within a list.
count(L) ->
	count(L, 0).

count([H|T], N) ->
	count(T, N+1);

count([], N) ->
	N.


% Print out the information about two lists.
printResutlts(Original, Unique) ->
	O = count(Original),
	U = count(Unique),

	io:format("~n~nOriginal, Unsorted List: ~n~p~n", [Original]),
	io:format("~nOriginal Count: ~n~p~n", [O]), 
	io:format("~nUnique, Sorted List: ~n~p~n", [Unique]),
	io:format("~nUnique Count: ~n~p~n", [U]),
	io:format("~n~n").


% Reading in files.
% Original borrowed from http://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
readlines(FileName) ->
    {_, Source} = file:open(FileName, [read]),
    try get_all_lines(Source) of
    	Contents -> file:close(Source),
    	Contents
    catch 
    	_ -> []
    end.

% For reading in lines from a file.
% Original borrowed from http://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
get_all_lines(Source) ->
    case io:get_line(Source, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Source)
    end.
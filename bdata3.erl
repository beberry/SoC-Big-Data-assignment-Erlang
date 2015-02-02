-module (bdata3).
-export ([load/1,count/3,go/1,join/2,split/2, procesSpawner/2, process/2, manager/2]).


%-------------------------------------------------
% 
% START Functions implemented by me.
%
%-------------------------------------------------

procesSpawner([], _) -> io:format("Done spawning manager processes.~n", []);

procesSpawner([H|T], ManagerPID) when is_list(H) ->
   spawn(?MODULE, process, [H, ManagerPID]),
   procesSpawner(T, ManagerPID).

process(L, Pid) ->
   Result=go(L),
   Pid ! {Result}.

manager(ResultList, JobsLeft) ->
   receive
      {UUUList} -> 
         io:format("Manager received a message. ~p Jobs left~n", [JobsLeft]),
         ResultListNew = join(ResultList, UUUList),

         case JobsLeft > 0 of
            true -> manager(ResultListNew, JobsLeft-1);
            false -> io:fwrite("~n Results ~p~n~n ~p Jobs left~n",[ResultListNew,JobsLeft])
         end;

       _Other -> {error, unknown}
   end.

%-------------------------------------------------
% 
% END Functions implemented by me.
%
%-------------------------------------------------


load(F)->
{ok, Bin} = file:read_file(F),
   
   NumSplits = 20,

   List=binary_to_list(Bin),
   Length=round(length(List)/NumSplits),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   io:fwrite("Loaded and Split~n"),

   % Create a manager object, tell that needs to wait for length(Sl) messages.
   ManagerPID = spawn(?MODULE, manager, [[],length(Sl)-1]),
   io:format("~nStarted spawning ~p managers~n",[length(Sl)]),
   procesSpawner(Sl, ManagerPID).
 

join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
{C,N}=H1,
{C1,N1}=H2,
[{C1,N+N1}]++join(T1,T2).

split([],_)->[];
split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true->S2=string:substr(List,Length+1,length(List));
   false->S2=[]
end,
[S1]++split(S2,Length).

count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

go(L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
rgo(Alph,L,[]).

rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2);

rgo([],L,Result)->Result.
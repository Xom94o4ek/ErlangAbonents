-module(main).
-behaviour(gen_server).

-export([start_link/0, init/1]).
-export([create_abonent/2,delete_abonent/1, edit_kvota/2, set_kvota/2, check_abonent/1, show_abonents/0]).
-export([handle_call/3]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
  {ok, dict:new()}.
  
create_abonent(Name, Count) ->
  gen_server:call(?MODULE, {create_abonent, Name, Count}).
delete_abonent(Name) ->
  gen_server:call(?MODULE, {delete_abonent, Name}).
edit_kvota(Name, Count) ->
  gen_server:call(?MODULE, {edit_kvota, Name, Count}).
set_kvota(Name, Count) ->
  gen_server:call(?MODULE, {set_kvota, Name, Count}).
check_abonent(Name) ->
  gen_server:call(?MODULE, {check_abonent, Name}).
show_abonents() ->
  gen_server:call(?MODULE, show_abonents).

handle_call({create_abonent, Name, Count}, _From, State) ->
	case dict:find(Name, State) of
		{ok,Value} ->
		  {reply, {error, abonent_already_exists}, State};
		error ->
			if
				Count >= 0 ->
				NewState = dict:store(Name, Count, State),
				Response = {created, {Name, Count}},
				{reply, Response, NewState};
			true ->
				{reply, {error, kvota_less_than_0}, State}
			end
	end;
handle_call({delete_abonent, Name}, _From, State) ->
	case dict:find(Name, State) of
	{ok,Value} ->
		NewState = dict:erase(Name, State),
		Response = {deleted, Name},
		{reply, Response, NewState};
	error ->
		{reply, {error, abonent_does_not_exist}, State}
	end;
handle_call({edit_kvota, Name, Count}, _From, State) ->
	case dict:find(Name, State) of
		{ok, Value} ->
			NewBalance = Value + Count,
			if
				NewBalance >= 0 ->
				Response = {edited, {Name, NewBalance}},
				NewState = dict:store(Name, NewBalance, State),
				{reply, Response, NewState};
			true ->
				{reply, {error, kvota_less_than_0}, State}
			end;
		error ->
			{reply, {error, abonent_does_not_exist}, State}
	end;
handle_call({set_kvota, Name, Count}, _From, State) ->
	case dict:find(Name, State) of
		{ok, Value} ->
			if
				Count >= 0 ->
				Response = {edited, {Name, Count}},
				NewState = dict:store(Name, Count, State),
				{reply, Response, NewState};
			true ->
				{reply, {error, kvota_less_than_0}, State}
			end;
		error ->
			{reply, {error, abonent_does_not_exist}, State}
	end;
handle_call({check_abonent, Name}, _From, State) ->
  case dict:find(Name, State) of
    {ok, Value} ->
		Response = {Name, Value},
		{reply, Response, State};
    error ->
		{reply, {error, abonent_does_not_exist}, State}
  end;
handle_call(show_abonents, _From, State) ->
      {reply, dict:to_list(State), State};
	  
handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.
  
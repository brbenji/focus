::  focus: an interval timer
::         made using sail and rudder
::         all components are contained within the %focus desk
::         including audio and image assets
::
::         customization to rudder has been made to facilitate
::         serving local assets from desk as well as long-polling
::         http handling
::
::    v1.0.1
::
::  XX: add a big-rest, which can bundle multiple focus sessions
::      into groups and set a time (big-rest) in between those.
::      (ex: 30min focus 3 times with 7min rests, but do that
::      all 4 times with a 35min big-rest in between.
::
::      we're not actually using prev-cmd.
::      perhaps when we add %pause we will?
::
/-  *focus
/+  rudder, agentio, verb, dbug, default-agent
/~  pages  (page:rudder tack command)  /app/webui
::
/*  enter-wav  %wav  /app/webui/assets/enter-lap/wav
/*  form-wav  %wav  /app/webui/assets/form-race-ok/wav
/*  reps-wav  %wav  /app/webui/assets/reps-pause-off/wav
/*  help-wav  %wav  /app/webui/assets/help-pause-to-next/wav
/*  begin-wav  %wav  /app/webui/assets/begin-new-record/wav
/*  focus-wav  %wav  /app/webui/assets/focus-friend-start/wav
/*  wrap-wav  %wav  /app/webui/assets/wrap-pause-on/wav
/*  rest-wav  %wav  /app/webui/assets/rest-match-complete/wav
/*  wrep-wav  %wav  /app/webui/assets/wrep-pause-exit-game/wav
::
/*  tile  %png  /app/webui/assets/tile/png
::
|%
+$  versioned-state
  $%  state-0
  ==
::  groove ex: ~m20 9 2 ~m5 8
::    this says: focus for 20min, wrap-up call at 90% of the way through,
::    do 2 repitions, with a 5min rest with a call back 80% of way
::    through rest.
::
+$  state-0  [%0 groove=gruv =reps =then =state-p =delivery =public]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
::
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
::
++  on-init
  ^-  (quip card _this)
  :-
  ::  XX: clean-up. this will create a pool on init
  ::      but if someone doens't have %goals I don't know how that would
  ::      go...could?
  ::
  :~  (~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl])
      %-  ~(poke-our pass:io /pool)
      :+  %goal-store
        %goal-action
      !>([%4 now.bowl %spawn-pool (crip "from focus - {<now.bowl>}")])
  ==
  %=  this
    state  :*  %0
               [~m5 8 1 ~s30 8]
               1
               [now.bowl now.bowl]
               [%enter %focus | %fresh |]
               *(list card)
               |
           ==
  ==
::
++  on-save  !>(state)
::
++  on-load
  |=  saved=vase
  ^-  (quip card _this)
  ~&  ~(key by pages)
  =/  ole  !<(versioned-state saved)
  `this(state ole)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?+  mark  (on-poke:def mark vase)
      %focus-command
    =/  command  !<(command vase)
    ?-    -.command
      ::  XX: add this functionality
      ::
        %pause
      ~&  'oops no pause'
      `this(prev-cmd.state-p %pause)
        %cont
      ~&  'oops all maneuvers'
      `this(prev-cmd.state-p %cont)
      ::
        %public
      `this(public public.command)
        %maneuver
      ?.  =(display.command %clock)
        `this(display.state-p display.command)
      ::  protect against ~s0 focus submissions
      ::  by reseting to the beginning
      ::
      ?~  `@`focus.gruv.command
        `this(display.state-p %enter, reveal.state-p |)
      :-
      :~
      ::  this will add an ease in time, if desired.
      ::
        (~(poke-self pass:io /begin) [%focus-command !>([%begin ~s0])])
      ==
      %=  this
        groove.state  gruv.command
        display.state-p  display.command
        mode.state-p  %focus
        reps  1
        long-poll.state-p  &
      ==
      ::
        %reveal
      `this(reveal.state-p +.command)
      ::
        %begin
      =/  begin-msg
        "begin to focus {<reps.groove>} times for {<focus.groove>}, resting {<rest.groove>} between each."
      ~&  >  begin-msg
      ::~&  "poking goals with {<(crip (scow %da now.bowl))>}"
      ::
      =/  fx
        :~  ::  cancel any existing timers
            ::
            (~(rest pass:io /(scot %tas mode.state-p)) -.then)
            (~(rest pass:io /wrap) +.then)
            ::
            ::  maybe there is only one focus
            ::
            ?:  (lte reps.groove 1)
              (~(poke-self pass:io /focus-pocus) [%focus-command !>([%fin focus.groove])])
            (~(poke-self pass:io /focus-pocus) [%focus-command !>([%focus focus.groove])])
            ::  spawn-goal in %goals for this groove
            ::
            ::  attempt to poke %goals to %spawn-goal
            ::  I'll need to scry for the pin of the focus pool
            ::    and perhaps for the context of any nested goals.
            ::    /wire for the pass [=dock =cage] for input
            ::  goal-action+!>([vzn now.bowl %spawn-pool title.command]
            ::  pin of the from focus pool [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1]
            ::
            ::(~(poke-our pass:io /groove-goal) [%goal-store [%goal-action !>([%4 now.bowl %spawn-goal [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1] ~ (crip (scow %da now.bowl)) |])]])
        ==
      ::  deliver the clock-focus page
      ::
      :-  (weld fx delivery)
      %=  this
        prev-cmd.state-p  %begin  :: temp?
        long-poll.state-p  |
      ==
        %focus
      ~&  >>  "focus {<reps>} of {<reps.groove>}"
      =/  focus  focus.groove
      =/  wrap  wrap.groove
      =/  setfocus  (add now.bowl focus)
      =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
      :-
      :~  (~(wait pass:io /focus) setfocus)
          (~(wait pass:io /wrap) setwrap)
          ::(~(poke-our pass:io /rep-goal) [%goal-store [%goal-action !>([%4 now.bowl %spawn-goal [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1] (some [owner=~zod birth=~2023.2.7..22.15.20..2844]) 'rep goal' |])]])
      ==
      %=  this
        then  [setfocus setwrap]
        long-poll.state-p  |
      ==
      ::
        %rest
      ~&  >  'rest'
      =/  rest  rest.groove
      =/  wrep  wrep.groove
      =/  setrest  (add now.bowl rest)
      =/  setwrep  (add now.bowl (mul wrep (div rest 10)))
      :-
      :~  (~(wait pass:io /rest) setrest)
          (~(wait pass:io /wrap) setwrep)
          ::  XX: is this the best place for creating a rep goal?
          ::      it would one rep-goal less than there is.
          ::      must use the rep count to create these goals
          ::      in focus mode
          ::  first pid is the pool, the context is the "path" into a
          ::  next.
          ::  ?edit the fresh rep-goal?
          ::  there would need to be a POST, I guess that could occur
          ::  within %handle-http-response. that would work as long as
          ::  it wasn't long-polling.
          ::(~(poke-our pass:io /rep-goal) [%goal-store [%goal-action !>([%4 now.bowl %spawn-goal [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1] (some [owner=~zod birth=~2023.2.7..22.15.20..2844]) 'rep goal' |])]])
                  ==
      %=  this
        reps  +(reps)
        then  [setrest setwrep]
        long-poll.state-p  |
      ==
        %fin
      ::  final focus mode
      ::
      ~&  >>  'final focus'
      =/  focus  focus.groove
      =/  wrap  wrap.groove
      =/  setfocus  (add now.bowl focus)
      =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
      :-
      :~  (~(wait pass:io /fin) setfocus)
          (~(wait pass:io /fin-wrap) setwrap)
          ::  last nested rep-goal
      ==
      %=  this
        then  [setfocus setwrap]
        long-poll.state-p  |
      ==
      ::  useful for when the timer is stuck in an interception
      ::
        %deliver
      [delivery this(long-poll.state-p |)]
    ==
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      ::  intercept the outgoing http-response
      ::  in -.out, if long-poll is engaged
      ::
      ?:  long-poll.state-p
        [~ this(delivery -.out)]
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder _+.state command)
      ::  map of pages
      ::
      pages
      ::  route
      ::
      |=  =trail:rudder
      ^-  (unit place:rudder)
      ?~  site=(decap:rudder /[dap.bowl] site.trail)  ~
      ?+  u.site  ~
        ::  !public is actually in a private setting
        ::  but public seems clearer when opting into it
        ::
        ~            `[%page !public %index]
        [%index ~]   `[%away (snip site.trail)]
        [%assets %enter %wav ~]  `[%asset %wav enter-wav]
        [%assets %form %wav ~]   `[%asset %wav form-wav]
        [%assets %reps %wav ~]   `[%asset %wav reps-wav]
        [%assets %help %wav ~]   `[%asset %wav help-wav]
        [%assets %begin %wav ~]  `[%asset %wav begin-wav]
        [%assets %focus %wav ~]  `[%asset %wav focus-wav]
        [%assets %wrap %wav ~]   `[%asset %wav wrap-wav]
        [%assets %rest %wav ~]   `[%asset %wav rest-wav]
        [%assets %wrep %wav ~]   `[%asset %wav wrep-wav]
        [%assets %tile %png ~]   `[%asset %png tile]
      ==
      ::  adlib or custom fallback
      ::
      (fours:rudder +.state)
      ::  solve/commmands from argue
      ::
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      ::  these cards are welded together with a spout
      ::    in the +apply of a POST
      ::
        =^  cards  this
          (on-poke %focus-command !>(cmd))
        [~ cards +.state]
      ==
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    =/  rest-poke
      ~[(~(poke-self pass:io /rest-poke) [%focus-command !>([%rest rest.groove])])]
    ::  deliver the clock-rest page
    ::
    :-  (weld rest-poke delivery)
    %=  this
      delivery  ~
    ==
      %rest
    ?>  ?=([%behn %wake *] sign)
    =/  focus-pocus
      ~[(~(poke-self pass:io /focus-pocus) [%focus-command !>([%focus focus.groove])])]
    =/  fin-poke
      ~[(~(poke-self pass:io /focus-pocus) [%focus-command !>([%fin focus.groove])])]
    ::  deliver the clock-focus page
    ::
    ?:  (gte reps reps.groove)
      [(weld fin-poke delivery) this(delivery ~)]
    :-  (weld focus-pocus delivery)
    %=  this
      delivery  ~
    ==
    ::
      %fin
    ::  when reps count is equal with reps.groove...
    ~&  >  'doneskis!'
    ::  deliver %goals page
    ::  XX: create %goals page
    ::
    :-  delivery
    %=  this
      display.state-p  %goals
      mode.state-p  %fin
      prev-cmd.state-p  %fresh
      long-poll.state-p  |
      reveal.state-p  |
      delivery  ~
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  ?:(=(mode.state-p %focus) 'wrap up' 'come back')
    =/  next-mode
      :: toggle between %focus and %rest
      ::
      ?:  =(mode.state-p %rest)
        %focus
      %rest
    ::  after a single focus go to %goals page
    ::
    ?:  (lte reps.groove 1)
      `this(long-poll.state-p &, display.state-p %goals)
    `this(long-poll.state-p &, mode.state-p next-mode)
    ::
      %fin-wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  'finish it!'
    `this(long-poll.state-p &, display.state-p %goals)

    ::
      %connect
    ~&  'eyre connecting'
    ~&  ~(key by pages)
    `this
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?+  path  (on-watch:def path)
    ::why is this here?
    ::
    [%http-response *]  [~ this]
  ==
::
++  on-agent  on-agent:def
++  on-peek   on-peek:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--

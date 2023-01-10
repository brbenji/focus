/-  *focus
/+  rudder, agentio, verb, dbug, default-agent
/~  pages  (page:rudder tack command)  /app/webui
::
|%
+$  versioned-state
  $%  state-0
  ==
::  groove ex: ~m20 9 2 ~m5 8
::    this says: focus for 20min, wrap-up call at 90% of way the through,
::    do 2 repitions, with a 5min rest with a call back 80% of way
::    through rest.
::
+$  state-0  [%0 groove=gruv =reps =then =state-p]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
::
=<
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
    eng   ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  :_  this(state [%0 [~m5 9 1 ~s30 8] 1 [now.bowl now.bowl] [%enter %focus %fresh |]])
  ~[(~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl])]
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
        %maneuver
      ?.  begin.command
        `this(display.state-p display.command)
      ~&  'easing in'
      ~&  "groove be {<gruv.command>}"
      ::  XX: integrate an actual ease in later
      ::
      =/  ease  (add now.bowl ~s0)
      :-  ~[(~(wait pass:io /rest) ease)]
      %=  this
        groove.state  gruv.command
        prev-cmd.state-p  %begin
        then  [ease ease]
        display.state-p  display.command
        reps  reps.gruv.command
      ==
        %focus
      ~&  'focus mode'
      =/  focus  focus.groove
      =/  wrap  wrap.groove
      =/  setfocus  (add now.bowl focus)
      =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
      :-
      :~  (~(wait pass:io /focus) setfocus)
          (~(wait pass:io /wrap) setwrap)
      ==
      %=  this
        reps.groove  (dec reps.groove)
        then  [setfocus setwrap]
        mode.state-p  %focus
      ==
        %rest
      ::  rest mode
      ::
      ~&  'rest mode'
      =/  rest  rest.groove
      =/  wrep  wrep.groove
      =/  setrest  (add now.bowl rest)
      =/  setwrep  (add now.bowl (mul wrep (div rest 10)))
      :_  this(then [setrest setwrep], mode.state-p %rest)
      :~  (~(wait pass:io /rest) setrest)
          (~(wait pass:io /wrap) setwrep)
      ==
    ==
    ::
      %handle-http-request
    =^  cards  state
      abet:(refresh:eng vase)
    [cards this]
    ::  =;  out=(quip card _+.state)
    ::    [-.out this(+.state +.out)]
    ::  %.  [bowl !<(order:rudder vase) +.state]
    ::  %:  (steer:rudder _+.state command)
    ::    pages
    ::    ::  it's public now!
    ::    ::    XX:figure out how to make it %enter at every load.
    ::    ::
    ::    (point:rudder /[dap.bowl] | ~(key by pages))
    ::    (fours:rudder +.state)
    ::    |=  cmd=command
    ::    ^-  $@  brief:rudder
    ::        [brief:rudder (list card) _+.state]
    ::    =^  caz  this
    ::      (on-poke %focus-command !>(cmd))
    ::    [~ caz +.state]
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    ?:  =(reps.groove 0)
      ::  no more reps means...
      ~&  'doneskis!'
      ::  XX: what display, mode, prev-cmd should be set after doneskis!?
      ::
      `this(display.state-p %enter)
    ::  start up rest mode
    ::
    =/  stern  `@`'stern='
    =/  local-post
      :*  id=~.~.eyre_local
          authenticated=%.y
          secure=%.n
          address=[%ipv4 .127.0.0.1]
          [method=%'POST' url='/focus' ~ body=[~ [p=60 q=stern]]]
      ==
    =/  vasey  !>(local-post)
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vasey) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] | ~(key by pages))
      (fours:rudder +.state)
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      [~ caz +.state]
    ==
    ::  ease from on-poke leads into here
    ::  confusingly on the /rest wire
    ::
    ::
      %rest
    ?>  ?=([%behn %wake *] sign)
    ::  start up focus mode
    ::
    =/  stern  `@`'stern=focus'
    =/  local-post
      :*  id=~.~.eyre_local
          authenticated=%.y
          secure=%.n
          address=[%ipv4 .127.0.0.1]
          [method=%'POST' url='/focus' ~ body=[~ [p=60 q=stern]]]
      ==
    =/  vasey  !>(local-post)
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vasey) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] | ~(key by pages))
      (fours:rudder +.state)
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      [~ caz +.state]
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  'wrap up'
    `this
    ::
      %connect
    ~&  'eyre connect'
    ~&  ~(key by pages)
    `this
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?+  path  (on-watch:def path)
    [%http-response *]  [~ this]
  ==
::
++  on-agent  on-agent:def
++  on-peek   on-peek:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
|_  bowl=bowl:gall
::  what does refresh produce? (quip card _this)?
::  what should go into refresh if it was a gate?
::    a breif or [brief cards this]
::
++  refresh
    |=  refresh=~
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vasey) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] | ~(key by pages))
      (fours:rudder +.state)
      ::  if http is a post and +argue finds a commands in the body
      ::
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      refresh
      ::  =^  caz  this
      ::    (on-poke %focus-command !>(cmd))
      ::  [~ caz +.state]
    ==
--
::  note of hack
::    local-post in on-arvo would be better as an arm somewhere. a
::    nested core might be best. but it was a late and complex addition
::    to the app. it still doesn't unlock page refreshing from on-arvo
::    like I hoped. I can't get the behn wake gift to initiate a new
::    page with the %rest timers clock.

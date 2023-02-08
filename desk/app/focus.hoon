::  focus: an interval timer
::
::    v1.0.1
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
+$  state-0  [%0 groove=gruv =reps =then =state-p =public]
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
  ::  XX: clean-up. this will create a pool on init
  ::      perhaps if I import /- goals  I can grab vzn
  ::      but if someone doens't have %goals I don't know how that would
  ::      go...could.
  :-  ~[(~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl]) (~(poke-our pass:io /pool) [%goal-store [%goal-action !>([%4 now.bowl %spawn-pool 'from focus'])]])]
  this(state [%0 [~m5 8 1 ~s30 8] 1 [now.bowl now.bowl] [%enter %focus | %fresh |] |])
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
      ::
        %reveal
      `this(reveal.state-p +.command)
      ::
        %maneuver
      ?.  begin.command
        `this(display.state-p display.command)
      ~&  'easing in'
      ~&  "groove be {<gruv.command>}"
      ~&  "poking goals with {<(crip (scow %da now.bowl))>}"
      ::  XX: integrate an actual ease in later
      ::
      =/  ease  (add now.bowl ~s0)
      :-
      :~  (~(wait pass:io /rest) ease)
          (~(rest pass:io /(scot %tas mode.state-p)) -.then)
          (~(rest pass:io /wrap) +.then)
          ::  attempt to poke %goals to %spawn-goal
          ::  I'll need to scry for the pin of the focus pool
          ::    and perhaps for the context of any nested goals.
          ::    /wire for the pass [=dock =cage] for input
          ::  goal-action+!>([vzn now.bowl %spawn-pool title.command]
          ::  pin of the from focus pool [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1]
          (~(poke-our pass:io /groove-goal) [%goal-store [%goal-action !>([%4 now.bowl %spawn-goal [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1] ~ (crip (scow %da now.bowl)) |])]])
      ==
      %=  this
        groove.state  gruv.command
        prev-cmd.state-p  %begin
        then  [ease ease]
        display.state-p  display.command
        reps  0
        mode.state-p  %focus
      ==
    ==
    ::
      %handle-http-request
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder _+.state command)
      ::  map of pages
      ::
      pages
      ::  it's public now!
      ::  we use ?! to flip the loobean because this setting is really
      ::  private ?, but public seems easier to understand and opt in
      ::  to from a terminal command.
      ::
      ::  (point:rudder /[dap.bowl] !public ~(key by pages))
      ::
      ::  route
      ::
      |=  =trail:rudder
      ::  trail has an optional ext at the head, it's [ext=(unit @ta)
      ::  site=(list @ta)]
      ::  I think this means if the url is /focus/assets/form.wav
      ::  it could manage the .wav extension. and that means here I
      ::  would deal with u.ext.trail and process however I needed.
      ::
      ^-  (unit place:rudder)
      ?~  site=(decap:rudder /[dap.bowl] site.trail)  ~
      ?+  u.site  ~
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
      ::  (fours:rudder +.state)
      ::  custom fallback / adlib
      ::    XX: this might be where long-polling will occur
      ::
      |=  =order:rudder
      ^-  [[(unit reply:rudder) (list card)] _+.state]
      ~&  "can you find the request id in da vase {<!<(order:rudder vase)>}"
      =/  body  ^-  manx
      ;html
      ;head
        ;title:"%focus"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ==
      ;body
        ;p:'hello'
      ==  ==
      ~&  "is this my response {<(reply:rudder [%xtra [['keep-alive' 'timeout=500, max=80000'] ~] body])>}"
      =;  msg  [[`[%xtra [['keep-alive' 'timeout=500, max=80000'] ~] msg] ~] +.state]
      body
      ::  try to make this page
      ::  XX: we can send out %xtra reply, see what happens.
      ::  - need
      ::  u(
      ::    ?(
      ::      [%audio-wav wav=@]
      ::      [%image-png png=@]
      ::      [%next loc=@t msg=?(%~ @t)]
      ::      [%auth loc=@t]
      ::      [%move loc=@t]
      ::      [%code cod=@ud msg=?(%~ @t)]
      ::      [ %full
      ::          ful
      ::        [ response-header=[status-code=@ud headers=it([key=@t value=@t])]
      ::          data=u([p=@ud q=@])
      ::        ]
      ::      ]
      ::      [%page bod=#4]
      ::      [ %xtra
      ::        hed=it([key=@t value=@t])
      ::        bod=^#4.[g=[n=?(@tas [@tas @tas]) a=it([n=?(@tas [@tas @tas]) v=""])] c=it(#4)]
      ::      ]
      ::    )
      ::  )
      ::  actions / solve
      ::
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      [~ caz +.state]
    ==
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    ?:  (gte reps reps.groove)
      ::  no more reps means...
      ~&  'doneskis!'
      `this(display.state-p %enter, mode.state-p %fin, reveal.state-p |)
    ::  start up rest mode
    ::
    ::  rest mode
    ::
    ~&  'rest mode'
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
        (~(poke-our pass:io /rep-goal) [%goal-store [%goal-action !>([%4 now.bowl %spawn-goal [%pin owner=~zod birth=~2023.2.7..21.44.48..24b1] (some [owner=~zod birth=~2023.2.7..22.15.20..2844]) 'rep goal' |])]])
    ==
    %=  this
      then  [setrest setwrep]
      mode.state-p  %rest
    ==
    ::  ease from on-poke leads into here
    ::  confusingly on the /rest wire
    ::
    ::
      %rest
    ?>  ?=([%behn %wake *] sign)
    ::  start up focus mode
    ::
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
      reps  +(reps)
      then  [setfocus setwrap]
      mode.state-p  %focus
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
    ::  why is this here?
    ::
    [%http-response *]  [~ this]
  ==
::
++  on-agent  on-agent:def
++  on-peek   on-peek:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--

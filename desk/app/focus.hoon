::  focus: an interval timer
::
::    v1.2.1 - now with pause button, and goals!
::
::  the fun thing about focus, is that's it's techniaclly 100% hoon.
::  made using sail and rudder there is only 6 lines of javascript.
::  and all components are contained within the %focus desk including
::  audio and image assets.
::
::         customization to lib/rudder has been made to facilitate
::         serving local assets from desk
::
::
::  XX: add a big-rest, which can bundle multiple focus sessions
::      into groups and set a time (big-rest) in between those.
::      (ex: 30min focus 3 times with 7min rests, but do that
::      all 4 times with a 35min big-rest in between.
::
/-  *focus, goal
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
+$  state-0  [%0 groove=gruv =reps =then =left =state-p =goals =public]
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
  :~  (~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl])
  ==
  %=  this
    state  :*  %0
               [~m5 8 1 ~s30 8]
               1
               [now.bowl now.bowl]
               [~s0 ~s0]
               [%enter %focus | %fresh]
               [| [our.bowl *@da] [our.bowl *@da] [our.bowl *@da] [our.bowl *@da]]
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
  ::  XX: if focus ever becomes multi-player add a whitelist based
  ::      on whoever is in a lobby/group...or whatever
  ::
  ?>  (team:title our.bowl src.bowl)
  ?+  mark  (on-poke:def mark vase)
      %focus-command
    =/  command  !<(command vase)
    ?-    -.command
        %goals
      ?.  goals.command
        ::| - no goals
        ::  turn off signal for sending goal cards
        `this(on.goals goals.command)
      ::  & - wanting goals
      ::  branch on first time or not
      ::
      ?.  =(birth.pool.goals *@da)
        ::  false - turn on the state signal to start sending goal cards
        `this(on.goals goals.command)
      ::  true - check dependency
      ::
      |^  =+  (check-dependency %gol-cli)
          :-
          :~::  poke %goals for a new pool for focus to populate
            ::
            %-  ~(poke-our pass:io /pool)
            :+  %goal-store  %goal-action
            !>([%4 now.bowl %spawn-pool (crip "focus")])
            ::  subscribe
            ::
            ::   not sure what I get with this?
            (~(watch-our pass:io /goal-watch) [%goal-store /goals])
          ==
          %=  this
            pool.goals  [our.bowl now.bowl]
            on.goals  goals.command
          ==
      ::
      ++  check-dependency
        |=  app=dude:gall
        ~|  :*  'Your ship is missing the Goals app.'
                ''
                'To track goals:'
                'click on the "Get Urbit Apps" button and search'
                '~dister-dozzod-niblyx-malnus/gol-cli'
                ''
                'Or run the following command in dojo'
                '|install ~dister-dozzod-niblyx-malnus %gol-cli'
                ''
                'If you want to use focus without tracking goals,'
                'simply use the back button in your browser to leave this screen.'
            ==
        ?>  .^(? %gu /(scot %p our.bowl)/[app]/(scot %da now.bowl))
        ~
      --
      ::
        %pause
      ~&  >  'paused'
      ::  calc the time left for current timers
      ::
      =/  at-pause
        :-  `@dr`(sub time.then now.bowl)
            ?:  (lth wrap.then now.bowl)
              *@dr
            `@dr`(sub wrap.then now.bowl)
      :-
      :~
        ::  cancel timers
        ::
        (~(rest pass:io /(scot %tas mode.state-p)) time.then)
        (~(rest pass:io /wrap) wrap.then)
        ::  maybe there is a fin timer
        ::
        (~(rest pass:io /fin) time.then)
        (~(rest pass:io /fin-wrap) wrap.then)
      ==
      %=  this
        left  at-pause
        prev-cmd.state-p  %pause
      ==
      ::
        %cont
      ~&  'welcome back'
      ~&  >>  'continue'
      =/  time  `@da`(add now.bowl -.left)
      =/  setwrap  `@da`(add now.bowl +.left)
      :-
      ?:  (gte reps reps.groove)
        :~
          (~(wait pass:io /fin) time)
          (~(wait pass:io /fin-wrap) setwrap)
        ==
      :~
        (~(wait pass:io /(scot %tas mode.state-p)) time)
        (~(wait pass:io /wrap) setwrap)
      ==
      %=  this
        display.state-p  %clock
        prev-cmd.state-p  %cont
        then  [time setwrap]
      ==
      ::
        %public
      `this(public public.command)
      ::
        %maneuver
      ?.  =(display.command %clock)
        ::  if we aren't going to look at a %clock
        ::  we don't want to set timers
        ::
        ::  also restart the prev-cmd to avoid a bug when
        ::  pause is pressed and then new.
        ::
        `this(display.state-p display.command, prev-cmd.state-p %fresh)
      ::  protect against ~s0 focus submissions
      ::  by reseting to the beginning
      ::
      ?~  `@`focus.gruv.command
        `this(display.state-p %enter, multi.state-p |)
      ::  do we want goals?
      ::
      =/  begin-msg
        ?:  (lte reps.gruv.command 1)
        "begin to focus for {<focus.gruv.command>}"
      "begin to focus {<reps.gruv.command>} times for {<focus.gruv.command>}, resting {<rest.gruv.command>} between each."
      ~&  >  begin-msg
      ::  display hour in clock style
      ::
      =/  am-pm  (mod h:(yell now.bowl) 12)
      =/  hour  ?:((gte 12 am-pm) "{<am-pm>}pm-utc" "{<am-pm>}am-utc")
      =/  day  "{<m:(yore now.bowl)>}.{<d.t:(yore now.bowl)>}"
      ::  a copy of +face in webui
      ::  XX: create a library for all useful arms and definitions
      ::
      =/  face
        =/  sec  (yell focus.gruv.command)
        =/  total  (add (mul hor:yo h.sec) (add (mul mit:yo m.sec) s.sec))
        =/  min  (div total 60)
        ::  account for times less than a minute
        ::  display seconds instead
        ::
        ?:  (lte total 60)
          (weld (a-co:co total) "s")
        (weld (a-co:co min) "m")
      =/  time-cards
        :~  ::  prime the behn timer ping-pong
            ::
            (~(wait pass:io /rest) now.bowl)
            ::  cancel any existing timers
            ::
            (~(rest pass:io /(scot %tas mode.state-p)) -.then)
            (~(rest pass:io /wrap) +.then)
            (~(rest pass:io /fin) -.then)
            (~(rest pass:io /fin-wrap) +.then)
        ==
      ?.  on.goals
        :: false - no goals version of the timer
        ::
        :-  time-cards
        %=  this
          groove.state  gruv.command
          display.state-p  display.command
          mode.state-p  %focus
          reps  0
        ==
      ::  true - send goal facts too
      ::
      ::  is today a new day since our last focus session?
      ::
      ?:  =(d:(yell +.day.goals) d:(yell now.bowl))
        ::  true - only create groove-goal within the day-goal
        ::
        :-
        :*  ::  create a goal for this groove
            ::
            %-  ~(poke-our pass:io /pool)
            :+  %goal-store  %goal-action
            !>  :*  %4  now.bowl
                    %spawn-goal
                    [%pin -.pool.goals +.pool.goals]
                    (some [-.day.goals +.day.goals])
                    (crip "{face} at {hour}")
                    |
                ==
            time-cards
        ==
        %=  this
          groove.state  gruv.command
          display.state-p  display.command
          mode.state-p  %focus
          reps  0
          groove.goals  [our.bowl now.bowl]
        ==
      ::  false - create a new day-goal and a groove-goal in it.
      ::
      :-
      :*  ::  create a goal for this groove
          ::
          %-  ~(poke-our pass:io /pool)
          :+  %goal-store  %goal-action
          !>  :*  %4  now.bowl
                  %spawn-goal
                  [%pin -.pool.goals +.pool.goals]
                  ~
                  (crip "day {day}")
                  |
              ==
          %-  ~(poke-our pass:io /pool)
          ::  this seemed to work fine
          :+  %goal-store  %goal-action
          !>  :*  %4  now.bowl
                  %spawn-goal
                  [%pin -.pool.goals +.pool.goals]
                  ::  the parent pin, aka the day-goal we just poked
                  (some [our.bowl now.bowl])
                  (crip "{face} at {hour}")
                  |
              ==
          time-cards
      ==
      %=  this
        groove.state  gruv.command
        display.state-p  display.command
        mode.state-p  %focus
        reps  0
        day.goals  [our.bowl now.bowl]
        ::  this groove-goal arrives exactly with day-goal
        ::  %goal-store will increment the time by 1ms
        ::
        groove.goals  [our.bowl (add now.bowl ~s0..0001)]
      ==
      ::
        %multi
      `this(multi.state-p +.command)
      ::
        %sub
      :-
      ~&  'my path'
      :~
        (~(watch-our pass:io /goal-pool) [%goal-store /(scot %p -.pin.command)/(scot %da +.pin.command)])
      ==
      this
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
      %rest
    ?>  ?=([%behn %wake *] sign)
    =/  focus  focus.groove
    =/  wrap  (mul wrap.groove (div focus 10))
    =/  setfocus  (add now.bowl focus)
    =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
    =/  desc
      ?:  (lte reps.groove 1)
        "focus"
      "focus {<+(reps)>}/{<reps.groove>}"
    =/  rep-goal
      ::  create a goal for this groove
      ::
      %-  ~(poke-our pass:io /pool)
      :+  %goal-store  %goal-action
      !>  :*  %4  now.bowl
              %spawn-goal
              [%pin -.pool.goals +.pool.goals]
              (some [-.groove.goals +.groove.goals])
              (crip desc)
              |
          ==
    ?:  (gte reps (dec reps.groove))
      ::  the final focus
      ::
      ~&  >>  ?:((lte reps.groove 1) 'focus' 'final focus')
      :-
      :~  (~(wait pass:io /fin) setfocus)
          (~(wait pass:io /fin-wrap) setwrap)
          rep-goal
      ==
      %=  this
        reps  +(reps)
        then  [setfocus (add now.bowl wrap)]
        mode.state-p  %focus
      ==
    ::  set focus timers
    ::
    ~&  >>  "focus {<+(reps)>} of {<reps.groove>}"
    :-
    :~  (~(wait pass:io /focus) setfocus)
        (~(wait pass:io /wrap) setwrap)
        rep-goal
    ==
    %=  this
      reps  +(reps)
      then  [setfocus (add now.bowl wrap)]
      mode.state-p  %focus
    ==
    ::
      %focus
    ::  set rest timers
    ::
    ?>  ?=([%behn %wake *] sign)
    ~&  >  'rest'
    =/  rest  rest.groove
    =/  wrep  wrep.groove
    =/  setrest  (add now.bowl rest)
    =/  setwrep  (add now.bowl (mul wrep (div rest 10)))
    :-
    :~  (~(wait pass:io /rest) setrest)
        (~(wait pass:io /wrap) setwrep)
    ==
    %=  this
      then  [setrest setwrep]
      mode.state-p  %rest
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  ?:(=(mode.state-p %focus) 'wrap up' 'come back')
    ::  after a single focus go to %enter page
    ::
    ?:  (lte reps.groove 1)
      `this(display.state-p %enter)
    `this
    ::
      %fin-wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  ?:((lte reps.groove 1) 'wrap up' 'finish it')
    `this(display.state-p %enter)
    ::
      %fin
    ~&  >  'doneskis!'
    ::
    :-  ~
    %=  this
      display.state-p  %enter
      mode.state-p  %fin
      prev-cmd.state-p  %fresh
      multi.state-p  |
    ==
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
++  on-agent
  |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
        [%goal-watch ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
          ?+    p.cage.sign  (on-agent:def wire sign)
              %goal-home-update
            ::  XX: remove this scratch pad for figuring out
            ::      scrying into %gol-cli and address numbering
            ::
            ::  =/  foo  !<(expected-type q.cage.sign)
            ::  ~&  "I think I got something!"
            ::  ~&  !<(home-update:goal q.cage.sign)
            ::  ~&  pin:!<(home-update:goal q.cage.sign)
            ::  ~&  +62:!<(home-update:goal q.cage.sign)
            ::  address numbers
            ::  1 @2 3 @6 7 @14 15 @30 31 @62 63 @126 127 @254 255 @510 511 1022
            `this
          ==
      ==
    ==
++  on-peek   on-peek:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--

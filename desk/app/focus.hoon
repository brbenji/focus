::  focus: an interval timer
::         made using sail and rudder
::         all components are contained within the %focus desk
::         including audio and image assets
::
::        customization to rudder has been made to facilitate
::        serving local assets from desk as well as long-polling
::        http handling
::
::    v1.0.1
::
::  XX: there is a timing issue...delivery isn't logged until after
::      'focus mode' engages. so the eyre-id already cycles, before
::      I can send out the response.
::
::        fix attempt: adding delivery into a %manuever command,
::        didn't change the sequencing at all.
::
::  XX: add a big-rest, which can bundle multiple focus sessions
::      into groups and set a time (big-rest) in between those.
::      (ex: 30min focus 3 times with 7min rests, but do that
::      all 4 times with a 35min big-rest in between.
::
::      we're not actually using prev-cmd.
::      perhaps when we add %pause we will?
::      we should scrutinize begin.state-p
::      do even use that. clearly I use begin.command, as
::      given by webui.
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
::  potentially delivery must be at the end
::  bc I've modified rudder to tack the http-response of
::  POST and GET into state instead of immediately delivering them
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
  ::  XX: clean-up. this will create a pool on init
  ::      but if someone doens't have %goals I don't know how that would
  ::      go...could?
  ::
  :_  this(state [%0 [~m5 8 1 ~s30 8] 1 [now.bowl now.bowl] [%enter %focus | %fresh |] *(list card) |])
  :~  (~(connect pass:io /connect) [[~ /[dap.bowl]] dap.bowl])
      (~(poke-our pass:io /pool) [%goal-store [%goal-action !>([%4 now.bowl %spawn-pool (crip "from focus - {<now.bowl>}")])]])
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
      `this
        %reveal
      `this
      ::
        %begin
      ~&  'begin'
      ~&  "groove be {<groove.state>}"
      ~&  "{<reps>} of {<reps.groove>} long-poll disengaged"
      ::~&  "poking goals with {<(crip (scow %da now.bowl))>}"
      ::  XX: integrate an actual ease in later
      ::
      =/  ease  (add now.bowl ease.command)
      =/  fx
        :~  ::  kick-off timers with an ease-in (currently immediate)
            ::    as set by the poke-self from rudder +solve
            ::
            ::  this was doubling my first timers
            ::  (~(wait pass:io /rest) ease)
            ::  cancel any existing timers
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
        then  [ease ease]
        prev-cmd.state-p  %begin  :: temp?
        long-poll.state-p  |
      ==
        %focus
      ~&  'focus start'
      ~&  "{<reps>} of {<reps.groove>} long-poll disengaged"
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
        reps  +(reps)
        then  [setfocus setwrap]
        long-poll.state-p  |
      ==
      ::
        %rest
      ~&  'rest start'
      ~&  "{<reps>} of {<reps.groove>} long-poll disengaged"
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
        then  [setrest setwrep]
        long-poll.state-p  |
      ==
        %fin
      ::  final focus mode
      ::
      ~&  'final focus start'
      ~&  "{<reps>} of {<reps.groove>} long-poll disengaged"
      =/  focus  focus.groove
      =/  wrap  wrap.groove
      =/  setfocus  (add now.bowl focus)
      =/  setwrap  (add now.bowl (mul wrap (div focus 10)))
      :-
      :~  (~(wait pass:io /fin) setfocus)
          (~(wait pass:io /wrap) setwrap)
          ::  last nested rep-goal
      ==
      %=  this
        reps  +(reps)
        then  [setfocus setwrap]
        long-poll.state-p  |
      ==

      ::  what about a %send/%deliver poke?
      ::  or what if %focus and %rest are pokes, that set timers and
      ::  on-arvo, once those timers are complete delivers the next one.
      ::
      ::  sequence:
      ::    form - posts a groove with a %maneuver
      ::           the groove is set and the display is changed to
      ::           clock
      ::           long-poll.state-p  &
      ::           set mode %focus
      ::           poke-self %begin
      ::
      ::      long-poll is turned on, which means java refresh script
      ::      should be entered into the webui script. maybe every time
      ::      it's %.y? I think so.
      ::
      ::    %begin - is a poke-self triggered by %maneuver
      ::            begin cancels existing timers, poke-self %focus
      ::            set reps to 0
      ::            and delivers the clock/focus display
      ::            also spawns the groove-goal
      ::    %focus - sets the /focus and /wrap timers, and inc reps to 1.
      ::             long-poll | for audio assets to be delivered.
      ::             set mode %rest?
      ::             sets then with it's timers
      ::             also spawns nested rep-goal 1
      ::    /wrap  - long-poll &, and java refresh is injected in webui.
      ::             at this point access to form is blocked.
      ::             delivery...what is it delivering?
      ::    /focus - on-arvo, once the time is up it
      ::             will deliver clock-rest and poke-self %rest.
      ::             and wipe delivery ~
      ::    %rest - sets the /rest and /wrap timers.
      ::            long-poll | for audio assets to be delivered.
      ::            set mode %focus
      ::            (could I allow for nested rep-goal 1 editing here?)
      ::    /wrap - long-poll &, and java refresh is injected in webui.
      ::    /rest - on-arvo, will deliver clock-focus
      ::            and poke-self %focus
      ::          to end
      ::    %focus - branch on (gte reps (dec reps.groove)), %.y set the final
      ::             /fin and /wrap timers, reps will inc to be
      ::             equal to the reps.groove. long-poll |.
      ::             set mode %focus
      ::             set display %goals-edit
      ::             also spawns the last nested rep-goal
      ::    /wrap  - long-poll &, and java refresh is injected in webui.
      ::    /fin - on-arvo, once timer is up will deliver a page of the
      ::           %goals created by the groove to be edited, made
      ::           completed, and perhaps added to?
      ::
    ==
    ::
      %handle-http-request
    =/  order  !<(order:rudder vase)
    ~&  [id:order method:request:order url:request:order]
    =;  out=(quip card _+.state)
      ::  intercept the outgoing http-response
      ::    which is in the form of cards in -.out
      ::
      ::  branch on mode, display, or prev-cmd
      ::
      ?.  long-poll.state-p
        [-.out this(+.state +.out)]
      ~&  'intercepting out'
      [~ this(delivery -.out)]
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
        ::  it's public now!
        ::  we use ?! to flip the loobean because this setting is really
        ::  private=?, but public seems easier to understand and opt in
        ::  to from a terminal command.
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
      |=  =command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      ::  these cards are welded together with a spout
      ::    in the +apply of a POST
      ::
      ?-  -.command
        ::
        ::  maneuver both moves and takes an action
        ::  a groove is set and the display is changed
        ::  all in one poke.
        ::
        %maneuver
        ~&  'form posted long-poll engaged'
        ?.  =(display.command %clock)
          ``+.state(display.state-p display.command)
        :-  ~   :-
        ::  this will add an ease in time, if desired.
        ::
        ~[(~(poke-self pass:io /begin) [%focus-command !>([%begin ~s0])])]
        %=  +.state
          groove  gruv.command
          display.state-p  display.command
          reps  0
          long-poll.state-p  &
          mode.state-p  %focus
        ==
        ::
          %reveal
        ``+.state(reveal.state-p +.command)
          %pause
        ~&  'oops no pause'
        ``+.state(prev-cmd.state-p %pause)
          %cont
        ~&  'oops all maneuvers'
        ``+.state(prev-cmd.state-p %cont)
        ::
          %public
        ``+.state(public public.command)
          %begin  ``+.state
          %focus  ``+.state
          %rest  ``+.state
          %fin  ``+.state
        ==
      ::  =^  cards  this
        ::  (on-poke %focus-command !>(cmd))
      ::  [~ cards +.state]
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
    ?:  (gte reps (dec reps.groove))
      [(weld fin-poke delivery) this(delivery ~, display.state-p %goals)]
    :-  (weld focus-pocus delivery)
    %=  this
      delivery  ~
    ==
    ::
      %fin
    ::  when reps count is equal with reps.groove...
    ~&  'doneskis!'
    ~&  "{<reps>} of {<reps.groove>} long-poll disengaged"
    ::  deliver %goals page
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
    ~&  'wrap up'
    ~&  "long-polling engaged"
    =/  next-mode
      ?:  =(mode.state-p %focus)  %rest
        %focus
    ?:  (lte reps.groove 1)
      `this(long-poll.state-p &, display.state-p %goals)
    `this(long-poll.state-p &, mode.state-p next-mode)
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

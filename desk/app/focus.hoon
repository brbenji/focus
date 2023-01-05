/-  *focus
/+  rudder, agentio, verb, dbug, default-agent
/~  pages  (page:rudder tack command)  /app/webui
::
|%
+$  versioned-state
  $%  state-0
  ==
::  groove ex: ~s2 9 2 ~s5 8
::
+$  state-0  [%0 =then groove=gruv =prev-cmd =display =mode]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
::
++  on-init
  ^-  (quip card _this)
  ::  .^((list [binding:eyre duct action:eyre]) %e /=bindings=)
  ::  scry to trouble shoot no binding on install.
  ::
  :_  this
  ~[(~(connect pass:io /eyre/connect) [[~ /[dap.bowl]] dap.bowl])]
::
++  on-save  !>(state)
::
++  on-load
  |=  saved=vase
  ^-  (quip card _this)
  ~&  ~(key by pages)
  `this(state !<(versioned-state saved))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?+  mark  (on-poke:def mark vase)
      %focus-command
    =/  command  !<(command vase)
    ?-    -.command
        %pause
      ~&  'oops no pause'
      `this(prev-cmd %pause)
        %cont
      ~&  'oops all begins'
      `this
        %mod
      ~&  'no mod yet, give me time'
      `this
        %begin
      ~&  'easing in'
      ~&  "groove be {<gruv.command>}"
      =/  ease  (add now.bowl ~s4)
      :-  ~[(~(wait pass:io /rest) ease)]
      %=  this
        groove.state  gruv.command
        prev-cmd  %begin
        then  [ease ease]
      ==
        %nav
      ~&  "we hit nav people, where going to {<+.command>}"
      =/  next  (dis-convert +.command)
      ::
      ::
      `this(display next)
    ==
    ::
      %handle-http-request
    ~&  "knock knock, http-request!"
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl !<(order:rudder vase) +.state]
    %:  (steer:rudder _+.state command)
      pages
      (point:rudder /[dap.bowl] & ~(key by pages))
      (fours:rudder +.state)
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  caz  this
        (on-poke %focus-command !>(cmd))
      ['Processed succesfully.' caz +.state]
    ==
  ==
::
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
::  what must I do to send data back to the frontend
::  'my pages' from on-arvo here?
::  ^ on-watch might be a clue.
::  maybe the wire on-arvo can be %http-response?
::  and with that...no. I think I'm mostly sending
::  stuff out.
::
::  look at the out part of the on-poke rudder stuff.
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  -.wire  (on-arvo:def wire sign)
      %focus
    ?>  ?=([%behn %wake *] sign)
    ?:  =(reps.groove 0)
      ~&  'doneskis!'
      ::  attempting to refresh the 'begin' play button
      ::  but from here it requires some eyre request
      ::
      :_  this(prev-cmd %fresh)
      ~[(~(poke-self pass:io /cont) [%handle-http-request !>(*request:http)])]
    ::  rest mode
    ::
    ~&  "{<mode>} mode"
    =/  rest  rest.groove
    =/  wrep  wrep.groove
    =/  setrest  (add now.bowl rest)
    =/  setwrep  (add now.bowl (mul wrep (div rest 10)))
    :_  this(then [setrest setwrep], mode %rest)
    :~  (~(wait pass:io /rest) setrest)
        (~(wait pass:io /wrap) setwrep)
    ==
      %rest
    ?>  ?=([%behn %wake *] sign)
    ::  focus mode
    ::
    ~&  "{<mode>} mode"
    ~&  "groove be {<groove>}"
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
      mode  %focus
    ==
    ::
      %wrap
    ?>  ?=([%behn %wake *] sign)
    ~&  'wrap up'
    `this
    ::
   ::   %bind-focus
   :: ~?  !accepted.sign
   ::   [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
   :: [~ this]
  ==
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--

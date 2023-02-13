::  additional types for potentail expansion
::  +$  ease  @dr  :: def ~s4 before focus begins, a delay on begin
::  +$  name  @t
::
/+  rudder
|%
+$  focus  @dr
+$  wrap  @ud  :: signal before time ends
+$  reps  @ud
+$  rest  @dr
+$  wrep  @ud  :: wrap for the rest periods
+$  gruv  [=focus =wrap =reps =rest =wrep]
::
+$  then  [@da @da]
::
+$  public  ?
::
+$  display  ?(%form %help %clock %goals %enter)
+$  mode  ?(%fin %rest %focus)
+$  prev-cmd  ?(%begin %pause %cont %fresh)
+$  reveal  ?
+$  state-p  [=display =mode =reveal =prev-cmd long-poll=?]
+$  delivery  (list card:agent:gall)
::
::  type unions are eating my lunch!
::    disaplyify was made to help out.
::
++  displayify
  |=  incoming=@tas
  %-  display  incoming
::
::  is there a good non-cell way to do this
::  most of these commands could just be @tas
::  begin, focus, rest, fin, pause, cont, deliver
::
::  as an experiment. my mark for commands is now
::  simply &command, instead of &focus-command.
::  I have no need for a /mar, because this app is
::  self contained. there is no need to convert to json.
::
+$  command
  $%  [%focus @dr]
      [%rest @dr]
      [%fin @dr]
      [%pause ?]
      [%cont ?]
      [%deliver ~]
      [%reveal reveal]
      [%begin ease=@dr]
      [%public public=?]
      [%maneuver =gruv =display]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::  state for rudder, a copy of +.state-0
::  +$  state-0  [%0 groove=gruv =reps =then =state-p =delivery =public]
::
+$  tack  [groove=gruv =reps then state-p delivery public]
--

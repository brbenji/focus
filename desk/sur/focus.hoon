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
+$  display  ?(%form %help %clock %enter)
+$  mode  ?(%fin %rest %focus)
+$  prev-cmd  ?(%begin %pause %cont %fresh)
+$  reveal  ?
+$  begin  ?
+$  state-p  [=display =mode =reveal =prev-cmd =begin]
::  type unions are eating my lunch!
::    disaplyify was made to help out.
::
++  displayify
  |=  incoming=@tas
  %-  display  incoming
::
+$  command
  $%  [%maneuver =gruv =display =begin]
      [%pause ?]
      [%cont ?]
      [%public public=?]
      [%reveal reveal]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::  state for rudder, a copy of +.state-0
::  +$  state-0  [%0 groove=gruv =reps =then =state-p =public]
::
+$  tack  [groove=gruv =reps then state-p public]
--

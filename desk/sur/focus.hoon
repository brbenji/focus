::  additional types for potentail expansion
::  +$  ease  @dr  :: def ~s4 before focus begins, a delay on begin
::  +$  name  @t
::
|%
+$  focus  @dr
+$  wrap  @ud  :: signal before time ends
+$  reps  @ud
+$  rest  @dr
+$  wrep  @ud  :: wrap for the rest periods
+$  gruv  [=focus =wrap =reps =rest =wrep]
::
+$  command
  $%  [%begin =gruv]
      [%pause ?]
      [%cont ?]
      [%mod mod=gruv]  :: for changing wrap, rest, rewarp on the fly
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::
+$  then  [@da @da]
--

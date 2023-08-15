# focus
an urbit interval timer. 

evenly space out time for **focus** with time for **rest**.  
receive a "**wrap up**" call for each period.  
run through as many **repititions** as you wish.

I built this to time out my work sessions, meditations, and exercises.

## demo and install
a publicaly visible version lives at [bird.howm.art/focus](https://bird.howm.art/focus).  
on urbit, anyone will be able to install %focus from **~havdys-nordus-mocwyl**.

**make your %focus app publicly visible, by running this in your urbit's dojo:* `:focus &focus-command [%public &]`

### screenshots
![urbit-timer-screenshots](https://user-images.githubusercontent.com/42229058/211255392-a66f36bd-3e17-4d0a-86d5-4f4613246a54.jpg)

### built for urbit
this app was built entirely with the hoon language for [urbit](https://urbit.org/) in participation of the 2022 end of the year [hackathon](https://encodeclub.notion.site/Encode-x-Urbit-Hackathon-27deac8200a2452ab68574d914728975).

while the backend is obviously written in hoon, the frontend is completely written in hoon as well. **focus** uses the domain-specific language [sail](https://developers.urbit.org/guides/additional/sail) to create html in concert with the [rudder](https://github.com/Fang-/suite/blob/master/lib/rudder.hoon) framework for routing & serving simple web frontends.
 

*the very helpful [sailbox](https://developers.urbit.org/guides/additional/sail) taught me much of this approach, alongside the thoroughly annotated [rudder library and examples](https://github.com/Fang-/suite/tree/master/lib/rudder).*

### this app kills 99.99% of javascript
writing *basically* in 100% hoon, is a wonderful experiece. using hoon for scripting with sail and rudder can get you really far without javascript. but there are some difficult problems to solve. hopefully there are a few decent ideas within **focus** for these sticky situations in a fullstack hoon app.

most difficult challenges
1. managing state for manipulating the pages rudder facilitates.  
   *because of the rapidly growing need for state for the frontend, I ended up nesting a larger state-p into my state-0.*  
   
3. page refreshing +on-arvo or trigged from anywhere other than an http post.  
   *for the behn wake gift of my timers to have effects I brought rudder into +on-arvo, with limited success.*
   
4. inacting animations/changes after the page load.  
   *this is where my 3 lines of javascript come in, but maybe I could have done that with css or scss.*

## wip
still building...
 - viable backend and frontend built dec 20-22
 - frontend and aesthetics crafted jan 2-6
 - submitted for the hackathon jan 8
 - finish v1.0.0 jan 19
 - finish v1.2.0 apr 19 - adding goals integration and a pause functionality
 - future: considering advanced settings for an ease-in pre-timer and a big rest for bundling multiple sessions
 
### unfortunate state changes 
anyone upgrading from v1.0.0 to v1.2.0, will experience weird changes. when focus first opens. a line will appear on the bottom of the screen, the new goals toggle will already be set to “on”, and the wrap setting will be at “50%”. 

but it's all reversable by resetting the wrap slider and turning the goals toggle off and back on. if goals isn't installed an ugly stack trace and helpful message will appear explaining how to download it.

newly installed focus apps won't experience this.
 
 
 ### paper design from dec 8

![Urbit Timer](https://user-images.githubusercontent.com/42229058/211251605-112fc2be-9594-4c06-9a5d-bc4f04e0a028.jpg)

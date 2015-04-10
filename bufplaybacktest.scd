//Buffer Playback Tests

//Basic Buffer Allocation
s.boot;
// b=Buffer.alloc(s, 10*44100, 1);
b.bufnum;
b.free;

{PlayBuf.ar(1, b.bufnum)}.play; // number of channels and buffer
[b.bufnum, b.numChannels, b.path, b.numFrames];

//Simple playback with pausing and resuming
Buffer.freeAll;

b=Buffer.read(s,"/Users/aarntz/Documents/thesis/sonivi/samples/616d6232.wav");

SynthDef(\bgtrack, { |out=0, start=0, bufnum=0, speed=0, loop=1|
        var sig = PlayBuf.ar(1,bufnum,speed*BufRateScale.kr(bufnum),start);
        Out.ar(out, Pan2.ar(sig));
}).add;

~bgtrack = Synth(\bgtrack, [\bufnum, b.bufnum]);


~bgtrack.set(\speed, 0);    // pause
~bgtrack.set(\speed, 1);    // play
~bgtrack.set(\speed, 2);
~bgtrack.free;

s.queryAllNodes;
//





//PlayBuf Stuff
(
b=Buffer.read(s,"/Users/aarntz/Documents/thesis/sonivi/samples/616d6232.wav");
b.bufnum;
SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=0, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)
	)
}).add;
)

SynthDef("bgtrack", {| out = 0, bufnum = 0 |
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1, doneAction:2)
    )
}).add;

h = Synth(\bgtrack, [ \out, 0, \bufnum, b.bufnum]);



SynthDef(\help_PlayBuf, { arg out=0, bufnum=0;
    var trig;
    trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
    )
}).play(s, [\out, 0, \bufnum, b]);




h.free;



(
t = Task({
	{Pan2.ar(PlayBuf.ar(1, b.bufnum))}.play;

     });
)

t.play;
t.pause;
t.stop;


x = Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);
x.free;




// (instrument: \playbuf).play;
// (instrument: \playbuf).pause;


//run the sound
Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);

//Use a GUI
(
var w, rateslid, trigslid, startposslid, loopslid, a;

a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);

w=Window("PlayBuf Example",Rect(10,200,300,150));

w.front;
w.view.decorator= FlowLayout(w.view.bounds);

//James' shortcut slider class
//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);

trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);

startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);

loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);

w.onClose_({a.free;});
)

s.queryAllNodes;



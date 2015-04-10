// SC - Processing through OSC

// SuperCollider patch sending or receiving OSC to/from Client
// run each line at a time by hitting enter (the little button) or
// by selecting block of code withing brackets

// SC receiving OSC from Client
// run this block first

//This code is now defunct in favor of OSCFunc and OSCdef
//modify these code examples to work with those:
s.reboot();
s.boot();
(
r = OSCFunc( { | msg, time, addr, port |
	msg.postln;
	time.postln;
	addr.postln;
	port.postln;
}, '/print' );

// when finishing, remove the OSCresponder
r.free;

// SC sending OSC messages to PythonScript
n = NetAddr("127.0.0.1", 8000); 	// ixiOSCp55 listens to 12000
n.sendMsg("/turingRun", 20); // and it's waiting for a message "/test" and 3 arguments
n.sendMsg("/tape");
n.disconnect;


// or more complex example with a little synth control

(
SynthDef(\p55synth, {arg freq= 440;
	var signal, env;
	env = EnvGen.ar(Env.perc, doneAction:2);
	signal = SinOsc.ar([freq, freq+1], 0, 0.8) * env;
	Out.ar(0, signal);
}).load(s);

g = OSCFunc( { | msg, time, addr, port |
	var freqy;
	freqy = msg[1];
	//freqy.postln;
	Synth(\p55synth, [\freq, 600 - freqy]);
	msg.postln;
}, '/test2' );

// r = OSCresponder(nil, '/test', { arg time, resp, msg;
// 	msg.postln;
// 	msg[1].postln;
// 	Synth(\p55synth, [\freq, 600 - msg[1]]);
// }).add;
)

g.free;

s.reboot();
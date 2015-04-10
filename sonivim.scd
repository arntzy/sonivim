s.reboot;
s.boot;
s.shutdown;

//Load Sampler and Global Settings
(
d= ();
a= RedDiskInSamplerGiga(s);
a.overlaps=10;
)

//Simple playback with pausing and resuming
(
// b=Buffer.read(s,"/Users/aarntz/Documents/thesis/sonivi/samples/616d6232.wav");
b=Buffer.read(s,"/Users/aarntz/Documents/thesis/sonivi/samples/awakening.wav");
SynthDef(\bgtrack, { |out=0, start=0, bufnum=0, speed=0, loop=1|
        var sig = PlayBuf.ar(1,bufnum,speed*BufRateScale.kr(bufnum), start, loop: loop);
        Out.ar(out, Pan2.ar(sig));
}).add;
~bgtrack = Synth(\bgtrack, [\bufnum, b.bufnum, \loop, 1]);
)


(
var filenames = ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '2a', '2b', '2c', '2d', '2e', '2f', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '3a', '3b', '3c', '3d', '3e', '3f', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '4a', '4b', '4c', '4d', '4e', '4f', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '5a', '5b', '5c', '5d', '5e', '5f', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '6a', '6b', '6c', '6d', '6e', '6f', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '7a', '7b', '7c', '7d', '7e', '0d', '1b', '0e', '09'];

filenames.do{|z, k|
	var midinote, pathname, key;
    midinote=k;
    key=z;
	// pathname= "/Users/aarntz/Documents/thesis/sonivi/samples/"++key++".wav";
    pathname= "/Users/aarntz/Documents/thesis/sonivi/pno/"++key++".wav";
	key= (key).asSymbol;
    d.put(midinote, key);
    a.preload(key, pathname);
};
)

(
//OSCsampler in
r = OSCFunc( { | msg, time, addr, port |
	var key;
	key = msg[1];
	a.play(key);
	msg.postln;
}, '/smplr' );

t = OSCFunc( { | msg, time, addr, port |
	var speed;
	speed = msg[1];
	~bgtrack.set(\speed, speed);
	msg.postln;
}, '/bgtrack' );
)

//free all
(
a.free;
a = nil;
b.free;
b = nil;
r.free;
r = nil;
t.free;
t = nil;
~bgtrack.free;
Buffer.freeAll;
)

//diagnostics
(
format("sampler loaded keys = %", a.loadedKeys).postln;			//report all keys that have soundfiles loaded
format("sampler overlaps = %", a.overlaps).postln;             //report the amount of overlaps set
format("~bgtrack nodeID = %", ~bgtrack.nodeID).postln;
format("All nodes = %", s.queryAllNodes).postln;
this.dump.postln;
)

//Useful Commands
(
~bgtrack.set(\speed, 0); //Pause bgtrack
)





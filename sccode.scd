s.reboot;
s.boot;
s.shutdown;

d= ();
a.free;
r.free;
a.flush(0);

//Load Sampler and Global Settings
a= RedDiskInSamplerGiga(s);
a.overlaps=10;

s.freeAll;
//Simple playback with pausing and resuming
Buffer.freeAll;
// Node.free;
b=Buffer.read(s,"/Users/aarntz/Documents/thesis/sonivi/samples/616d6232.wav");

SynthDef(\bgtrack, { |out=0, start=0, bufnum=0, speed=0, loop=1|
        var sig = PlayBuf.ar(1,bufnum,speed*BufRateScale.kr(bufnum), start, loop: loop);
        Out.ar(out, Pan2.ar(sig));
}).add;



b.bufnum;
b.free;
~bgtrack = Synth(\bgtrack, [\bufnum, b.bufnum, \loop, 1]);


//bgtrack tests and stuff
// ~bgtrack.set(\speed, 0);    // pause
// ~bgtrack.set(\speed, 1);    // play
// ~bgtrack.set(\speed, 3);
// ~bgtrack.nodeID;
// s.sendMsg(\n_set, ~bgtrack.nodeID, \speed, 1);
// s.sendMsg(\n_set, ~bgtrack.nodeID, \speed, 0);

~bgtrack.free;
s.queryAllNodes;

(
// var filenamesASCII = ['j', 'k', 'h', 'l', '0', '$', 'w', 'gg', 'b',
// 	'f','q', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 's',
// 'd', 'g', ';'];

// var filenames = ['6a', '6b', '68', '6c', '30', '24', '77', '6767', '62',
// 	'66', '71', '65', '72', '74', '79', '75', '69', '6f', '70', '73',
// '64', '67', '3b'];

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

//Settings to check on
a.loadedKeys;			//report all keys that have soundfiles loaded
a.numFrames;			//report size of preload buffer
a.overlaps;             //report the amount of overlaps set
a.voicesLeft;
a.buffers('20');
a.channels('20');

a.numBuffers;
a.play('20');
a.free;

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

//Sample Testing Area
(
a.play(\0);
a.play(\j);
a.play(\w, amp: 0.3);
a.play(\p);
)

//Begin Ambient Background Track
a.prepareForPlay(\amb, "/Users/aarntz/Documents/thesis/sonivi/samples/amb.wav".standardizePath);
a.prepareForPlay(\amb2, "/Users/aarntz/Documents/thesis/sonivi/samples/amb2.wav".standardizePath);
a.play(\amb2);
a.stop(\amb2);
a.freeKey(\amb2);
a.isPlaying(\amb2);


Tdef(\test).play;
t= a.loadedKeys;
(Tdef(\test, {
	inf.do{|i|
		a.play(t.choose);
        1.wait;
    }
}))
(Tdef(\test, {
	a.stop(\amb2);
	b= t.asArray.scramble;
    inf.do{|i|
		b.do{|x, j|
        a.play(x);
        0.5.wait;
    };
	2.wait;
	}
}))
(Tdef(\test, {
        b= t.asArray.sort;
        inf.do{|i|
                b.do{|x, j|
                        a.play(x, 0, 0.5, 0.08, amp: 0.6);
                        0.2.wait;
                };
                1.wait;
        }
}))
Tdef(\test).stop

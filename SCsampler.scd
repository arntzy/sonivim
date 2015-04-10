s.reboot;
d= ();
a.free;
r.free;
//Load Sampler and Global Settings

a= RedDiskInSamplerGiga(s);
a.overlaps=50;

//automatically load samples from a file
//Make sure to check Sample Rates!
(
var filenames = ['j', 'k', 'h', '0', '$', 'w', 'b',
'f','q', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 's',
'd', 'g', ';'];

filenames.do{|z, k|
	var midinote, pathname, key;
    midinote=k;
    key=z;
    pathname= "/Users/aarntz/Documents/thesis/sonivi/samples/"++key++".wav";
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


//OSCsampler in
r = OSCFunc( { | msg, time, addr, port |
	var key;
	key = msg[1];
	a.play(key);
	msg.postln;
}, '/smplr' );


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

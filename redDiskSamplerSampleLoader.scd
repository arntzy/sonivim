s.boot;
d= ();                                          /*for mapping midinote to filename*/
r.free
r= RedDiskInSamplerGiga(s);             /*sampler*/
(

var velocities= #[40, 96];              /*velocities to load*/
var octavesToLoad= #[2, 3];             /*how many octaves to load -- corresponding midi octave number*/
var scale= #['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
scale.postln;

/*so number of samples to load is octavesToLoad.size*12*velocities.size*/
/*lowest note C2= midi 36*/

velocities.do{|x, i|
        var tempDict= ();
        d.put(x, tempDict);
        octavesToLoad.do{|y, j|
                scale.do{|z, k|
                        var midinote, pathname, key;
                        midinote= y*12+12+k;
                        key= z++y;
                        pathname= "sounds/bosen44100/"++x++"/"++key++".aif";
                        key= (key++"_"++x).asSymbol;
                        tempDict.put(midinote, key);            /*like (45 : A2_96)*/
                        r.preload(key, pathname);
                };
        };
};
)
r.play(\C2_96, 0, 3, 1)
r.play(\D2_40, 0, 3, 1)
Tdef(\test).play
a= r.loadedKeys;
(Tdef(\test, {
        inf.do{|i|
                r.play(a.choose, 0, 0.45, 0.1);
                0.5.wait;
        }
}))
(Tdef(\test, {
        b= a.asArray.scramble;
        inf.do{|i|
                b.do{|x, j|
                        r.play(x, 0, 0.35, 0.1);
                        0.15.wait;
                };
                2.wait;
        }
}))
(Tdef(\test, {
        b= a.asArray.sort;
        inf.do{|i|
                b.do{|x, j|
                        r.play(x, 0, 0.25, 0.08, amp: 0.6);
                        0.1.wait;
                };
                1.wait;
        }
}))
Tdef(\test).stop
r.free
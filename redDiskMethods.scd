s.reboot;
a= RedDiskInSamplerGiga(s);

//-- setting up which samples to use and prepare them
a.prepareForPlay(\snd1, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
a.prepareForPlay(\snd2, "~/Documents/thesis/sonivi/samples/a11wlk01.wav".standardizePath);	//add your own soundfile
a.prepareForPlay(\snd3, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff", 44100);	//offset 44100 samples

Platform.resourceDir.postln;
//-- play
a.play(\snd1);			//play the whole soundfile
a.voicesLeft(\snd1)
a.stop(\snd1);			//stop

a.play(\snd1, 1, 0, 0.05);	//play with slow attack and quick release

a.play(\snd2);			//play another sample
a.play(\snd3);			//and another
a.play(\snd3, 0.1, 0.1, 0.1);	//very short

a.play(\snd2, loop:1);		//looping
a.stop(\snd2, 4);		//stop with 4 second fadetime

(				//start many at once
a.play(\snd1);
a.play(\snd2);
a.play(\snd3);
)
a.flush(0);			//stop all right away

a.play(\snd2);
a.play(\snd2);
a.voicesLeft(\snd2);		//check if any free voices
a.stop(\snd2, 0);
a.stop(\snd2, 0);
a.voicesLeft(\snd2);		//check if any free voices

a.loadedKeys;			//report all keys that have soundfiles loaded
a.numFrames;			//report size of preload buffer
a.overlaps;			//how many voices allowed to play simultaneously

a.length(\snd1);		//how long is the soundfile in seconds
a.channels(\snd1);		//how many channels
a.buffers(\snd1);		//access buffers for a key. one for each overlap

a.free;				//stop and clear
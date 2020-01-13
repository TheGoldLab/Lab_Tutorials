Getting a sound to play using dotsPlayable is fairly straightforward. At its core it relies on Matlab's built in audioplayer function. 

A user is not expected to create a dotsPlayable object by itself but to use one of the three sub-classes, dotsPlayableTone, dotsPlayableNote, and dotsPlayableFile. The majority of audio properties are defined within the dotsPlayable classdef, with the individual sub-classes having only a few unique properties. 

The Playables demo has a pretty good sample of the individual features that can be adjusted. However, some properties are not automatically defined so a user will need to input some properties values before a sound can play. 

Lets start with creating a simple tone. 

```
toney = dotsPlayableTone
```
You should see something like this in the command window.
```
toney = 

  dotsPlayableTone with properties:

          frequency: []
             player: []
          isAudible: 1
          intensity: 1
    sampleFrequency: 44100
      bitsPerSample: 16
           duration: []
         soundsPath: '~'
           waveform: []
               side: ''
       lastPlayTime: []
```
However, there are a few steps before a tone will be played. A user must set the frequency and duration before a tone can be played. The tone MUST be prepared before it can be played as well. If you do not set these properties you will probably see an error like this. 
```
Error using  .* 
Matrix dimensions must agree.

Error in linspace (line 31)
        y = d1 + (0:n1).*(d2 - d1)/n1;

Error in dotsPlayableTone/prepareToPlay (line 25)
            rads = linspace(0, nCycles*2*pi, nSamples);
```
These properties can be set just like any other snow dots class object.
```
toney.frequency = 500;
toney.duration = 1;
```
We can then tell dotsPlayableTone to compute the waveform to play based on the parameters given. 
```
toney.prepareToPlay;
```
Finally we can play the sound itself.
```
toney.mayPlayNow;
```
You should hear a 1 second long tone that sounds like....a tone. We can continually play the sound using mayPlayNow without having to also call prepareToPlay, but any changes made to the audio properties of the tone will not be reflected in the tone until prepareToPlay is called again. 

## dotsPlayable Properties 

isAudible- True or false property that will mute or unmute a sound when it is called to be played. The functions unMute and mute are shorthand functions to set isAudible to true or false respectively. The default value of isAudible is true.

intensity- The default is 1. Essentially how loud the sound is. It's the scale factor to apply to the waveform during playback. If you look into the sub-class sound scripts, you can see during the prepareToPlay how intensity is used to adjust the waveform. 

sampleFrequency- The frequency in Hz of sound samples stored in the waveform. Altering the frequency property in dotsPlayableTone is what you will need to do to actually change the frequency of your tone.

bitsPerSample- bit-depth of each sound sample in waveform. The bit-depth can alter the audio data type. The Matlab [Read Audio File](https://www.mathworks.com/help/matlab/ref/audioread.html) page may be worth looking at if you are really need to adjust this property. 

duration- The duration of the sound to play. 

soundsPath- This is the system path to locate the sound files used with a dotsPlayableFile object. 

waveform- The waveform is actual value of sound samples to be played back.

side- If a sound should only play on the left side or right side of a set of speakers/headphones. It expects either an empty-string (default) for playback in both ears or a string argument of 'left' or 'right'.  

## dotsPlayableFile Properties

fileName- The only extra step to read and play back an audio file is simply making sure the file is within your Matlab path and that you enter the name in correctly. If you have the resources downloaded from this git repo, than you should have Coin.wav in your files somewhere. You can simply enter
```
coiny = dotsPlayableFile;
coiny.fileName = 'Coin.wav';
coiny.prepareToPlay;
coiny.mayPlayNow;
```

isBlocking - Whether to play synchronously (true) or asynchronously. Using isBlocking = false can lead to errors because Matlab's audio player class is limited. 

## dotsPlayableNote Properties 

dotsPlayableNote is constructed using the Psychtoolbox audio player but can be used the same as the other sound functions. The difference between dotsPlayableTone and Note is that dotsPlayableNote uses an amplitude-envelop concept that causes the tone to smoothly come on and off, unlike the more abrupt onset and offset of dotsPlayableTone.

frequency- The frequency of the dotsPlayableNote can be adjusted to raise or lower the tone

waitTime- Default at 0. waitTime is simply the time, measured in second, that it takes the sound to come on.

ampenv- This is the amplitude envelope. The class will automatically create the envelop for the tone.

noise- Default at 0. The noise is a static-esq noise that plays simultaneously with the created tone. The higher the value the higher the static noise that plays along with the tone. 


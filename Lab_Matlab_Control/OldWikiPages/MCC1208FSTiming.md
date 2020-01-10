Following on my exploration about USB timing in general (USBTimingBreadcrumbs), I did some tests with the 1208FS digital IO device from Measurement Computing. These are aimed at characterizing the 1208FS itself, as well as putting mexHID through some paces with a full speed, proprietary device.

The tests are in a folder called MCCSandbox/. It lives in the Snow Dots repository along with the mexHID code. If you have Snow Dots installed already, you already have the test script in the mex/mexHID subfolder folder.

So far I've done some tests with the digital inputs and outputs. Later I plan to work with the analog inputs, too.

**Digital IO**

Tests for the digital side of the device are in MCCSandbox/MCCDigitalTiming.m.

Test 1

Test 1 does some digital IO round trips. For setting values to the device, it uses raw HID reports. For reading values from the device it uses individual input elements.

Aside
Interestingly, reports were the only way I could reliably work with the device. Only a few of the output-type elements were responsive when I tried to set their values individually. I tried setting their values in batches, using the "set multiple" or "transaction" functions of the the OS X HID API. I assumed these functions would end up generating the same kinds of reports I would generate myself for doing the "raw" report method. But the device was not responsive to them. So raw reports it is.

Similarly, the device was not responsive when I tried to read "raw" input reports. I might have been able to implement an asynchronous report handler. But this would be cumbersome and I intend to avoid it as long as possible. Fortunately, input elements are updated in the expected "interrupt" fashion, so I can just read these and queue them as I do for other devices.

Anyway back to the tests. There are a few parts to the test loop: * write a digital output to port A (an output report) * wait for a delay, d * trigger the device to send back its digital port values (an output report) * wait for a delay, d * read the value of the input element for port A

So for each iteration I get 5 interesting timestamps: pre- and post-output, pre- and post-trigger, and input value change.

I varied the delay period d in order to determine where the input value timestamps fall relative to the output setting and input setting. As d grows, and the output and trigger get farther apart, do the input value timestamps stay pegged to one report or the other.

The input value timestamps are clearly pegged to the post-trigger time. So the host only sees an update to the digital port value following an explicit triggering. This is at odds with what happens physically: I can measure a voltage change on the port with my voltmeter, regardless of whether I ever trigger an update or not.

So the input value timestamps are not very good. At best, when the input update trigger happens immediately after the new output value is set, the input timestamps will be a few miliseconds late. The post-output timestamps is probably a better estimate of when the physical voltage change occurred.

Test 2

In my previous timing tests using my HID mouse, I saw that input timestamps had a severe granularity, apparently corresponding to the "report interval" of the mouse device. The 1208FS seems to have the same "report interval". Do its input timestamps suffer from the same granularity?

The test was similar, but I added the input elements to a HID Queue instead of polling for them explicitly. The test loop did the following: * write a digital output to port A (an output report) * trigger the device to send back its digital port values (an output report) * mexHID run the CFRunLoop to update the input queue

I plotted the all the intervals between the queued input value timestamps (the "diff" of the timestamps). The granularity is about 1ms, which is good: it's a frame, not a full "report interval". But none of the intervals was less than 3ms.

This is because I can only enqueue a value change after doing two other significant transactions: setting the new value and triggering a value update. The triggering amounts to polling the device for value changes, and polling frequency, using synchronous function calls for the two transactinos, was about 4ms.

So, in this case, granularity is not a problem. The value change is reported with frame-sized granularity, soon after triggering an update. But the requirement of having to trigger the update explicitly is large and unfortunate.

And it may be moot. As in Test 1, the best estimate of when the digital IO port actually responded with a voltage is probably the post-output timestamp, not the value-change timestamp.

A different use case would be reading digital ports from an external source. It would be unfortunate to have to poll for these. I wonder if there's a way to activate interrupting behavior for the digital ports. Maybe this is what the port configuration is for, which I don't understand yet. Or maybe this was just a design choice having to do with some typical (or obvious?) digital port uses.

I expect that the analog side of the device will do interrupting behavior. The caveat there will be making sure to observe all the high-frequency samples that the device comes up with....

**Analog IO**

Tests for the digital side of the device are in MCCSandbox/MCCAnalogTiming.m.

The analog side of the device is a lot more complicated than the digital. The 1208FS is actually a composite of four devices, three of which trade off sending input reports to the host. Working out the communication with the three "helper" devices took a while, as did decoding the input sample values and assigning times to them.

But the result is nice: * Instead of reading all the raw input reports, I cache baseline byte values and enqueue byte changes just like other HID input element values changes. * I can reconstruct reports after the fact, and account for all reports by number even at high (~45kHz) sample frequencies * I can use the analog ouputs while scanning inputs and get interrupting behavior (as expected).

Test 1

Test 1 does output-input round trips. For outputs, it writes successive digital value to the output ports, using raw HID reports. For inputs it starts a scan with a raw HID report, then enqueues element value changes, which correspond to individual data bytes. It reconstructs all the raw reports after the scan is complete.

I wired up four input channels and configured them for single-ended (vs. ground) scanning, as follows: * channel 8 connects to analog output A * channel 9 connects to analog output B * channel 10 connects to the +5V terminal * channel 11 connects to the analog ground terminal

I gathered data as follows: * read baseline byte values for each of the analog input elements on each "helper" device * add the input elements to queues to record subsequent byte value changes * start scanning all input channels at 2500Hz each (10000Hz total) * write broad sweeps of output values to outputs A and B * stop scanning and reconstruct the input reports and channel sample values

As a smell test, I plotted the sequence of input sample values against the sequence of output values. It smells right. channel 8 reflects the values from output A, 9 reflects B, 10 holds steady at +5V, and 11 holds steady at 0V. Thus, I'm able to account for samples during a continuous scan and assign them to the correct channels, at the appropriate times.

But what are the "appropriate times"?. Test 2 looks at timing in more detail.

Test 2

Test 2 reuses data from Test 1. I looked more closely at out how to align samples from the 1208FS with timestamps taken on the host side. I did this in three steps: * construct a scan timeline based on the 1208FS internal clock * pick a host timestamp to estimate the origin of the scan timeline * measure the drift rate between the 1208FS clock and host clock, and correct for it

**1208FS scan timeline**
The first question was how to come up any kind of timeline at all, for samples taken during an analog scan. HID input value change timestamps are not meaningful here for a few reasons: * HID value timestamps correspond to when the host received a report, not when the device took an individual sample. All samples sent in the same report appear to have the same timestamp. * The host's report-time timestamp might be jittered, which might be confounding at high sample frequencies. * The values that change are report bytes, not sample values. And, * Samples occupy two bytes and the most and least significant bytes are likely to change at different times * Report bytes change get reused in cyclic fashion for whatever channels are being scanned. So a byte value change might mean that a byte representing a new channel, not that a channel changed value. Likewise, a channel might happen to change value in such a way that its bytes match those of another channel, allowing a real channel value change go unnoticed. * "helper" devices also get reused in cyclic fashion, taking turns sending reports to the host. The host represents reports from each device separately. So again, the cyclic reuse means that spurious value changes may be reported, and real changes might be ignored. In short, the 1208FS represents data and time in its own way, which the host doesn't know about. There's nothing in the USB or HID protocols or the OSX HID implementation to help with decoding.

But decoding aside, there is no data loss: the 1208FS sends a serial number along with each report. It's easy to detect when this value changes, so it's possible to keep track of all reports send by the "helper" devices and the raw byte value changes associated with each report. I combine all the byte change data with a baseline byte value reading taken before each scan, and get a full account of reports send from the device to the host.

Then it's a matter of extracting channel sample values from the raw bytes. I won't go into these details. But I would like to acknowledge that I got huge hints from the Psychtoolbox DaqToolbox code. I also learned a lot from my own probing of the device. Some hacks were inevitable since the 1208FS is proprietary hardware, and Measurement Computing didn't reply to my request for developer documentation (a data sheet??). I tried to keep the hacking sane and organized. It's all there in the MCCSandbox/MCC**functions.**

So from bytes I reconstructed individual samples from the various channels. I put all the samples in order. I assigned the time 0 to the very first sample. I used the scan sample rate to assign evenly-spaced times to the subsequent samples. This is my scan timeline, based on the 1208FS clock.

Host timestamp for the scan origin
The next question was how to align the scan timeline origin with the host clock. Since mexHID returns pre- and post-transaction timestamps for each USB transaction, I had two estimates of when the 1208FS began scanning: * the pre-scan timestamp (requesting the 1208FS to initiate a scan) * the post-scan timestamp (after the 1208FS acknowledged the scan request) But I didn't know beforehand which timestamp was closer or less jittered with respect to the actual, physical scan initiation.

I used the lopped-back output and input channels to try to get a handle on this. I had two estimates of when the 1208FS physically manifested each output value: * the pre-write timestamp (requesting a new voltage at output A or output B) * the post-write timestamp (after the 1208FS acknowledged the output request)

I also could detect when each voltage change was detected at the connected input channel. For each output value, I chose one input sample that was "coincident", based on nearness in time and anticipated voltage value (see the compareOutputToCoincidentInput() function of MCCAnalogTiming.m for details). These matched sample times were also estimates of output event timing, but in the 1208FS timeline, not by the host clock.

The write timestamps and sample coincident sample gave me observations of the same output events, using different clocks. Aligning them should indicate how to align the clocks. In particular, I could choose to align the origin of sample times with the pre-scan or post-scan timestamp. I could also chose to use the pre-write or post-write timestamp. Thus I had four possible pairings for reconciling matched samples with the write timestamps: * pre-scan, pre-write * pre-scan, post-write * post-scan, pre-write * post-scan, post-write I expected one of these pairings to be "best", and picking the best would allow me to pick pre-or post-scan as the origin for scan timeline.

So for each paring I constructed a sample timeline and aligned it to one of the scan timestamps. I took one of the sets of write timestamps and found "coincident" scan samples. I subtracted the same write timestamps from the coincident sample times to obtain a "coincidence interval" for each output value. I took the distribution of coincidence intervals as a measure of "goodness" of each pairing: the less spread the better.

Pairings that contained the pre-write timestamps had the widest spread of coincidence intervals. Output A also seemed to have wider-spread intervals than output B. Both may have to do with how well Matlab was synced to the USB host frames. During each pass through my test loop (in MCCAnalogTiming.m) the first thing I did was to write to output A. Since Matlab had been busy beforehand, the pre-write-A timestamp was potentially uncorrelated with the USB frames. But the post-write-A timestamp should have been correlated, since it was taken immediately after a transaction. pre-write-B followed immediately, so it may have borrowed stability from the preceding write-A transaction. Post-write-A and post-write-B should have been equally stable, and apart from an outlier, this looks to be the case.

So it seems that post-write transactions should be more stable than pre-write. I chose to align the scan timeline to the post-scan host timestamp.

**1208FS vs host clock drift**
Although they all measure seconds, any two clocks will drift apart over time. Assuming the drift has a constant rate, it's straightforward to measure the rate and correct for it.

To measure the drift between the host clock and the 1208FS clock, I used the interval between the first and last output value. The host-side write transaction timestamps provided one measurement of the interval. The 1208FS sample timeline provided another measurement. The ratio of the host measurement and the 1208FS measurement is the clock drift rate. The drift rate looked about the same regardless of which pre- or post- transaction time or which output port I used.

The 1208FS clock appeared to count slower than the host clock, by factor of .001 or about 1ms/s. This is significant! During longer tests, the clock drift dominated my "coincidence interval" measurements, causing their distributions to smear out. Correcting for expected drift at each write timestamp tightened up the distributions and accentuated the differences between pre- and post-transaction timestamps.

I expect that the clock drift I measured is specific the clocks in my particular host computer and 1208FS device. For any host and device, it should be possible to measure the drift once and incorporate the drift rate into the inital decoding of sample times.

My decoding of 1208FS channel values and sample times assumes that all data sent from the 1208FS device are reaching the host. Test 3 checks that assumption.

Test 3

During an analog scan, the 1208FS sends sample data to the host in reports, which are batches of bytes. Two of the bytes contain serial numbers, as opposed to analog data, and these serial numbers allow the us to account for reports and detect whether some reports are missing. What's more, we can use the constant number of samples per report to account for individual samples.

Thus, we can request a finite number of samples from the device and then predict the number of reports, n, that it should take to send all the samples. The host should receive exactly 1 of each report numbered from 0 through n-1.

I tested report completeness as follows: * add the input elements for each helper (including report serial number) to value-change queues * for each of several scanning frequencies ranging 1000Hz through 55kHz * request a finite number of samples * check the input queues until all reports 0 through n-1 have arrived * or until the 1208FS appears to be stuck and hasn't sent new reports for a while * compare the serial numbers of reports that arrived to the expected 0 through n-1

Completeness was good. For sample frequencies as high as ~45kHz I saw every report expected. For higher rates, especially above the nominal maximum of 50kHz, I saw only a few reports before the device appeared to stall. Thus, the 1208FS appeared to function to its specifications. The OS X USB implementation and my mexHID approach were able to handle the full range of sampling frequencies without data loss!

A note about queues, through: my test was a best-case scenario in which I read from my input queues frequently. In a real-experiment scenario there might not be possible to read from input queues as often. Thus some care might be required to match the expected rate of report arrival (dependent on scanning frequency) to the expected frequency of reading from the input queues (dependent on experiment implementation). The difference between the two should suggest an appropriate input queue depth, which can be chosen arbitrarily.
# Overcurrent Relay Coordination

####  What is this?

- This code can help performing time graded overcurrent protection on radial feeder. It assumes that relays are digital and it uses inverse characteristics. Software for educational purposes for that reason it ignores starting, operating and damage curves. It will use fixed coordination time interval which you define. It will only plot time-current characteristics for each relay. Also you can use this code to coordinate N relays.
#### How to use?

- If for example we has the following radial power system (Given load and fault currents):
> <img src="https://i.ibb.co/1v0kr64/radial-ps.png">
- Settings entered as:
> <img src="https://i.ibb.co/42cDmrh/settings.png">
- After this run the code, and it will give the settings for each relay and also plot Time-Current charactristics:
> <img src="https://i.ibb.co/86LTWcQ/relays-settings.png">
> <img src="https://i.ibb.co/W06jmh5/TC-CH.png">
- You may also note that we ignored minFault values.

#### Finally:

- This software can be useful in large radial system, but as seen it ignore practical issues. So it can be useful at least to learn the concept. I'll not update the code, if you found any make your own branch.
# AV_Motion_Discrimination_Experiment
Authors - Jackson Mayfield, Adriana Schoenhaut

Experiment code repository for Auditory and Visual motion discrimination tasks. Ramachandran Laboratory - Vanderbilt University. 

# Background
The ability to combine information from different senses into a single, coherent percept through multisensory
integration allows us to understand our sensory-rich world. Neural and behavioral responses to cross-modal
sensory stimuli often show improved performance relative to responses produced by their unimodal
counterparts1–6 (i.e. multisensory gain7,8). While we know a great deal about neural correlates of multisensory
gain for static stimuli, we lack the same level of understanding for dynamic stimuli. Addressing this gap in
knowledge is pertinent considering the ubiquity of motion in the natural environment. Given that most sources
of visual motion also produce sounds, I propose to determine the neural correlates of behavioral
multisensory gain during audiovisual (AV) motion processing in two regions of extrastriate
cortex.

Despite a long history of multisensory psychophysics studies in NHPs, no study to date has
investigated their perceptual processing of AV motion. Results from our lab have laid the groundwork for such
studies by demonstrating individual differences in modality-based cue weighting. To understand the
mechanisms underlying this behavior, I will train macaques to discriminate the direction of an auditory, visual,
or AV motion stimulus. I will then model behavioral results using Bayesian Causal Inference (BCI), formalizing
how reliability-weighted auditory and visual motion cues help determine if cues come from the same (or
different) source and should be integrated (or segregated)

# Experiment
Monkeys will be trained to perform a motion discrimination task using standard operant conditioning techniques with water or juice as a
positive reward. Eye movements will be measured using an eye tracker. In the visual version of the task, monkeys will be trained to fixate on a
fixation point. A random dot kinematogram (RDK), in which the coherence of dot motion induces the perception of visual motion, will then be displayed
while the monkey maintains fixation on the fixation point. After stimulus presentation, the fixation point and visual stimulus will be turned off while two
targets simultaneously appear to the left and right of the center. Eye movement will be required to indicate judgement of motion direction and fixate on
one of two response targets. Five visual stimulus conditions will be used: 

1. rightward direction, high coherence 
2. rightward direction, low coherence 
3. 0% coherence 
4. leftward direction, low coherence 
5. leftward direction, high coherence 

The auditory task design will be identical to those in the visual task, but with the monkey making judgments regarding the
motion direction of a pseudomotion auditory stimulus instead of an RDK stimulus. The auditory stimulus—a
broad-band white noise signal embedded in partially-correlated noise—will elicit the perception of motion by
varying the amplitude of sounds generated from speakers located left and right of center. We
will used the same five general stimulus conditions, but auditory-specific low vs. high coherence levels.

In an initial set of experiments, a wider range of motion coherences will be used to determine behavioral
threshold and low vs. high coherence levels. This will allow for auditory and visual motion signals to be
adjusted independently for each subject and modality, and calibrated such that performance will be
approximately equal between modalities for the five stimulus levels. 

In the AV condition, stimuli of both modalities will be presented together. In 80% of the trials, the direction of motion for both modalities will
be congruent or one of the two modalities will have 0% coherence motion. In these trials,
the monkey will be rewarded for choosing the overall direction of motion. In another 10% of trials the direction of motion will be incongruent between 
the two modalities. The monkey will be rewarded for all of these trials. The remaining 10% of trials (yellow cells) represent 0% coherence conditions in
which responses will be rewarded randomly.

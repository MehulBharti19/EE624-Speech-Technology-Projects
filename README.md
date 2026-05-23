# EE624: Speech Technology Course Projects

This repository contains the implementation of course projects completed for **EE624: Speech Technology** at IIT Guwahati.

---

# Course Projects

## Project 1: DTW Based Isolated Vowel Recognition

### Objective
Perform isolated vowel recognition using Dynamic Time Warping (DTW).

### Tasks Performed
- Recorded 25 utterances each for:
  - English digits (0–9)
  - Vowels (a, e, i, o, u)
  - Given sentence:
  
  > "I'm registered with speech technology course and recording this data for the course project"

- Audio recorded using:
  - Audacity
  - PCM format
  - 16 kHz sampling frequency
  - 16-bit precision

- Computed 39-dimensional MFCC features:
  - Static MFCC
  - Delta MFCC
  - Delta-Delta MFCC

- Implemented:
  - DTW score computation
  - DTW alignment visualization
  - Similar and dissimilar utterance comparison

### Tools Used
- MATLAB
- Audacity

---

## Project 2: GMM Based Isolated Digit Recognition

### Objective
Perform isolated digit recognition using Gaussian Mixture Models (GMM).

### Tasks Performed
- Computed 39-dimensional MFCC features
- Trained digit-wise GMM models with:
  - 16 mixtures
  - 32 mixtures
- Performed maximum likelihood based recognition
- Generated confusion matrix for evaluation

### Tools Used
- MATLAB

---

## Project 3: Context Dependent Subword ASR using Kaldi Toolkit

---

# (A) GMM-HMM Based ASR System

### Tasks Performed
- Computed MFCC features for continuous speech database
- Trained:
  - Monophone HMM models
  - Triphone HMM models
- Built tied-state system with 8 Gaussians/state
- Trained bigram language model
- Performed:
  - Viterbi decoding
  - ASR evaluation

### Tools Used
- Kaldi Toolkit
- Linux / WSL

---

# (B) Hybrid DNN-HMM ASR System

### Tasks Performed
- Trained feed-forward neural network
- Estimated triphone posterior probabilities
- Performed Viterbi decoding using bigram LM
- Evaluated ASR performance

### Tools Used
- Kaldi Toolkit
- DNN-HMM Hybrid Architecture

---

# Technologies Used

- MATLAB
- Kaldi Toolkit
- Linux / WSL
- Audacity
- MFCC Feature Extraction
- DTW
- GMM
- HMM
- DNN-HMM Hybrid ASR

---

# Repository Structure

```bash
Speech_Assignment/
│
├── project_3/
├── speech_proj1_220108036/
├── speech_proj2_220108036/
└── README.md
```

---

# Author

**Mehul Bharti**  
IIT Guwahati

# metronome-paper [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) 

LaTeX and figures for the preprint 'Metronome: tracing variation in poetic meters via local sequence alignment'.

[(slightly outdated) poster summarizing the project](poster/metronome_poster.pdf "The Poster")

The compiled [preprint](paper/metronome.pdf) is also included.

LaTeX 'ceur' style modified from the CEUR Workshop [template](paper/ceurart.cls)
(see copyrights etc)

The Version Of Record has now been published (Open Access) with the journal 
Computational Humanities Research, DOI: [10.1017/chr.2025.1](https://doi.org/10.1017/chr.2025.1),
and should be read/cited in preference to the preprint.

## ABSTRACT

All poetic forms come from somewhere. Prosodic templates can be copied for
generations, altered by individuals, imported from foreign traditions, or
fundamentally changed under the pressures of language evolution. Yet these
relationships are notoriously difficult to trace across languages and times.
This paper introduces an unsupervised method for detecting structural
similarities in poems using local sequence alignment. The method relies on
encoding poetic texts as strings of prosodic features using a four-letter
alphabet; these sequences are then aligned to derive a distance measure based on
weighted symbol (mis)matches. Local alignment allows poems to be clustered
according to emergent properties of their underlying prosodic patterns. We
evaluate method performance on a meter recognition tasks against strong
baselines and show its potential for cross-lingual and historical research using
three short case studies: 1) mutations in quantitative meter in classical Latin,
2) European diffusion of the Renaissance hendecasyllable, and  3) comparative
alignment of modern meters in 18--19th century Czech, German and Russian. We
release an implementation of the algorithm as a Python package with an open
license.

## Reproduction Instructions

This repository contains a list of frozen versions which you can use to install the exact module versions that were used
to produce the various analyses and figure material for the preprint. This won't keep it reproducible forever, but it's
a start.

1. Clone this repository
    ```
    cd /path/to/clone/into
    git clone https://github.com/bnagy/metronome-paper
    ```
2. Create and activate a new Python virtual environment
    ```
    python -m venv /path/to/metronome-venv
    source /path/to/metronome-venv/bin/activate
    ```
3. Install the requirements
    ```
    pip install -r metronome-paper/repro/frozenvers.txt
    ```
4. Run the ipython notebooks from [the repro directory](/repro) while the venv is activated

### R Environment

To reproduce the figures on your own machine you will also need a working R environment. Hopefully the data
visualisation is not as dependent on specific versions as the analysis and clustering code, but just in case, the R
`sessionInfo()` for each notebook is included at the end.

## Citation

If you are also playing the Fun Academia Game, please cite to help us refill our Academia
Hearts ❤️❤️❤️♡♡. 

```
@article{Nagy_Šeļa_De Sisto_Plecháč_2025, 
    title={Metronome: tracing variation in poetic meters via local sequence alignment},
    volume={1},
    DOI={10.1017/chr.2025.1},
    journal={Computational Humanities Research},
    author={Nagy, Ben and Šeļa, Artjoms and De Sisto, Mirella and Plecháč, Petr},
    year={2025},
    pages={e1}
}

```


## LICENSE

CC-BY 4.0 (see LICENSE.txt)


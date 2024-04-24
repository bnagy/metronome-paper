# metronome-paper [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) 

LaTeX and figures for the preprint 'Metronome: tracing variation in poetic meters via local sequence alignment'.

[(slightly outdated) poster summarizing the project](poster/metronome_poster.pdf "The Poster")

The compiled [preprint](paper/metronome.pdf) is also included.

Further information will be added if the paper is accepted
for publication.

*WARNING* This is a preprint, which has not been peer reviewed. Any final paper
will almost certainly include changes, which can sometimes be quite substantial.
The results listed are also subject to change. 

LaTeX 'ceur' style modified from the CEUR Workshop [template](paper/ceurart.cls)
(see copyrights etc)

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

This repository contains a list of frozen versions which you can use to install 
the exact module versions that were used to produce the preprint. This won't 
keep it reproducible forever, but it's a start.

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
    pip install -r /path/to/clone/into/metronome-paper/repro/frozenvers.txt
    ```
4. Run the ipython notebooks from [the repro directory](/repro) while the venv is activated

### TODO - Instructions Coming Soon

To reproduce the actual figures, you will also need a working R environment, with a bunch of packages installed...

## Citation

If you are also playing the Fun Academia Game, please cite to help us refill our Academia
Hearts ❤️❤️❤️♡♡. 

```
@article{nagy_etal_metronome,
    author          = "Ben Nagy and Artjoms Šeļa and Mirella {De Sisto} and Petr Plecháč",
    title           = "(Preprint) {M}etronome: tracing variation in poetic meters via local sequence alignment",
    year            = "2024",
    publisher       = {github},
    version         = {v1.0.0},
    howpublished    = "\url{https://github.com/bnagy/metronome-paper}"
}
```

## LICENSE

CC-BY 4.0 (see LICENSE.txt)


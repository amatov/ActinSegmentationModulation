## Actin Segmentation Modulation

The Matlab code I wrote to compute speckle modulation.

## Quick start

This repository implements speckle modulation computation for
fluorescent speckle microscopy image data in Matlab. See
[DEPENDENCIES.md](DEPENDENCIES.md) for the Image Processing Toolbox
requirement.

## Repository contents

- `getModulation.m` -- the main function; computes the number of
  speckles in a region of interest and their mean modulation.
- `fsmPrepScaleSpace.m`, `fsmPrepSubstructMaxima.m`,
  `fsmPrepMainSecondarySpeckles.m`, `fsmPrepCheckDistance.m`,
  `fsmPrepCheckInfo.m`, `fsmPrepConfirmSpeckles.m` -- scale-space
  speckle detection.
- `batch.m`, `candsRoi.m`, `prepareRowData.m`, `selectRectangle.m`,
  `selectRegion.m`, `Gauss2D1.m` -- supporting utilities.
- [`gui/`](gui/) -- a screenshot of the fsmDetection GUI.
- [`results/`](results/) -- a speckle density example output.
- **License:** see [LICENSE](LICENSE) -- research/educational use.

## About

My work on speckle modulation for the publication:

Mike Adams, Alex Matov, Daphne Yarar, Steph Gupton, Gaudy Danuser, Clare Waterman "Signal Analysis of Total Internal Reflection Fluorescent Speckle Microscopy and Wide-Field Epi-Fluorescence FSM of the Actin Cytoskeleton and Focal Adhesions in Living Cells" (2004).

https://researchgate.net/publication/8204587_Signal_analysis_of_total_internal_reflection_fluorescent_speckle_microscopy_TIR-FSM_and_wide-field_epi-fluorescence_FSM_of_the_actin_cytoskeleton_and_focal_adhesions_in_living_cells


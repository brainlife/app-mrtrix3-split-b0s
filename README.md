<h1 align="center">Split DWI volumes with MRtrix3</h1>

<p align="center">
  A single b-value shell, or the b0 and diffusion-weighted volumes as separate datasets, extracted from a DWI with MRtrix3 dwiextract.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.263"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.263-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `v1.0`, is the brainlife.io App Extract b0 images from DWI** ([doi:10.25663/brainlife.app.263](https://doi.org/10.25663/brainlife.app.263)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Splits a DWI into its b=0 volumes and its diffusion-weighted volumes with MRtrix3 dwiextract, outputting each as a separate DWI with matching bvals and bvecs.**

Runs MRtrix3 dwiextract with -bzero and with -no_bzero to write two DWI datasets with exported FSL gradient files. Use it when a downstream App needs only the b0 volumes (for example for registration or distortion correction) or only the diffusion-weighted volumes. Needs a DWI with bvals and bvecs that contains b=0 volumes. Utility App.

| | |
|---|---|
| **Inputs** | `neuro/dwi` |
| **Outputs** | `neuro/dwi` ×2 |
| **Container** | `brainlife/mrtrix3:3.0.0` |
| **Resources** | 8 CPUs · 20 GB memory · 0.5 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.263](https://doi.org/10.25663/brainlife.app.263) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | Diffusion-weighted image with bvecs and bvals. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | DWI containing only the diffusion-weighted (non-b0) volumes, with matching bvals and bvecs. |
| `nodif` | `neuro/dwi` | DWI containing only the b=0 volumes, with matching bvals and bvecs. |

<!-- brainlife-app:end -->

## Versions on brainlife.io

Two Apps are built from this repository, each from its own branch.

| App | Branch | Run it | Status |
|---|---|---|---|
| Extract shell from DWI image | [`extract-shell-v1.0`](https://github.com/brainlife/app-mrtrix3-split-b0s/tree/extract-shell-v1.0) | [doi:10.25663/brainlife.app.475](https://doi.org/10.25663/brainlife.app.475) | current |
| **Extract b0 images from DWI** (this branch) | [`v1.0`](https://github.com/brainlife/app-mrtrix3-split-b0s/tree/v1.0) | [doi:10.25663/brainlife.app.263](https://doi.org/10.25663/brainlife.app.263) | current |

## Running the App

### On brainlife.io

Choose a `neuro/dwi` dataset (with bvals and bvecs) from your project, set the options and press **Execute**.

- **Extract shell from DWI image** ([doi:10.25663/brainlife.app.475](https://doi.org/10.25663/brainlife.app.475)) runs `dwiextract -shell` and writes a single-shell `neuro/dwi` dataset tagged `single_shell`. Use it to reduce multi-shell data to one shell for models or Apps that require single-shell input.
  - **`shell`**: the b-value of the shell to extract. The DWI must contain this shell.
  - **`with_bzero`** (default `true`): also keep the b=0 volumes (`-shell 0,<shell>`). If false, they are excluded.
- **Extract b0 images from DWI** ([doi:10.25663/brainlife.app.263](https://doi.org/10.25663/brainlife.app.263)) runs `dwiextract -bzero` and `dwiextract -no_bzero` and writes two `neuro/dwi` datasets: the b=0 volumes (tagged `b0`) and the diffusion-weighted volumes (tagged `non_b0`). Use it when a downstream App needs only the b0 volumes (for example for registration or distortion correction) or only the diffusion-weighted ones. The DWI must contain b=0 volumes.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The Apps run in the `brainlife/mrtrix3:3.0.0` container.

1. Clone this repository and check out the App you want (`git checkout extract-shell-v1.0` or `git checkout v1.0`).
2. Create `config.json` with the paths to your inputs. For shell extraction (see `config.json.sample` on that branch):

   ```json
   {
       "dwi": "/input/dwi/dwi.nii.gz",
       "bvecs": "/input/dwi/dwi.bvecs",
       "bvals": "/input/dwi/dwi.bvals",
       "shell": 2000,
       "with_bzero": false
   }
   ```

   For b0 extraction, only `dwi`, `bvecs` and `bvals` are needed.

3. Run the App:

   ```bash
   ./main
   ```

## Outputs

Shell extraction:

```text
dwi/
├── dwi.nii.gz    volumes of the requested shell (and the b=0 volumes if with_bzero)
├── dwi.bvecs
└── dwi.bvals
```

b0 extraction:

```text
nodif/            b=0 volumes: dwi.nii.gz, dwi.bvecs, dwi.bvals
dwi/              diffusion-weighted volumes: dwi.nii.gz, dwi.bvecs, dwi.bvals
```

## Troubleshooting

- **`failed`**: `dwi/dwi.nii.gz` was not produced by `dwiextract`. Check that the bvals and bvecs match the DWI and, for shell extraction, that the requested shell exists in the bvals.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Tournier J-D, Smith RE, Raffelt D, Tabbara R, Dhollander T, Pietsch M, Christiaens D, Jeurissen B, Yeh C-H, Connelly A. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019).
- Extract b0 images from DWI. brainlife.io App. [doi:10.25663/brainlife.app.263](https://doi.org/10.25663/brainlife.app.263)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

MIT (see the `LICENSE` file on the App branches, for example [`extract-shell-v1.0`](https://github.com/brainlife/app-mrtrix3-split-b0s/blob/extract-shell-v1.0/LICENSE)). MRtrix3 is distributed under the [Mozilla Public License 2.0](https://www.mrtrix.org/).

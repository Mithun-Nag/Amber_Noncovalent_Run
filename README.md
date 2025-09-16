# 🧪 Amber Noncovalent Ligand–Protein MD Run (6ONJ + Rosiglitazone)

This repository contains a **Jupyter Notebook workflow** for setting up and running a  
fully solvated **ligand–protein molecular dynamics simulation** of the PPARγ LBD (PDB: 6ONJ)  
with **Rosiglitazone (BRL)** as the bound ligand using **Amber 24** and **AmberTools 25**.

---

## 📂 Contents

- **Amber_6ONJ_BRL_Run.ipynb** – End-to-end workflow for:
  - Ligand preparation & parameterization  
  - Protein + ligand system assembly in LEaP  
  - Solvation & ion neutralization  
  - Multi-stage minimization & equilibration  
  - Automated production MD with `production.pl`

This is your **main file** – open it in Jupyter and follow step by step.

---

## 🏗️ System Setup

- **Software:** Amber 24 + AmberTools 25  
- **System:** PPARγ LBD (6ONJ) with Rosiglitazone (BRL) docked in the binding pocket  
- **Force Field:** ff14SB for protein, GAFF2 for ligand  
- **Environment:** Designed for **ACCRE (Vanderbilt University HPC cluster)** but can be adapted to:
  - Any HPC cluster (adjust `module load` or `#SBATCH` settings)
  - Local AMBER installation (just source your `amber.sh` file)

> **Important:**  
> On ACCRE, the notebook loads the required Amber modules.  
> On other systems:
> - Adjust the `module load` lines to match your environment  
> - If modules aren’t available, source Amber manually at the top of the notebook:
> ```bash
> source /path/to/amber.sh
> ```

---

## 🧩 Ligand Preparation

- The **BRL (Rosiglitazone)** ligand is extracted or downloaded separately and protonated.  
- Converted into a clean PDB with `pdb4amber`.  
- Parameterized using **Antechamber** and **parmchk2** to produce `.mol2` and `.frcmod` files.  
- Combined with the protein in `tleap.in` to generate solvated, neutralized AMBER topology/coordinate files.

---

## 📝 Pre-processing Tips

Before running the workflow:
- Check your protein for missing loops or residues and repair if necessary.  
- Preprocess your structure (correct protonation states) and use the [H++ server](http://biophysics.cs.vt.edu/H++/)  
  to generate a `.pqr` file for proper protonation.

Use this processed structure + ligand parameters as input to **LEaP** to generate a fully prepared system.

---

## 🏃 Minimization, Equilibration & Production

- **Minimization:** Multi-stage restrained → unrestrained energy minimization to relax solvent and protein.
- **Equilibration:** NVT (constant volume) and NPT (constant pressure) runs to stabilize temperature and density.
- **Production:**  
  Automated long-timescale MD using `production.pl`:
  - Runs in **100 ns chunks** (can be extended for μs-scale simulations)
  - Continues seamlessly from the last restart file

Edit `production.pl` as needed to adjust number of chunks, total simulation time, and file naming.

---

## 🖥️ HPC Execution

The repository includes a SLURM submission script example for ACCRE.  
If using a different HPC system:
- Update `#SBATCH` lines to match your scheduler (partition, GPU request, account).  
- Remove `module load` lines if not needed and source your Amber environment manually.  
- Submit using:
```bash
sbatch 6ONJ_submit_slurm

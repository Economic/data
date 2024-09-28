# README

This repository produces .csv files from the [EPI State of Working America Data Library](https://data.epi.org) for data users to download in bulk.

The .csv files are served at <https://economic.github.io/data/>.

## Building this site and the data

To package the data into .csv files and build this site you will need 

* R and the installed packages in `packages.R`
* the current copy of the data produced by the repo [here](https://github.com/Economic/dashboard_data).
* to set the environment variable `DASHBOARD_DATA_DIR` in your .Renviron to point to the .parquet files in the `data_outputs/release` directory of your local copy of the above repo.

Then produce the data and generate the site with `tar_make()`.

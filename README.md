# README

This repository produces .csv files from the [EPI State of Working America Data Library](https://data.epi.org) for data users to download in bulk.

The .csv files are served at <https://economic.github.io/data/>.

## Building this site and the data

To package the data into .csv files and build this site you will need 

* R and the installed packages in `packages.R`
* the current copy of the data produced by the repo [here](https://github.com/Economic/dashboard_data).
* to set the environment variable `DASHBOARD_DATA_DIR` in your .Renviron to point to the .parquet files in the `data_outputs/release` directory of your local copy of the above repo.

Then produce the data and generate the site with `tar_make()`.

## Publishing a new data release

`tar_make()` writes the zipped data to `release/epi_swa_data_library.zip`. To
publish it as a GitHub release (creating the tag + release and uploading the
zip), run:

```sh
./make_release.sh
```

By default this tags the release with the `data_release_version` value in
`_targets.R`, so update that value before building. You can also pass a version
explicitly, e.g. `./make_release.sh 2026.7.16`. Re-running overwrites the
existing asset, so it is safe to run again.

The release tag points at the latest commit on the remote's default branch, so
push your commit before publishing if you want them to match.

One-time setup: install the [GitHub CLI](https://cli.github.com), then run
`gh auth login` once to authenticate.

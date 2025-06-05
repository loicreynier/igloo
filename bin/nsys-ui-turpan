#!/usr/bin/env bash

module -s purge
module -s load nvidia
module -s load nvhpc/25.3

"${NVHPC_ROOT}"/profilers/Nsight_Systems/host-linux-x64/nsys-ui.vglrun.wrapper
rm -rv "$HOME/NVIDIA Nsight Systems"

# debugging
set -x

# load variables
source "/etc/libvirt/hooks/kvm.conf"

# stop display manager
systemctl stop sddm.service

# Avoid race condition
sleep 10

systemctl set-property --runtime -- user.slice AllowedCPUs=0,6
systemctl set-property --runtime -- system.slice AllowedCPUs=0,6
systemctl set-property --runtime -- init.scope AllowedCPUs=0,6

cpupower frequency-set -g performance

modprobe -r amdgpu
modprobe -r gpu_sched
modprobe -r ttm
modprobe -r drm_kms_helper
modprobe -r i2c_algo_bit
modprobe -r drm
modprobe -r snd_hda_intel

# unbind gpu
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

#rtcwake -m mem -s 5

# load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

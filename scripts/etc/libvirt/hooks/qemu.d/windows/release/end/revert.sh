# Debug
set -x

# Load variables
source "/etc/libvirt/hooks/kvm.conf"

# Unload all the vfio modules
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Rebind GPU
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

rtcwake -m mem -s 5

# load AMD
modprobe  amdgpu
modprobe  gpu_sched
modprobe  ttm
modprobe  drm_kms_helper
modprobe  i2c_algo_bit
modprobe  drm
modprobe  snd_hda_intel

systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
systemctl set-property --runtime -- init.scope AllowedCPUs=0-11

cpupower frequency-set -g ondemand

# Restart Display service
systemctl start sddm.service

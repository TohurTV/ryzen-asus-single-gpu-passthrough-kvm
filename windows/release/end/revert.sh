# Debug
set -x

# Load variables
source "/etc/libvirt/hooks/kvm.conf"

# Rebind GPU
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

rtcwake -m mem -s 5

# load AMD
modprobe amdgpu
modprobe drm_kms_helper
modprobe drm
modprobe snd_hda_intel

systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
systemctl set-property --runtime -- init.scope AllowedCPUs=0-11

# Restart Display service
systemctl start sddm.service

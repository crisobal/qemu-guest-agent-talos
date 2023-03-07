[![build](https://github.com/crisobal/qemu-guest-agent-talos/actions/workflows/build.yaml/badge.svg)](https://github.com/crisobal/qemu-guest-agent-talos/actions/workflows/build.yaml)

# Motivation
Virtual machines running on proxmox should have the qemu-guest-agent installed as it improves the way virtual machines are restarted as it does not simply rely on virtualized ACPI commands. Additionally `qemu-guest-agent` provides information like network addresses. Talos linux does not feature the `qemu-quest-agent`.

# Description
The `qemu-guest-agent` can run as daemonset in kubernetes but id does not allow to reboot or shutdown a node when using e.g. proxmox as infrastructure. As proxmox sends all the machine run state events like reboot and shutdown to the agent the daemon pod must be capable to restart the host. This can be achieved by using `talosctl` to restart the host node. For `talsoctl` talos config is required to have the api access to restart the host node.

# Prerequisits

## Enable Guest Agent for node vm

Qemu / KVM must have the guest agent enabled for node virtual machine. In Proxmox you find this setting under virtual machine options.


## Secret with talosconfig

To have the `talosctl` fully functional you need a talos config. This config must be injected either as secret or as service account. The advantage of a service account is, that you do not need to create the config itself. Unfortunately the privileges required to reboot or shutdown a node is `os:admin`. As talos config only allows setting the allowed permissions (`os:read`, `os:admin`) but lacks a way to set this per namespace, this option is not recommended. If you need the talos config only in the `qemu-guest-agent` namespace it would be ok to grant os:admin for this namespace, but for arbitrary namespaces `os:read` is already more than enough.
If you want the version with the service account use the `qemu-guest-agent-with-sa.yaml`. Ensure that you have the right permissions granted in your node talos machine config (machine.features.kubernetesTalosAPIAccess). 

Otherwise just create the secret using:

```
k create secret -n qemu-guest-agent generic talosconfig --from-file=config=<path to your config>
```

## Admission controller security
As the container runs as root and uses a hostFolder mount for the virtio device, it required either the PodSecurity being set very low or better switch it of for the `qemu-quest-agent` namespace.
```
            admissionControl:
            - name: PodSecurity
              configuration:
                apiVersion: pod-security.admission.config.k8s.io/v1alpha1
                defaults:
                    audit: restricted
                    audit-version: latest
                    enforce: baseline
                    enforce-version: latest
                    warn: restricted
                    warn-version: latest
                exemptions:
                    namespaces:
                        - kube-system
                        - qemu-guest-agent
                    runtimeClasses: []
                    usernames: []
                kind: PodSecurityConfiguratio
```

Set this in your control plane config using `talosctl`.


## Pull Secret (only for private registries)
-----------
Create image pull secret with your docker or podman `auth.json` / `client.json`. This is only required in case you pull from a private registry

```
kubectl create secret generic regcred     \
   --from-file=.dockerconfigjson=/run/user/.../containers/auth.json \
   --type=kubernetes.io/dockerconfigjson --namespace qemu-guest-agent
 ```


# Installation 

Install using:
```
kubectl create -f qemu-ga-talos.yaml
```

Uninstall using:
```
kubectl delete -f qemu-ga-talos.yaml
```

# License and Acknowledgement
This code is provided under the BSD-3 license.

The following external dependencies are used:
- alpine Linux as base for container
- `qemu-guest-agent` inside the container
- `talosctl` to talk to the talos host

= Description
The qemu-geust-agent can run as daemonset in kubernetes. As proxmox sends allthe machine run state events like reboot and shutdown to the agent the daemon pod must be capable to restart the host. This can be achieved by using talosctl to restart the host node. For talsoctl talos config is required to have the api access to restart the host node.

== Prerequisits

=== Enable Guest Agent for node vm
Qemu / KVM must have the guest agent enabled for node virtual machine. In Proxmox this is und virtual machine options.

=== Secret with talosconfig
To have the talosctl funtional you need a config. This config must be injected either as secret or as service account. The advantage of a service account is, that you do not need to create the config itself. Unfortunately the privilege required to reboot or shutdown a node is os:admin. The talos config allows setting the allowed permissions (os:read, os:admin) but lacks a way to set this per namespace. If you need the talos config only in the qemu-guest-agent namespace it would be ok to grand os:admin for this namespace, but for arbitrary namespaces os:read is already more enough.
If you want the version with the service account use the qemu-guest-agent-with-sa.yaml. Ensure that you have the right permissions granted in your node talos machine config (machine.features.kubernetesTalosAPIAccess). 

Otherwhise jusst create the secret using:

> k create secret -n qemu-guest-agent generic talosconfig --from-file=config=<path to your config>

=== Pull Secret 
Create image pull secret with your docker or podman auth.json / client.json

> kubectl create secret generic regcred     \
    --from-file=.dockerconfigjson=/run/user/1001/containers/auth.json \
    --type=kubernetes.io/dockerconfigjson --namespace qemu-guest-agent

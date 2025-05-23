#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

# https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512
cilium install -f etc/cilium-config.yaml --version 1.17.4
cilium status --wait

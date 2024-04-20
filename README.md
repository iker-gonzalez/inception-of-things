# Inception-of-Things (IoT)

## Summary
This document serves as a System Administration exercise focused on Kubernetes (K3s and K3d) and Vagrant. Participants will gain hands-on experience setting up virtual machines, deploying applications, and using container orchestration tools.

## Preamble
This project is a minimal introduction to Kubernetes, designed to deepen understanding through practical exercises using K3s, K3d, and Vagrant.

## Introduction
The project aims to:
- Set up a personal virtual machine with Vagrant and a chosen distribution.
- Implement Kubernetes using K3s and K3d.
- Deploy applications using Kubernetes.

## Mandatory Part

### Part 1: K3s and Vagrant
- Set up two virtual machines with Vagrant.
- Install K3s on both machines, configuring one as a controller and the other as an agent.

### Part 2: K3s and Three Simple Applications
- Deploy three web applications on a single virtual machine using K3s.
- Implement routing based on the HOST header to display different applications.

### Part 3: K3d and Argo CD
- Install K3d and Docker.
- Create two namespaces: one for Argo CD and another for a development application.
- Deploy an application using Argo CD from a public GitHub repository.
#!/bin/bash

minikube stop
minikube delete
echo "Minikube stopped and deleted, registry proxy removed."

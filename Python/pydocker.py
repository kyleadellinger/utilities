#!/usr/bin/env python3

import docker

# these are simply quick notes

def run_ct(*,
        image: str,
        docker_client: docker.client.DockerClient = None,
        *args,
        **kwargs):
    if not docker_client:
        client = docker.from_env()
    else:
        client = docker_client

    print(client.containers.run(image, *args))
    return

def list_cts(docker_client: docker.client.DockerClient = None):
    if not docker_client:
        client = docker.from_env()
    else:
        client = docker_client
    for container in client.containers.list():
        print(container.id)
    return

def list_images():
    client = docker.from_env()
    for image in client.images.list():
        print(image.id)
    return

def stop_running_cts(docker_client: docker.client.DockerClient = None):
    if not docker_client:
        client = docker.from_env()
    else:
        client = docker_client
    for container in client.containers.list():
        container.stop()
    return


# gazebo_ionic_docker
Docker setup for running gazebo ionic

## To Run
First, build the docker image
```bash
docker-compose build
```

Give the docker container access to the X server
```bash
xhost +local:root
```

When you're done, revoke access to the X server. This also happens automatically when you restart your computer.
```bash
xhost -local:root
```

Then, run the docker container
```bash
docker-compose run --rn gazebo-ionic
```


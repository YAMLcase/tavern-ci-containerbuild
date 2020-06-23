# Tavern-Ci Container Builder

This is a docker container for the tavern-ci project.
Tavern-ci is based on py-test.

https://github.com/taverntesting/tavern

## Usage


```
docker run \
  --rm \
  -it \
  --user=$(id -u):$(id -g) \
  -v ${PWD}:/data \
  --env-file <(env | grep -P '^CI_' ) \
  -e PYTHONPATH=/data pixpan/tavern-ci:dev \
  tavern-ci test_setup.tavern.yaml
```

`--env-file <(env | grep -P '^CI_' )` - This will pull in any environment variables starting with "CI_"

# A docker image for Rserve

This image can be used to run R remotely using [Rserve](https://www.rforge.net/Rserve/)


```
docker build -t rserve .
```

```
docker run --rm -it -v ${PWD}/.packages:/localdata/packages rserve
```

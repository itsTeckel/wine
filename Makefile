build:
	docker build -t itsteckel/wine:latest .

push:
	docker push itsteckel/wine:latest

pull:
	docker image pull itsteckel/wine:latest

run:
	-mkdir volume
	-docker stop wine
	-docker rm wine
	docker run --name wine -it \
	-d itsteckel/wine:latest /bin/bash
	docker exec -it wine /bin/bash

clean:
	docker system prune


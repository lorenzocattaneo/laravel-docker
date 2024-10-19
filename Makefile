8.3:
	docker buildx build -f ./8.3/Dockerfile -t lorenzocattaneo/laravel:8.3 .

8.3-dev:
	docker buildx build -f ./8.3/dev/Dockerfile -t lorenzocattaneo/laravel:8.3-dev .
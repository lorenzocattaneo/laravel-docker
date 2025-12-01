82:
	docker buildx build -f ./8.2/Dockerfile -t lorenzocattaneo/laravel:8.2 . --load

82-dev:
	docker buildx build -f ./8.2/dev/Dockerfile -t lorenzocattaneo/laravel:8.2-dev . --load

83:
	docker buildx build -f ./8.3/Dockerfile -t lorenzocattaneo/laravel:8.3 . --load

83-dev:
	docker buildx build -f ./8.3/dev/Dockerfile -t lorenzocattaneo/laravel:8.3-dev . --load

84:
	docker buildx build -f ./8.4/Dockerfile -t lorenzocattaneo/laravel:8.4 . --load

84-dev:
	docker buildx build -f ./8.4/dev/Dockerfile -t lorenzocattaneo/laravel:8.4-dev . --load

85:
	docker buildx build -f ./8.5/Dockerfile -t lorenzocattaneo/laravel:8.5 . --load

85-dev:
	docker buildx build -f ./8.5/dev/Dockerfile -t lorenzocattaneo/laravel:8.5-dev . --load



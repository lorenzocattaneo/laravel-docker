d.update:
	@echo "⏳ Updating images. Please wait..."
	@docker compose pull
	@echo "Images updated. Restarting..."
	@$(MAKE) d.run

d.run:
	@echo "⏳ Starting app. Please wait..."
	@docker compose up -d --force-recreate
	@echo "App started. Connecting a shell to docker container..."
	@sleep .5
	@$(MAKE) d.shell
	@$(MAKE) d.down

d.down:
	@echo "⚠️ Stopping app. Please wait..."
	@docker compose down
	@echo "App stopped. Goodbye ✋"

d.shell:
	@docker compose exec -it app bash -c "echo 'Shell connected 🚀' && echo 'You can run \"exit\" to close this shell' && bash"
	@echo "Shell session terminated!"

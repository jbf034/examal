
bash_server:
		@docker-compose exec main bash -lc "bash"

dev_server:
		@docker-compose exec main bash -lc "bundle exec rails s -b 0.0.0.0 -P /tmp/app.pid"


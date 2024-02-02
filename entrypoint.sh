#!/bin/bash

# Run rails by default if sidekiq is specified
if [ -z "$RUN_RAILS" ] && [ -z "$RUN_SIDEKIQ" ]; then
	RUN_RAILS=true
	echo "⚠️ RUN_RAILS and RUN_SIDEKIQ are not set, defaulting to RUN_RAILS=true"
fi

if [ "$QUEUE_ADAPTER" != "sidekiq" ]; then
	RUN_SIDEKIQ=false
	echo "⚠️ Sidekiq is disabled because QUEUE_ADAPTER is not set to sidekiq"
fi

# ensure booleans
if [ "$RUN_RAILS" == "true" ] || [ "$RUN_RAILS" == "1" ]; then
	RUN_RAILS=true
else
	RUN_RAILS=false
fi
if [ "$RUN_SIDEKIQ" == "true" ] || [ "$RUN_SIDEKIQ" == "1" ]; then
	RUN_SIDEKIQ=true
else
	RUN_SIDEKIQ=false
fi

if [ "$RUN_RAILS" == "true" ]; then
	echo "✅ Running Rails"
fi

if [ "$RUN_SIDEKIQ" == "true" ]; then
	echo "✅ Running Sidekiq"
fi

export RUN_RAILS
export RUN_SIDEKIQ

# Check all the gems are installed or fails.
bundle check
if [ $? -ne 0 ]; then
	echo "❌ Gems in Gemfile are not installed, aborting..."
	exit 1
else
	echo "✅ Gems in Gemfile are installed"
fi

# if no database, run setup
if [ -z "$SKIP_DATABASE_SETUP" ]; then
	bundle exec rails db:setup
else
	echo "⚠️ Skipping database setup"
fi

# Check no migrations are pending migrations
if [ -z "$SKIP_MIGRATIONS" ]; then
	bundle exec rails db:migrate
else
	echo "⚠️ Skipping migrations"
fi

echo "✅ Migrations are all up"

echo "🚀 $@"
exec "$@"
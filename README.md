# README

. create a folder called popup_projects, clone popup_library
1. This app depends on Postgres, redis, ruby-3.22, rails 7. Ensure all are installed
2. Install gems
    ```
    bundle install
    ```
3. Create database and seed it
    ```
    rails db:create db:migrate db:seed
    ```
4. start the app
    ```
    foreman start -f Procfile.dev
    ```
5. Navigate to http://localhost:5000
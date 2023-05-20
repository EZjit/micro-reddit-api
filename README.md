MICRO-REDDIT API

--- Tested with RSpec ---

Installation:
1) copy repository
2) install gems: [bundle install]
3) create .env file with your PostgreSQL data (database name, username, password and port) and put it inside project directory. !!! Make sure that names of variables inside .env file are the same as those inside rails db config (app-directory/config/datamase.yml) !!!
4) migrate models: [rails db:migrate]
5) (optional) seed db with prepared data: [rails db:seed]
6) start server [rails s]

Notes:
This app using JWT for user authentication. All endpoints of application (except endpoint for user creation) will tell that you need to authenticate first, so first you will need to:
1) create user: [POST localhost:3000/api/v1/users/]. Post body example: { "user": { "username": "John Doe", "email": "johndoe@gmail.com", "password": "0oK9Ij^uh", "password_confirmation": "0oK9Ij^uh"
2) authenticate user: [POST localhost:3000/api/v1/auth/login]. Post body example: { "email": "johndoe@gmail.com", "password": "0oK9Ij^uh" }. You will recieve JWT token, copy it and user it in "Authorization" header of all your requrests.
3) Now you can hit any provided endpoint with your JWT token in authorization header.


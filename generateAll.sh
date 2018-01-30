#!/bin/bash

#jhipster --skip-server --with-entities --skip-user-management --auth=jwt --db=mariadb

HOME_DIR="$(pwd)"
cd "$HOME_DIR"/app; jhipster
cd "$HOME_DIR"/uaa; jhipster
cd "$HOME_DIR"/gateway-angular; jhipster
cd "$HOME_DIR"/docs; jhipster

cd "$HOME_DIR"/app; jhipster  entity testEntity --force
cd "$HOME_DIR"/gateway-angular; jhipster  entity testEntity --force

cd "$HOME_DIR"/app; ./mvnw verify -Pprod dockerfile:build -DskipTests
cd "$HOME_DIR"/uaa; ./mvnw verify -Pprod dockerfile:build -DskipTests
cd "$HOME_DIR"/docs; ./mvnw verify -Pprod -DskipTests dockerfile:build -DskipTests

cp -R "$HOME_DIR"/gateway-angular.patch/* "$HOME_DIR"/gateway-angular/
cd "$HOME_DIR"/gateway-angular; yarn run cleanup && yarn run webpack:build:main
cp -R "$HOME_DIR"/gateway-angular/build/www/* "$HOME_DIR"/docker-compose/nginx/www/angular1/
